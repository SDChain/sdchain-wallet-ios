//
//  ContactModel.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/18.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

-(void)initWithDict:(NSDictionary *)dict{
    if([dict[@"realName"] isEqual:[NSNull null]]){
        self.realName = @"";
    }
    else{
        self.realName = dict[@"realName"];
    }
    if([dict[@"nickName"] isEqual:[NSNull null]]){
        self.nickName = @"";
    }
    else{
        self.nickName = dict[@"nickName"];
    }
    if(![dict[@"realName"] isEqual:[NSNull null]]){
        self.contactName = dict[@"realName"];
    }
    else if(![dict[@"nickName"] isEqual:[NSNull null]]){
        self.contactName = dict[@"nickName"];
    }
    else{
        self.contactName = dict[@"userName"];
    }
    
    self.userName = dict[@"userName"];
    self.userId = dict[@"userId"];
    self.account = dict[@"account"];
    
}

+(ContactModel *)modelWithDict:(NSDictionary *)dict{
    ContactModel *model = [[ContactModel alloc] init];
    [model initWithDict:dict];
    return model;
}

+(NSDictionary *)dictWithDict:(NSDictionary *)dict{
    NSDictionary *dic = [[NSDictionary alloc] init];
    NSString *contactName;
    if(![dict[@"realName"] isEqual:[NSNull null]]){
        contactName = dict[@"realName"];
    }
    else if(![dict[@"nickName"] isEqual:[NSNull null]]){
        contactName = dict[@"nickName"];
    }
    else{
        contactName = dict[@"userName"];
    }
    
    dic = @{@"contactName":contactName,
            @"userId":dict[@"userId"],
            @"account":dict[@"account"]
            };
    return dic;
}

@end
