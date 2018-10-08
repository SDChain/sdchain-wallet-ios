//
//  NSString+COD.m
//  CutOrder
//
//  Created by yhw on 14-10-13.
//  Copyright (c) 2014年 YuQian. All rights reserved.
//

#import "NSString+COD.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const kSPECIAL_CHARACTER = @"!*'();:@&=+$,/?%#[]";
@implementation NSString (COD)

- (NSString *)cod_md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);// This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
+ (NSString*)cod_getMD5WithData:(NSData *)data{
    const char* cStr = (const char *)[data bytes];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);// This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
    
}


- (NSString *)cod_urlEncoded {
	if (![self length])
		return @"";

	CFStringRef static const charsToEscape = CFSTR(".:/");
	CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
	                                                                    (__bridge CFStringRef)self,
	                                                                    NULL,
	                                                                    charsToEscape,
	                                                                    kCFStringEncodingUTF8);
	return (__bridge_transfer NSString *)escapedString;
}

- (NSString *)cod_urlDecoded {
	if (![self length])
		return @"";

	CFStringRef unescapedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
	                                                                                      (__bridge CFStringRef)self,
	                                                                                      CFSTR(""),
	                                                                                      kCFStringEncodingUTF8);
	return (__bridge_transfer NSString *)unescapedString;
}

- (BOOL)cod_isChinaMobile {
    NSString *regex = @"^1[0-9][0-9]\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)cod_isEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)cod_isVerificationCode {
    NSString *regex = @"^[0-9]{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)cod_isChinaBankCard {
    NSUInteger s1 = 0, s2 = 0;
    for (NSUInteger i = 0 ; i < self.length; i++) {
        NSUInteger digit = (NSUInteger)[self characterAtIndex:i];
        if (i % 2 == 0) {
            s1 += digit;
        } else {
            s2 += 2 * digit;
            if (digit >= 5) {
                s2 -= 9;
            }
        }
    }
    return (s1 + s2) % 10 == 0;
}

- (CGFloat)cod_heightWithWidth:(CGFloat)width height:(CGFloat)height font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending)) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        return size.height;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lineBreakMode];
        return size.height;
#pragma clang diagnostic pop
    }
}

- (CGFloat)cod_widthWithWidth:(CGFloat)width height:(CGFloat)height font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending)) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        return size.width;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, height) lineBreakMode:lineBreakMode];
        return size.width;
#pragma clang diagnostic pop
    }
}

- (NSInteger)cod_wordCount {
    NSUInteger i, n = [self length], l = 0,a = 0,b = 0;
    unichar c;
    for(i = 0;i < n;i++){
        c = [self characterAtIndex:i];
        if(isblank(c)) {
            b++;
        } else if(isascii(c)){
            a++;
        } else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(NSUInteger)ceilf((CGFloat)(a+b)/2.0);
}
#pragma mark nsstring json
+(NSString *)cod_jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}
+(NSString *)cod_jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString cod_jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
+(NSString *)cod_jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString cod_jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString cod_jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString cod_jsonStringWithArray:object];
    }
    else
    {
        return object;
    }
    return value;
}
+(NSString *)cod_jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString cod_jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *)cod_timeStyleWithString:(NSString *)time
{
    if (time.length>11) {
        NSString *str1=[time substringWithRange:NSMakeRange(0, 4)];
        NSString *str2=[time substringWithRange:NSMakeRange(4, 2)];
        NSString *str3=[time substringWithRange:NSMakeRange(6, 2)];
        NSString *str4=[time substringWithRange:NSMakeRange(8, 2)];
        NSString *str5=[time substringWithRange:NSMakeRange(10, 2)];
        return [NSString stringWithFormat:@"%@-%@-%@ %@:%@",str1,str2,str3,str4,str5];
    }
    else
        return @"2015-11-11 22:00";
}
//计时器
+(NSString *)cod_TimerCountWith:(int)time
{
    int d,h,m,s;
    d=time/86400;//天数
    h=time%86400/3600;//小时
    m=time/60;//分钟
    s=time%3600%60;//秒
    NSString *str1=nil;
    NSString *str2=nil;
    NSString *str3=nil;
    if (h<10) {
        str1=[NSString stringWithFormat:@"0%d",h];
    }
    else
    {
        str1=[NSString stringWithFormat:@"%d",h];
    }
    if (m<10) {
        str2=[NSString stringWithFormat:@"0%d",m];
    }
    else
    {
        str2=[NSString stringWithFormat:@"%d",m];
    }
    if (s<10) {
        str3=[NSString stringWithFormat:@"0%d",s];
    }
    else
    {
        str3=[NSString stringWithFormat:@"%d",s];
    }
    if (d>0) {
        // return [NSString stringWithFormat:@"%d天 %@:%@:%@",d,str1,str2,str3];
        return [NSString stringWithFormat:@"%d天",d];
    }
    else
    {
        return [NSString stringWithFormat:@"%@:%@",str2,str3];
    }
    
}

#pragma mark 临时存储
+(NSString *)cod_getUserDefaultsValue:(NSString *) key
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

+(void)cod_setUserDefaultsValue:(id) value forKey:(NSString *)key
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:key];
    [ud synchronize];
}

+(void)cod_removeUserDefaultsValue:(NSString *) key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (NSString *)escapeURIComponent {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                    (CFStringRef)self,
                                                                                                    NULL,
                                                                                                    (CFStringRef)kSPECIAL_CHARACTER,
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}

- (NSString *)MD5Encode {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *string = [NSString stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                        ];
    return [string lowercaseString];
}

@end
