//
//  WalletModel.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/19.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "JKDBModel.h"

@interface WalletModel : JKDBModel

@property(nonatomic,strong)NSString *account;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *userAccountId;

@property(nonatomic,strong)NSString *isDefault;

-(WalletModel *)configureWithUserAccountId:(NSString *)userAccountId name:(NSString *)name account:(NSString *)account isDefault:(NSString *)isDefault;

@end
