//
//  ShouxinRecordModel.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/30.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShouxinRecordModel : NSObject

@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *value;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *issuer;
@property(nonatomic,strong)NSString *pic;

+(instancetype)modelWithDict:(NSDictionary *)dict;

-(void)initWithDict:(NSDictionary *)dict;

@end
