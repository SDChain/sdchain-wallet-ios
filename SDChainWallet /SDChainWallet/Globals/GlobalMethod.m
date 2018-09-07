//
//  GlobalMethod.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/27.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "GlobalMethod.h"
#import "HTTPRequestManager.h"
#import <Photos/Photos.h>

@implementation GlobalMethod

+(NSString *)getCurrentLanguage{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSLog(@"当前语言:%@", preferredLang);
    
    if([preferredLang containsString:@"zh-Hant"]){
        return @"tc";
    }else if([preferredLang containsString:@"en"]){
        return @"en";
    }
    else {
        return @"cn";       //zh-Hans-CN
    }
}


+ (void)startTime:(NSInteger)time sendAuthCodeBtn:(UIButton *)sendAuthCodeBtn {
    if (time > 59 || time < 1) {
        time = 59;
    }
    __block NSInteger timeout = time; //Countdown time
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //Execute every second
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) { //Countdown ends, closes
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //Button display of the setting interface
                [sendAuthCodeBtn setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
                NSString *title = NSLocalizedStringFromTable(@"发送验证码", @"guojihua", nil);
                [sendAuthCodeBtn setTitle:title forState:UIControlStateNormal];
                // iOS 7
                [sendAuthCodeBtn setTitle:title forState:UIControlStateDisabled];
                sendAuthCodeBtn.enabled = YES;
            });
        } else {
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sendAuthCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [sendAuthCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                // iOS 7
                [sendAuthCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateDisabled];
                sendAuthCodeBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

+ (void)loginOutAction{
    SYSTEM_SET_(nil, USER_ID);
    SYSTEM_SET_(nil, PASSWORDKEY);
    SYSTEM_SET_(nil, ACCOUNT);
    SYSTEM_SET_(nil, WALLETNAME);
    SYSTEM_SET_(nil, USERACCOUNTID);
    SYSTEM_SET_(nil, TYPE);
    SYSTEM_SET_(nil, APPTOKEN);
    LoginMainViewController *scene = [[LoginMainViewController alloc] initWithNibName:@"LoginMainViewController" bundle:nil];
    BaseNavigationController *navi  = [[BaseNavigationController alloc] initWithRootViewController:scene];
    [[UIApplication sharedApplication] keyWindow].rootViewController = navi;
    
}

+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size centerImage:(UIImage *)centerImage{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSString *urlStr = string;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *meImage = centerImage;
    CGFloat meImageW = 50;
    CGFloat meImageH = 50;
    CGFloat meImageX = (image.size.width - meImageW) * 0.5;
    CGFloat meImageY = (image.size.height - meImageH) * 0.5;
    [meImage drawInRect:CGRectMake(meImageX, meImageY, meImageW, meImageH)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:170];
}


/**
 * Generate a UIImage of the specified size based on CIImage
 *
 * @param image CIImage
 * @param size Image width
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (void)loadImageFinished:(UIImage *)image baocunSuccess:(void(^)(void))baocunSuccess
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //Write image to album
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //Record the local ID, and wait for the image object in the album to be completed.
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        if (success)
        {
            //Take the picture object in the album after success
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                imageAsset = obj;
                *stop = YES;
            }];
            if (imageAsset)
            {
                //Load image data
                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                                                                  options:nil
                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                                NSLog(@"imageData = %@", imageData);
                                                                if(baocunSuccess){
                                                                    baocunSuccess();
                                                                }
                                                            }];
            }
        }
    }];
}

//How many days in a month
+ (NSInteger)getNumberOfDaysInMonthWithYear:(int)year month:(int)month
{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    long length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // Provincial code
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//Test the legality of the date of birth
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//Test the legality of the date of birth
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
            
            break;
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//Test the legality of the date of birth
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//Test the legality of the date of birth
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// Judgment check digit
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// Check the check digit of the ID
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
            break;
        default:
            return NO;
            break;
    }
}


+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------Set the format you want, the difference between hh and HH: 12 hour system, 24 hour system
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //Now time, you can output to see what format is
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

+(NSString *)htcTimeToLocationStr:(NSString*)strM{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *dateFormatted = [dateFormatter dateFromString:strM];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *locationTimeString=[dateFormatter stringFromDate:dateFormatted];
    return locationTimeString;
}

//+ (NSString *)getUUID{
//    return [FCUUID uuid];
//}

+ (UIImage *)getImageWithBase64StringWithString:(NSString *)string{

    NSString *encodedImageStr = string;
    
    NSData *decodedImgData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImgData];
    return  decodedImage;
}

+(NSString *)getTimeWithdate:(NSString *)time{
    NSTimeInterval interval    =[time doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

+(NSString *)formatDouble:(double)df{

    if (fmodf(df, 1)==0) {//If there are 0 decimal places
            NSLog(@"1");
        return [NSString stringWithFormat:@"%.0f",df];
    } else if (fmodf(df*10, 1)==0) {//If there is 1 decimal point
            NSLog(@"2");
        return [NSString stringWithFormat:@"%.1f",df];
    } else if (fmodf(df*100, 1)==0) {//If there are 2 decimal points
            NSLog(@"3");
        return [NSString stringWithFormat:@"%.2f",df];
    } else if (fmodf(df*1000, 1)==0) {//If there are 3 decimal points
            NSLog(@"4");
        return [NSString stringWithFormat:@"%.3f",df];
    } else if (fmodf(df*10000, 1)==0) {//If there are 4 decimal places
            NSLog(@"5");
        return [NSString stringWithFormat:@"%.4f",df];
    } else if (fmodf(df*100000, 1)==0) {//If there are 5 decimal points
            NSLog(@"6");
        return [NSString stringWithFormat:@"%.5f",df];
    } else if (fmodf(df*1000000, 1)==0) {//If there are 6 decimal places
        NSLog(@"7");
        return [NSString stringWithFormat:@"%.6f",df];
    } else if (fmodf(df*10000000, 1)==0) {//If there are 7 decimal places
        NSLog(@"8");
        return [NSString stringWithFormat:@"%.7f",df];
    } else if (fmodf(df*100000000, 1)==0) {//If there are 8 decimal places
        NSLog(@"9");
        return [NSString stringWithFormat:@"%.8f",df];
    } else {
            NSLog(@"10");
        return [NSString stringWithFormat:@"%.9f",df];
    }
}

+(NSString *)timeWithSecondStr:(NSString *)second{
    
    NSTimeInterval interval    = [second doubleValue];
    if(second.length>12){
        interval = interval/1000;
    }
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

+(NSString *)dateWithSecondStr:(NSString *)second{
    NSTimeInterval interval    = [second doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

@end
