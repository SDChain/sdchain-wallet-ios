//
//  HTTPRequestManager.h
//  BaseProject6.15
//
//  Created by 钱伟成 on 2017/6/22.
//  Copyright © 2017年 Zeepson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EzSingleton.h"

typedef NS_ENUM(NSInteger, ErrorCode) {
    ErrorCodeErrToken = -3,                 // 错误的Token
    ErrorCodeThirdpartyLoginUnbinded = -2,  // 第三方登录未绑定账号
    ErrorCodeInvalid = -1,                  // 会话失效
    ErrorCodeSuccess = 0,                   // 成功
    ErrorCodeErrMobile = 1,                 // 手机号不正确
    ErrorCodeErrUsername = 2,               // 用户名不存在
    ErrorCodeMobile = 3,                    // 手机号未注册
    ErrorCodeErrPassword = 4,               // 密码错误
    ErrorCodeErrImageCaptcha = 5,           // 图片验证码错误
    ErrorCodeErrMobileCaptcha = 6,          // 短信校验码错误
    ErrorCodeCaptchaExpire = 7,             // 短信校验码过期
    ErrorCodeErrPasswordIn = 8,             // 密码输入格式错误
    ErrorCodeUsernameExist = 9,             // 用户名已经被注册
    ErrorCodeMobileExist = 10,              // 手机号已经被注册
};

@protocol HTTPRequestManagerDelegate;

@interface HTTPRequestManager : NSObject

@property (nonatomic, weak) id<HTTPRequestManagerDelegate> delegate;

AS_SINGLETON(HTTPRequestManager)

- (void)showProgressHUD;
- (void)hideProgressHUD;


+ (void)getAppDataSuccess:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;


#pragma mark - 登录&&注册
//登录
+(void)appLoginWithUserName:(NSString *)userName passWord:(NSString *)passWord showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//请求版本
+(void)checkVersionShowProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//图形验证码
+(void)getRandomCodePicWithMachineId:(NSString *)machineId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//注册获取手机验证码
+(void)loginGetVerifyingCodeWithMobile:(NSString *)mobile machineId:(NSString *)machineId imageCode:(NSString *)imageCode mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//注册获取邮箱验证码
+(void)loginGetVerifyingCodeWithEmail:(NSString *)email machineId:(NSString *)machineId imageCode:(NSString *)imageCode mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取手机验证码
+(void)GetVerifyingCodeWithMobile:(NSString *)mobile mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//修改登录密码获取手机验证码
+(void)FixLoginGetVerifyingCodeWithMobile:(NSString *)mobile mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取邮箱验证码
+(void)GetVerifyingCodeWithEmail:(NSString *)email mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//通过手机号码注册
+(void)registWithMobile:(NSString *)mobile codeId:(NSString *)codeId code:(NSString *)code showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//通过邮箱注册
+(void)registWithEmail:(NSString *)email codeId:(NSString *)codeId code:(NSString *)code showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//注册
+(void)registWithUserName:(NSString *)userName passWord:(NSString *)passWord smsId:(NSString *)smsId walletPassword:(NSString *)walletPassword phone:(NSString *)phone email:(NSString *)email showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//忘记密码
+(void)forgetSecretWithUserName:(NSString *)userName password:(NSString *)password phone:(NSString *)phone showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//修改登录密码
+(void)updateLoginPasswordWithOldPassword:(NSString *)oldPassword password:(NSString *)password smsId:(NSString *)smsId code:(NSString *)code mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//更换默认钱包
+(void)paymentchangeDefaultWalletWithId:(NSString *)userId account:(NSString *)account showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//首页获取钱包列表
+(void)paymentwalletListWithUserId:(NSString *)userId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;


//导入钱包
+(void)leadinWalletWithWalletPassword:(NSString *)walletPassword walletPrivitySecret:(NSString *)walletPrivitySecret walletAccount:(NSString *)walletAccount showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//创建钱包
+(void)createWalletWithPassword:(NSString *)password showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取钱包秘钥
+(void)getWalletSecretWithUserAccountId:(NSString *)userAccountId walletPassword:(NSString *)walletPassword showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//激活钱包
+(void)walletActiveActionWithUserAccountId:(NSString *)userAccountId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//修改钱包名称
+(void)fixWalletNameWithUserId:(NSString *)userId accountName:(NSString *)accountName userAccountId:(NSString *)userAccountId apptoken:(NSString *)apptoken showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//修改钱包密码
+(void)fixWalletSecretWithId:(NSString *)UserId userAccountId:(NSString *)userAccountId apptoken:(NSString *)apptoken walletPassword:(NSString *)walletPassword newWalletPassword:(NSString *)newWalletPassword showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//忘记钱包密码
+(void)forgetWalletPasswordWithNewWallletPassword:(NSString *)newWalletPassword secret:(NSString *)secret showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//转账
+(void)paymentissueCurrencyWithDestinationAccount:(NSString *)destinationAccount value:(NSString *)value issuer:(NSString *)issuer currency:(NSString *)currency memo:(NSString *)memo walletPassword:(NSString *)walletPassword userId:(NSString *)userId apptoken:(NSString *)apptoken userAccountId:(NSString *)userAccountId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取交易列表
+(void)getPaymentsListWithUseraccountId:(NSString *)userAccountId page:(NSString *)page currency:(NSString *)currency minDate:(NSString *)minDate maxDate:(NSString *)maxDate showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取交易详情
+(void)getPaymentsListWithUseraccountId:(NSString *)userAccountId hash:(NSString *)hash showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取消息列表
+(void)getMessagesListWithPage:(NSNumber *)page showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取资产
+(void)getBalanceWithAccount:(NSString *)account userId:(NSString *)userId appToken:(NSString *)appToken showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取好友列表
+(void)getFriendsListWithUserId:(NSString *)userId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取好友个人信息
+(void)getFriendInfoWithAdverseUserId:(NSString *)adverseUserId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//搜索用户（添加好友）
+(void)searchUserWithUserName:(NSString *)userName showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//添加好友
+(void)addFriendWithAdverseUserId:(NSString *)adverseUserId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//删除好友
+(void)deleteFriendWithAdverseUserId:(NSString *)adverseUserId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//绑定手机号
+(void)bindPhoneWithSmsId:(NSString *)smsId userId:(NSString *)userId code:(NSString *)code password:(NSString *)password apptoken:(NSString *)apptoken phone:(NSString *)phone area:(NSString *)area showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//绑定邮箱
+(void)bindEmailWithSmsId:(NSString *)smsId code:(NSString *)code password:(NSString *)password email:(NSString *)email showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//实名认证
+(void)realNameCertificationWithIdCode:(NSString *)idCode realName:(NSString *)realName showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//修改昵称
+(void)updateNickNameWithNickName:(NSString *)nickName showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取授信信息列表
+(void)getTrustlinesWithAccount:(NSString *)account showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//授信
+(void)trustlineWithUserAccountId:(NSString *)userAccountId walletPassword:(NSString *)walletPassword limit:(NSString *)limit currency:(NSString *)currency counterparty:(NSString *)counterparty showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;


//取消授信
+(void)cancelTrustlineWithWalletPassword:(NSString *)walletPassword currency:(NSString *)currency counterparty:(NSString *)counterparty showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取授信历史
+(void)getHisTrustlinesWithAccount:(NSString *)account marker:(NSString *)marker showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//显示手动授信
+(void)funcControllerShowProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取全部币种列表
+(void)getAllCurrencyListsShowProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取当前挂单列表
+(void)getCurrentOrdersListsWithUserAccountId:(NSString *)userAccountId page:(NSNumber *)page showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取币币交易挂单列表
+(void)getExchangeListsWithBaseCurrency:(NSString *)baseCurrency baseCounterparty:(NSString *)baseCounterparty counterCurrency:(NSString *)counterCurrency counterCounterparty:(NSString *)counterCounterparty showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//挂单
+(void)submitOrderWithWalletPassword:(NSString *)walletPassword paysCurrency:(NSString *)paysCurrency paysCounterparty:(NSString *)paysCounterparty paysValue:(NSString *)paysValue getsCurrency:(NSString *)getsCurrency getCounterparty:(NSString *)getsCounterparty getsValue:(NSString *)getsValue type:(NSString *)type showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//撤单
+(void)cancelOrderWithUserAccountId:(NSString *)userAccountId WalletPassword:(NSString *)walletPassword sequence:(NSString *)sequence showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取历史挂单列表
+(void)getHisExchangeListsWithUserAccountId:(NSString *)userAccountId page:(NSNumber *)page showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;



#pragma mark - 会员
//会员图片上传
+(void)upLoadImageWithImageData:(NSData *)data showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//新增修改用户信息
+(void)personalInfoAdditionOrEditionWithNickName:(NSString *)nickName birthday:(NSString *)birthday showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//用户信息查询
+(void)personalInfoCheckWithPhoneNum:(NSString *)phoneNum showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

@end


@protocol HTTPRequestManagerDelegate <NSObject>


/** 代理方法，当网络请求出现警告时，该方法被调用 */
- (void)httpRequestManagerDidRequestWarnWithContent:(NSString *)content;
/** 代理方法，当网络请求出现错误时，该方法被调用 */
- (void)httpRequestManagerDidRequestErrorWithContent:(NSString *)content;
/** 代理方法，当网络请求取消时，该方法被调用 */
- (void)httpRequestManagerDidRequestCancel;
/** 代理方法，当网络请求失败时，该方法被调用 */
- (void)httpRequestManagerDidRequestFailureWithError:(NSError *)error;
/** 代理方法，当网络请求需要登录时，该方法被调用 */
- (void)httpRequestManagerDidLogout;

@end
