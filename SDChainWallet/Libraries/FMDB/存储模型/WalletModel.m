//
//  WalletModel.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/19.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel

-(WalletModel *)configureWithUserAccountId:(NSString *)userAccountId name:(NSString *)name account:(NSString *)account isDefault:(NSString *)isDefault;{
    self.userAccountId = userAccountId;
    self.name = name;
    self.account = account;
    self.isDefault = isDefault;
    return self;
}

@end
