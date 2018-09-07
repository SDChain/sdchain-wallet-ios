//
//  TradingCurrencyModel.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/25.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradingCurrencyModel : NSObject
@property(nonatomic,strong) NSString *counterparty;
@property(nonatomic,strong) NSString *currency;
@property(nonatomic,strong) NSString *limit;
@property(nonatomic,strong) NSString *pic;

+(TradingCurrencyModel *)modelWithDict:(NSDictionary *)dict;

-(void)initWithDict:(NSDictionary *)dict;

@end
