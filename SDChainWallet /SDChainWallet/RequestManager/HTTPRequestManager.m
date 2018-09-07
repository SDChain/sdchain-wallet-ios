//
//  HTTPRequestManager.m
//  BaseProject6.15
//
//  Created by 钱伟成 on 2017/6/22.
//  Copyright © 2017年 Zeepson. All rights reserved.
//

#import "HTTPRequestManager.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NSString+AES.h"
#import "UIDevice+COD.h"

//#import "UserCenter.h"

@interface HTTPRequestManager ()

@property (strong, nonatomic) AFHTTPSessionManager * httpSessionManager;
@property (nonatomic,strong) NSString *languageType;

@end

@implementation HTTPRequestManager

DEF_SINGLETON(HTTPRequestManager)


- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)logWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    //#ifdef DEBUG
    NSLog(@"\n<--\n%@\n%@\n%@\n-->\n", task.currentRequest.URL, task.taskDescription, responseObject);
    //#endif
}

- (void)logWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    //#ifdef DEBUG
    NSLog(@"\n<--\n%@\n%@\n%@\n-->\n", task.currentRequest.URL, task.taskDescription, error);
    //#endif
}

+(void)appLoginWithUserName:(NSString *)userName passWord:(NSString *)passWord showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/login"];
    
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userName":userName,
                                @"password":passWord,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
//                NSLog(@"%@",(responseObject[@"message"]);
                warn(responseObject[@"message"]);
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)getRandomCodePicWithMachineId:(NSString *)machineId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"sms/getRandomCodePic"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"machineId":machineId,
                                @"languageType":languageType};
    if(showProgress){
        [manager showProgressHUD];
    }
    
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        if([responseObject[@"code"] isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
        
        NSLog(@"%@",responseObject[@"message"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)loginGetVerifyingCodeWithMobile:(NSString *)mobile machineId:(NSString *)machineId imageCode:(NSString *)imageCode mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"sms/getPhoneCode"];
    NSString *encryptStr = [mobile aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"account":mobile,
                                @"mark":mark,
                                @"validStr":encryptStr,
                                @"machineId":machineId,
                                @"randomPic":imageCode,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        if([responseObject[@"code"] isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
        
        NSLog(@"%@",responseObject[@"message"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)loginGetVerifyingCodeWithEmail:(NSString *)email machineId:(NSString *)machineId imageCode:(NSString *)imageCode mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"sms/getEmailCode"];
    NSString *encryptStr = [mark aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"account":email,
                                @"mark":mark,
                                @"validStr":encryptStr,
                                @"machineId":machineId,
                                @"randomPic":imageCode,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        if([responseObject[@"code"] isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)GetVerifyingCodeWithMobile:(NSString *)mobile mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"sms/getPhoneCode"];
    NSString *encryptStr = [mobile aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"account":mobile,
                                @"mark":mark,
                                @"validStr":encryptStr,
                                @"languageType":languageType};
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        if([responseObject[@"code"] isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }

        NSLog(@"%@",responseObject[@"message"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)GetVerifyingCodeWithEmail:(NSString *)email mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"sms/getEmailCode"];
    NSString *encryptStr = [mark aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"account":email,
                                @"mark":mark,
                                @"validStr":encryptStr,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        if([responseObject[@"code"] isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)registWithMobile:(NSString *)mobile codeId:(NSString *)codeId code:(NSString *)code showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/registByPhone"];
    NSString *encryptStr = [mobile aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"account":mobile,
                                @"id":codeId,
                                @"code":code,
                                @"validStr":encryptStr,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        if([responseObject[@"code"] isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)registWithEmail:(NSString *)email codeId:(NSString *)codeId code:(NSString *)code showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *encryptStr = [codeId aci_encryptWithAES];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/registByEmail"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"account":email,
                                @"id":codeId,
                                @"code":code,
                                @"validStr":encryptStr,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        if([responseObject[@"code"] isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)registWithUserName:(NSString *)userName passWord:(NSString *)passWord smsId:(NSString *)smsId walletPassword:(NSString *)walletPassword phone:(NSString *)phone email:(NSString *)email showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/regist"];
    NSString *encryptStr = [smsId aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:@{@"userName":userName,
                                                                                     @"password":passWord,
                                                                                     @"smsId":smsId,
                                                                                     @"walletPassword":walletPassword,
                                                                                     @"validStr":encryptStr,
                                                                                     @"languageType":languageType
                                                                                     }];
    if(phone != nil){
        [parameter setObject:phone forKey:@"phone"];
    }
    if(email != nil){
        [parameter setObject:email forKey:@"email"];
    }
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
        
    }];
    
}

+(void)forgetSecretWithUserName:(NSString *)userName password:(NSString *)password showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/forgetPassword"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userName":userName,
                                @"password":password,
                                @"languageType":languageType};
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
        
    }];
    
}

+(void)updateLoginPasswordWithOldPassword:(NSString *)oldPassword password:(NSString *)password smsId:(NSString *)smsId code:(NSString *)code mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/updatePassword"];
    NSString *encryptStr = [SYSTEM_GET_(USER_ID) aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"id":SYSTEM_GET_(USER_ID),
                                @"validStr":encryptStr,
                                @"oldPassword":oldPassword,
                                @"password":password,
                                @"smsId":smsId,
                                @"code":code,
                                @"mark":mark,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
        
    }];
    
}

+(void)paymentchangeDefaultWalletWithId:(NSString *)userId account:(NSString *)account showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/changeDefaultWallet"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"id":userId,
                                @"account":account,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType};
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
        
    }];
}

+(void)paymentwalletListWithUserId:(NSString *)userId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/walletList"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":userId,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)leadinWalletWithWalletPassword:(NSString *)walletPassword walletPrivitySecret:(NSString *)walletPrivitySecret walletAccount:(NSString *)walletAccount showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/importWallet"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"walletPassword":walletPassword,
                                @"secret":walletPrivitySecret,
                                @"account":walletAccount,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)createWalletWithPassword:(NSString *)password showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/createWallet"];
    NSString *encryptStr = [SYSTEM_GET_(USER_ID) aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"id":SYSTEM_GET_(USER_ID),
                                @"validStr":encryptStr,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"walletPassword":password,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)getWalletSecretWithUserAccountId:(NSString *)userAccountId walletPassword:(NSString *)walletPassword showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/getWalletSecret"];
    NSString *encryptStr = [SYSTEM_GET_(USER_ID) aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"id":SYSTEM_GET_(USER_ID),
                                @"userAccountId":userAccountId,
                                @"validStr":encryptStr,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"walletPassword":walletPassword,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)walletActiveActionWithUserAccountId:(NSString *)userAccountId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/activation"];
    NSString *encryptStr = [userAccountId aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userAccountId":userAccountId,
                                @"validStr":encryptStr,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType};
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
    
}

+(void)fixWalletNameWithUserId:(NSString *)userId accountName:(NSString *)accountName userAccountId:(NSString *)userAccountId apptoken:(NSString *)apptoken showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/updateAccountname"];
    NSString *encryptStr = [userId aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":userId,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"userAccountId":userAccountId,
                                @"accountName":accountName,
                                @"validStr":encryptStr,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)fixWalletSecretWithId:(NSString *)UserId userAccountId:(NSString *)userAccountId apptoken:(NSString *)apptoken walletPassword:(NSString *)walletPassword newWalletPassword:(NSString *)newWalletPassword showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/updateWalletPassword"];
    NSString *encryptStr = [UserId aci_encryptWithAES];
   NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"id":UserId,
                                @"userAccountId":userAccountId,
                                @"apptoken":apptoken,
                                @"walletPassword":walletPassword,
                                @"newWalletPassword":newWalletPassword,
                                @"validStr":encryptStr,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)forgetWalletPasswordWithNewWallletPassword:(NSString *)newWalletPassword secret:(NSString *)secret showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/forgetWalletPassword"];
    NSString *encryptStr = [SYSTEM_GET_(USER_ID) aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"id":SYSTEM_GET_(USER_ID),
                                @"userAccountId":SYSTEM_GET_(USERACCOUNTID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"newWalletPassword":newWalletPassword,
                                @"validStr":encryptStr,
                                @"secret":secret,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)paymentissueCurrencyWithDestinationAccount:(NSString *)destinationAccount value:(NSString *)value currency:(NSString *)currency memo:(NSString *)memo walletPassword:(NSString *)walletPassword userId:(NSString *)userId apptoken:(NSString *)apptoken userAccountId:(NSString *)userAccountId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/issueCurrency"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"destinationAccount":destinationAccount,
                                @"value":value,
                                @"currency":currency,
                                @"memo":memo,
                                @"walletPassword":walletPassword,
                                @"userId":userId,
                                @"apptoken":apptoken,
                                @"userAccountId":userAccountId,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
    
}

+(void)getPaymentsListWithUseraccountId:(NSString *)userAccountId page:(NSString *)page currency:(NSString *)currency minDate:(NSString *)minDate maxDate:(NSString *)maxDate showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/getPaymentsList"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:@{@"userAccountId":userAccountId,
                                                                                     @"marker":page,
                                                                                     @"apptoken":SYSTEM_GET_(APPTOKEN),
                                                                                     @"languageType":languageType
                                                                                     }];
    if(currency != nil){
        parameter[@"currency"] = currency;
    }
    if(minDate != nil){
        parameter[@"minDate"] = minDate;
    }
    if(maxDate != nil){
        parameter[@"maxDate"] = maxDate;
    }

    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)getPaymentsListWithUseraccountId:(NSString *)userAccountId hash:(NSString *)hash showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/getPaymentsInfo"];
    NSDictionary *parameter = @{@"userAccountId":userAccountId,
                                @"hash":hash,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)getMessagesListWithPage:(NSNumber *)page showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    [[JKDBHelper shareInstance] changeDBWithDirectoryName:WALLETSTABLE];
    NSArray *currentList = [WalletModel findByCriteria:[NSString stringWithFormat:@" WHERE isDefault = '%@' ",@"1"]];
    WalletModel *model = currentList[0];
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/getMessageList"];
    NSString *encryptStr = [SYSTEM_GET_(USER_ID) aci_encryptWithAES];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userAccountId":model.userAccountId,
                                @"page":page,
                                @"validStr":encryptStr,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"userId":SYSTEM_GET_(USER_ID),
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)getBalanceWithAccount:(NSString *)account userId:(NSString *)userId appToken:(NSString *)appToken showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/getBalance"];
    NSDictionary *parameter = @{@"account":account,
                                @"userId":userId,
                                @"apptoken":appToken,
                                @"languageType":languageType};
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
    
}

+(void)getFriendsListWithUserId:(NSString *)userId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/searchFriend"];
    NSString *encryptStr = [userId aci_encryptWithAES];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":userId,
                                @"validStr":encryptStr,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)getFriendInfoWithAdverseUserId:(NSString *)adverseUserId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/getFriendInfo"];
    NSString *encryptStr = [SYSTEM_GET_(USER_ID) aci_encryptWithAES];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"validStr":encryptStr,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"adverseUserId":adverseUserId,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)searchUserWithUserName:(NSString *)userName showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/searchUser"];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userName":userName,
                                @"languageType":languageType};
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)addFriendWithAdverseUserId:(NSString *)adverseUserId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/addFriend"];
    NSString *encryptStr = [SYSTEM_GET_(USER_ID) aci_encryptWithAES];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"validStr":encryptStr,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"adverseUserId":adverseUserId,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)deleteFriendWithAdverseUserId:(NSString *)adverseUserId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/deleteFriend"];
    NSString *encryptStr = [SYSTEM_GET_(USER_ID) aci_encryptWithAES];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"validStr":encryptStr,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"adverseUserId":adverseUserId,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)bindPhoneWithSmsId:(NSString *)smsId userId:(NSString *)userId code:(NSString *)code password:(NSString *)password apptoken:(NSString *)apptoken phone:(NSString *)phone showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/bindPhone"];
    NSString *encryptStr = [smsId aci_encryptWithAES];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"smsId":smsId,
                                @"userId":userId,
                                @"apptoken":apptoken,
                                @"phone":phone,
                                @"password":password,
                                @"validStr":encryptStr,
                                @"code":code,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)bindEmailWithSmsId:(NSString *)smsId code:(NSString *)code password:(NSString *)password email:(NSString *)email showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/bindEmail"];
    NSString *encryptStr = [smsId aci_encryptWithAES];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"smsId":smsId,
                                @"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"email":email,
                                @"password":password,
                                @"validStr":encryptStr,
                                @"code":code,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)realNameCertificationWithIdCode:(NSString *)idCode realName:(NSString *)realName showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/realName"];
    NSString *encryptStr = [idCode aci_encryptWithAES];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"id":SYSTEM_GET_(USER_ID),
                                @"idCode":idCode,
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"realName":realName,
                                @"validStr":encryptStr,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)updateNickNameWithNickName:(NSString *)nickName showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"user/updateNickname"];
    NSString *encryptStr = [SYSTEM_GET_(USER_ID) aci_encryptWithAES];
NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"id":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"validStr":encryptStr,
                                @"nickName":nickName,
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+(void)getTrustlinesWithAccount:(NSString *)account showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/getCurrencyLists"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType,
                                @"account":account,
                                @"page":@"1",
                                @"code":@""
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)trustlineWithUserAccountId:(NSString *)userAccountId walletPassword:(NSString *)walletPassword limit:(NSString *)limit currency:(NSString *)currency counterparty:(NSString *)counterparty showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/trustline"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"userAccountId":userAccountId,
                                @"walletPassword":walletPassword,
                                @"languageType":languageType,
                                @"limit":limit,
                                @"currency":currency,
                                @"counterparty":counterparty
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)cancelTrustlineWithWalletPassword:(NSString *)walletPassword currency:(NSString *)currency counterparty:(NSString *)counterparty showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/trustline"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"userAccountId":SYSTEM_GET_(USERACCOUNTID),
                                @"languageType":languageType,
                                @"limit":@"0",
                                @"currency":currency,
                                @"counterparty":counterparty
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)getHisTrustlinesWithAccount:(NSString *)account marker:(NSString *)marker showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/getHisTrustlines"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType,
                                @"account":account,
                                @"marker":marker
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)getAllCurrencyListsShowProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"payment/getAllCurrencyLists"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)getCurrentOrdersListsWithUserAccountId:(NSString *)userAccountId page:(NSNumber *)page showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"orders/getOrdersLists"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType,
                                @"userAccountId":userAccountId,
                                @"page":page
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)getExchangeListsWithBaseCurrency:(NSString *)baseCurrency baseCounterparty:(NSString *)baseCounterparty counterCurrency:(NSString *)counterCurrency counterCounterparty:(NSString *)counterCounterparty showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"orders/getExchangeLists"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"languageType":languageType,
                                @"baseCurrency":baseCurrency,
                                @"baseCounterparty":baseCounterparty,
                                @"counterCurrency":counterCurrency,
                                @"counterCounterparty":counterCounterparty
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"] || [statusStr isEqualToString:@"E00004"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)submitOrderWithWalletPassword:(NSString *)walletPassword paysCurrency:(NSString *)paysCurrency paysCounterparty:(NSString *)paysCounterparty paysValue:(NSString *)paysValue getsCurrency:(NSString *)getsCurrency getCounterparty:(NSString *)getsCounterparty getsValue:(NSString *)getsValue type:(NSString *)type showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"orders/submitOrder"];
    NSString *encryptStr = [SYSTEM_GET_(APPTOKEN) aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType,
                                @"userAccountId":SYSTEM_GET_(USERACCOUNTID),
                                @"validStr":encryptStr,
                                @"walletPassword":walletPassword,
                                @"paysCurrency":paysCurrency,
                                @"paysCounterparty":paysCounterparty,
                                @"paysValue":paysValue,
                                @"getsCurrency":getsCurrency,
                                @"getsCounterparty":getsCounterparty,
                                @"getsValue":getsValue,
                                @"type":type
                                
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"] || [statusStr isEqualToString:@"E00004"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)cancelOrderWithUserAccountId:(NSString *)userAccountId WalletPassword:(NSString *)walletPassword sequence:(NSString *)sequence showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"orders/cancelOrder"];
    NSString *encryptStr = [SYSTEM_GET_(APPTOKEN) aci_encryptWithAES];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType,
                                @"userAccountId":userAccountId,
                                @"validStr":encryptStr,
                                @"walletPassword":walletPassword,
                                @"sequence":sequence
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"] || [statusStr isEqualToString:@"E00004"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)getHisExchangeListsWithUserAccountId:(NSString *)userAccountId page:(NSNumber *)page showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    HTTPRequestManager *manager = [HTTPRequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"orders/getHisExchangeLists"];
    NSString *languageType = [GlobalMethod getCurrentLanguage];
    NSDictionary *parameter = @{@"userId":SYSTEM_GET_(USER_ID),
                                @"apptoken":SYSTEM_GET_(APPTOKEN),
                                @"languageType":languageType,
                                @"userAccountId":userAccountId,
                                @"page":page
                                };
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"S00001"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else if ([statusStr isEqualToString:@"E00002"] || [statusStr isEqualToString:@"E00004"]){
            if(reLogin){
                reLogin();
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}



+ (void)getAppDataSuccess:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * urlStr = [BASE_URL_NORMAL stringByAppendingString:@"/sell/password/check.jhtml"];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}




- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        return nil;
    }
    return dic;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#pragma mark - getter

//- (AFHTTPSessionManager *)httpSessionManager {
//    if (!_httpSessionManager) {
//        _httpSessionManager = [AFHTTPSessionManager manager];
////        _httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        _httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
////        _httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//        _httpSessionManager.requestSerializer.timeoutInterval = 60000;
//        _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//        [_httpSessionManager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
//        [_httpSessionManager.requestSerializer setValue:@"application/json;charset=utf-8"forHTTPHeaderField:@"Content-Type"];
//
//    }
//    return _httpSessionManager;
//}

- (AFHTTPSessionManager *)httpSessionManager {
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        _httpSessionManager.requestSerializer.timeoutInterval = 20000;
        _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", @"text/javascript", @"application/javascript", nil];
    }
    return _httpSessionManager;
}

@end
