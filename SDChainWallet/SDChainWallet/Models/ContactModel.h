//
//  ContactModel.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/18.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property(nonatomic,strong)NSString *contactName;
@property(nonatomic,strong)NSString *realName;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *account;

-(void)initWithDict:(NSDictionary *)dict;

+(ContactModel *)modelWithDict:(NSDictionary *)dict;

+(NSDictionary *)dictWithDict:(NSDictionary *)dict;

@end
