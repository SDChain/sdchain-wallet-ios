//
//  GlobalMethod.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/27.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethod : NSObject

//Get the current locale
+(NSString *)getCurrentLanguage;

//Timing button
+ (void)startTime:(NSInteger)time sendAuthCodeBtn:(UIButton *)sendCodeBtn;

//Jump login interface
+ (void)loginOutAction;

//Return with logo QR code
+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size centerImage:(UIImage *)centerImage;

//Return QR code
+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size;

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

+ (void)loadImageFinished:(UIImage *)image baocunSuccess:(void(^)(void))baocunSuccess;

+ (NSInteger)getNumberOfDaysInMonthWithYear:(int)year month:(int)month;

+ (BOOL)validateIDCardNumber:(NSString *)value;

+(NSString*)getCurrentTimes;

//Get the current year, month, and day

+(NSString *)htcTimeToLocationStr:(NSString*)strM;

//+ (NSString *)getUUID;

+ (UIImage *)getImageWithBase64StringWithString:(NSString *)string;

+(NSString *)getTimeWithdate:(NSString *)time;

+(NSString *)formatDouble:(double)df;

//Timestamp converted to time

+(NSString *)timeWithSecondStr:(NSString *)second;

//Time stamp converted to year, month and day

+(NSString *)dateWithSecondStr:(NSString *)second;

@end
