//
//  UserModel.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/16.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    UserModel *model = [[UserModel alloc] init];
    [model setupWithDict:dict];
    return model;
}

- (void)setupWithDict:(NSDictionary *)dict{
    self.userId = dict[@"id"];
    if (dict[@"userName"] && dict[@"userName"] != [NSNull null]) {
        self.userName = dict[@"userName"];
    }
    else{
        self.userName = @"";
    }
    if (dict[@"realName"] && dict[@"realName"] != [NSNull null]) {
        self.realName = dict[@"realName"];
    }
    else{
        self.realName = @"";
    }
    if (dict[@"nickname"] && dict[@"nickname"] != [NSNull null]) {
        self.nickname = dict[@"nickname"];
    }
    else{
        self.nickname = @"";
    }
    if (dict[@"idCode"] && dict[@"idCode"] != [NSNull null]) {
        self.idCode = dict[@"idCode"];
    }
    else{
        self.idCode = @"";
    }
    if (dict[@"phone"] && dict[@"phone"] != [NSNull null]) {
        self.mobile = dict[@"phone"];
    }
    else{
        self.mobile = @"";
    }
    if (dict[@"passwordKey"] && dict[@"passwordKey"] != [NSNull null]) {
        self.passwordKey = dict[@"passwordKey"];
    }
    else{
        self.passwordKey = @"";
    }
    if (dict[@"email"] && dict[@"email"] != [NSNull null]) {
        self.email = dict[@"email"];
    }
    else{
        self.email = @"";
    }
    if (dict[@"account"] && dict[@"account"] != [NSNull null]) {
        self.account = dict[@"account"];
    }
    else{
        self.account = @"";
    }
    if (dict[@"walletName"] && dict[@"walletName"] != [NSNull null]) {
        self.walletName = dict[@"walletName"];
    }
    else{
        self.walletName = @"";
    }
    if (dict[@"userAccountId"] && dict[@"userAccountId"] != [NSNull null]) {
        self.userAccountId = dict[@"userAccountId"];
    }
    else{
        self.userAccountId = @"";
    }
    if (dict[@"type"] && dict[@"type"] != [NSNull null]) {
        self.type = [self typeWithString:[dict[@"type"] stringValue]];
    }
    else{
        self.type = typeUnActive;
    }
    if (dict[@"apptoken"] && dict[@"apptoken"] != [NSNull null]) {
        self.apptoken = dict[@"apptoken"];
    }
    if([self.userName containsString:@"@"]){
        self.areaCode = @"";
    }else{
        if (dict[@"areaCode"] && dict[@"areaCode"] != [NSNull null]) {
            self.areaCode = dict[@"areaCode"];
        }else{
            self.areaCode = @"";
        }
    }
}

-(ActiveType)typeWithString:(NSString *)str{
    if([str isEqualToString:@"1"]){
        return typeActived;
    }else{
        return typeUnActive;
    }
}



@end
