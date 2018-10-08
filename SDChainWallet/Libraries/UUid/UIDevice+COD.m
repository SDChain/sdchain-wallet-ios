//
//  UIDevice+COD.m
//  CutOrder
//
//  Created by yhw on 14/12/4.
//  Copyright (c) 2014年 YuQian. All rights reserved.
//

#import "UIDevice+COD.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "NSString+COD.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation UIDevice (COD)

- (NSString *)cod_sysInfoByName:(char *)typeSpecifier {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = @(answer);
    
    free(answer);
    return results;
}

- (NSString *)cod_hostname {// retun the host name
    char baseHostName[256];
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '\0';
    
#if !TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#else
    return [NSString stringWithFormat:@"%s", baseHostName];
#endif
}

- (NSString *)cod_findIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self cod_findIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ?: @"0.0.0.0";
}

- (NSDictionary *)cod_findIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = @(interface->ifa_name);
                if(addr->sin_family == AF_INET) {
                    char addrBuf[INET_ADDRSTRLEN];
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                        NSString *key = [NSString stringWithFormat:@"%@/%@", name, IP_ADDR_IPv4];
                        addresses[key] = @(addrBuf);
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    char addrBuf[INET6_ADDRSTRLEN];
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, sizeof(addrBuf))) {
                        NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                        addresses[key] = @(addrBuf);
                    }
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - Public methods
- (NSString *)cod_model {
    return [self cod_sysInfoByName:"hw.machine"];
}

- (NSString *)cod_macAddress {
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *)cod_ipAddress {
    /*
     struct hostent *host = gethostbyname([[self hostname] UTF8String]);
     if (!host) {
     herror("resolv"); return nil;
     }
     struct in_addr **list = (struct in_addr **)host->h_addr_list;
     return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
     */
    return [self cod_findIPAddress:YES];
}

- (NSString *)cod_uuid {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6" options:NSNumericSearch] == NSOrderedAscending) {
        NSString *macAddress = [self cod_macAddress];
        NSString *uuid = [macAddress cod_md5];
        return uuid;
    }
    else {
        NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        return uuid;
    }
}

@end
