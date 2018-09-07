//
//  BalanceModel.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/26.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "BalanceModel.h"

@implementation BalanceModel

-(void)initWithDict:(NSDictionary *)dict{
    self.counterparty = dict[@"counterparty"];
    self.currency = dict[@"currency"];
    self.value = dict[@"value"];
}

+(BalanceModel *)modelWithDict:(NSDictionary *)dict{
    BalanceModel *model = [[BalanceModel alloc] init];
    [model initWithDict:dict];
    return model;
}

@end
