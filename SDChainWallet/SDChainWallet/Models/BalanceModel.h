//
//  BalanceModel.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/26.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceModel : NSObject

@property(nonatomic,strong)NSString *counterparty;
@property(nonatomic,strong)NSString *currency;
@property(nonatomic,strong)NSString *value;

-(void)initWithDict:(NSDictionary *)dict;
+(BalanceModel *)modelWithDict:(NSDictionary *)dict;


@end
