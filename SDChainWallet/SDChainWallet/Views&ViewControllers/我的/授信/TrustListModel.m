//
//  TrustListModel.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/27.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "TrustListModel.h"

@implementation TrustListModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    TrustListModel *model = [[TrustListModel alloc] init];
    [model initWithDict:dict];
    return model;
}

-(void)initWithDict:(NSDictionary *)dict{
    self.counterparty = dict[@"counterparty"];
    self.currency = dict[@"currency"];
    self.limit = dict[@"limit"];
    self.pic = dict[@"pic"];
    self.trusted = [dict[@"trusted"] stringValue];
}

@end
