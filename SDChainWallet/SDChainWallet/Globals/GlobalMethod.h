//
//  GlobalMethod.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/27.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethod : NSObject

//获取当前语言环境
+(NSString *)getCurrentLanguage;

//计时按钮
+ (void)startTime:(NSInteger)time sendAuthCodeBtn:(UIButton *)sendCodeBtn;

//跳转登录界面
+ (void)loginOutAction;

//返回带logo二维码
+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size centerImage:(UIImage *)centerImage;

//返回二维码
+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size;


+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

+ (void)loadImageFinished:(UIImage *)image baocunSuccess:(void(^)(void))baocunSuccess;

+ (NSInteger)getNumberOfDaysInMonthWithYear:(int)year month:(int)month;

+ (BOOL)validateIDCardNumber:(NSString *)value;

+(NSString*)getCurrentTimes;

//获取当前年月日

+(NSString *)htcTimeToLocationStr:(NSString*)strM;

//+ (NSString *)getUUID;

+ (UIImage *)getImageWithBase64StringWithString:(NSString *)string;

+(NSString *)getTimeWithdate:(NSString *)time;

+(NSString *)formatDouble:(double)df;

+(NSString *)getCurrentTimeTemp;

//时间戳转换成时间

+(NSString *)timeWithSecondStr:(NSString *)second;

//时间戳转换成年月日

+(NSString *)dateWithSecondStr:(NSString *)second;

@end
