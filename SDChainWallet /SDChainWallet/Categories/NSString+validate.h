//
//  NSString+validate.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/15.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (validate)

+ (BOOL)valiMobile:(NSString *)mobile;

+ (BOOL)testCodeNumber:(NSString *)text;

+ (BOOL)validateEmail:(NSString *)email;

+ (BOOL)validatePassword:(NSString *)password;

@end
