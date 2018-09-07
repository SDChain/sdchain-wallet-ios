//
//  TradingCurrencyModel.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/25.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "TradingCurrencyModel.h"

@implementation TradingCurrencyModel

+(TradingCurrencyModel *)modelWithDict:(NSDictionary *)dict{
    TradingCurrencyModel *model  = [[TradingCurrencyModel alloc] init];
    [model initWithDict:dict];
    return model;
}

-(void)initWithDict:(NSDictionary *)dict{
    self.counterparty = dict[@"counterparty"];
    self.currency = dict[@"currency"];
    self.limit = dict[@"limit"];
    self.pic = dict[@"pic"];
    
}

@end
