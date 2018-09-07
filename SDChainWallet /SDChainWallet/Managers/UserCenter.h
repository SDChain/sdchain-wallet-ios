//
//  UserCenter.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/16.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserCenter : NSObject

@property (nonatomic, strong) UserModel * userModel;

+ (UserCenter *)sharedInstance;

- (UserCenter *)sharedInstance;

- (void)setupWithData:(id)data;

- (void)clear;


@end
