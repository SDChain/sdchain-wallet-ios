//
//  NSString+COD.h
//  CutOrder
//
//  Created by yhw on 14-10-13.
//  Copyright (c) 2014年 YuQian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (COD)

- (NSString *)cod_md5;
+ (NSString *)cod_getMD5WithData:(NSData *)data;

- (NSString *)cod_urlEncoded;
- (NSString *)cod_urlDecoded;

- (BOOL)cod_isChinaMobile;// 手机
- (BOOL)cod_isEmail;// 邮箱
- (BOOL)cod_isVerificationCode;// 验证码
- (BOOL)cod_isChinaBankCard;// 银行卡

- (CGFloat)cod_heightWithWidth:(CGFloat)width height:(CGFloat)height font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)cod_widthWithWidth:(CGFloat)width height:(CGFloat)height font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (NSInteger)cod_wordCount;

+ (NSString *)cod_jsonStringWithString:(NSString *) string;//nsstring转化成json
+ (NSString *)cod_jsonStringWithDictionary:(NSDictionary *)dictionary;//nsdictionary json
+ (NSString *)cod_timeStyleWithString:(NSString *)time;//转化成显示时间
+ (NSString *)cod_TimerCountWith:(int)time;//计时器

#pragma mark 临时存储
+ (NSString *) cod_getUserDefaultsValue:(NSString *) key;
+ (void) cod_setUserDefaultsValue:(id) value forKey:(NSString *)key;
+ (void) cod_removeUserDefaultsValue:(NSString *) key;

/**
 *  将字符串转换成可用于URL中的字符串，主要是将一些特殊字符进行转换
 *
 *  @return 转换之后的字符串
 */
- (NSString *)escapeURIComponent;

/**
 *  获取当前字符串的MD5值
 *
 *  @return 字符串的MD5值
 */
- (NSString *)MD5Encode;

@end
