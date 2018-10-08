//
//  ShouxinRecordModel.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/30.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "ShouxinRecordModel.h"

@implementation ShouxinRecordModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    ShouxinRecordModel *model = [[ShouxinRecordModel alloc] init];
    [model initWithDict:dict];
    return model;
}

-(void)initWithDict:(NSDictionary *)dict{
    self.date = dict[@"date"];
    self.value = dict[@"value"];
    self.code = dict[@"code"];
    self.issuer = dict[@"issuer"];
    self.pic = dict[@"pic"];
}

@end
