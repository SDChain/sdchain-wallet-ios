//
//  UserCenter.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/16.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "UserCenter.h"

@implementation UserCenter

+ (UserCenter *)sharedInstance {
    static dispatch_once_t once;
    static UserCenter * __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } );
    return __singleton__;
}

- (UserCenter *)sharedInstance {
    return [UserCenter sharedInstance];
}

- (void)setupWithData:(id)data {
    self.userModel = [UserModel modelWithDict:data];
}

- (void)clear {
    self.userModel = nil;
}


@end
