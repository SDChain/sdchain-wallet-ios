//
//  UserModel.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/16.
//  Copyright © 2018年 HengWei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ActiveType) {
    typeUnActive,    // 男性
    typeActived,  // 女性
};

@interface UserModel : NSObject

@property (nonatomic, copy) NSString * userId;          // 用户ID
@property (nonatomic, copy) NSString * userName;        // 用户名
@property (nonatomic, copy) NSString * realName;        // 真实姓名（可为空）
@property (nonatomic, copy) NSString * nickname;        // 昵称（可为空）
@property (nonatomic, copy) NSString * idCode;          // 身份证号码（可为空）
@property (nonatomic, copy) NSString * mobile;          // 绑定的手机号（可为空）
@property (nonatomic, copy) NSString * passwordKey;     // 密码（经过加密，用作解密私钥的key）
@property (nonatomic, copy) NSString * email;           // 邮箱（可为空）
@property (nonatomic, copy) NSString * account;         // 默认钱包
@property (nonatomic, copy) NSString * walletName;      // 默认钱包的名称
@property (nonatomic, copy) NSString * userAccountId;   // 钱包地址Id
@property (nonatomic, assign) ActiveType type;            // 是否激活 0未激活1已激活
@property (nonatomic, copy) NSString * apptoken;        // token

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (void)setupWithDict:(NSDictionary *)dict;

@end
