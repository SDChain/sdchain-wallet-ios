//
//  HTTPRequestManager.h
//  BaseProject6.15
//
//  Created by 钱伟成 on 2017/6/22.
//  Copyright © 2017年 Zeepson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EzSingleton.h"

@protocol HTTPRequestManagerDelegate;

@interface HTTPRequestManager : NSObject

@property (nonatomic, weak) id<HTTPRequestManagerDelegate> delegate;

AS_SINGLETON(HTTPRequestManager)

- (void)showProgressHUD;
- (void)hideProgressHUD;


+ (void)getAppDataSuccess:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;


#pragma mark - login&&regist
//login
+(void)appLoginWithUserName:(NSString *)userName passWord:(NSString *)passWord showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Captcha
+(void)getRandomCodePicWithMachineId:(NSString *)machineId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Sign up for phone verification code
+(void)loginGetVerifyingCodeWithMobile:(NSString *)mobile machineId:(NSString *)machineId imageCode:(NSString *)imageCode mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Sign up for a password verification code
+(void)loginGetVerifyingCodeWithEmail:(NSString *)email machineId:(NSString *)machineId imageCode:(NSString *)imageCode mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get phone verification code
+(void)GetVerifyingCodeWithMobile:(NSString *)mobile mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get the mailbox verification code
+(void)GetVerifyingCodeWithEmail:(NSString *)email mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Register by mobile number
+(void)registWithMobile:(NSString *)mobile codeId:(NSString *)codeId code:(NSString *)code showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Register by email
+(void)registWithEmail:(NSString *)email codeId:(NSString *)codeId code:(NSString *)code showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//registered
+(void)registWithUserName:(NSString *)userName passWord:(NSString *)passWord smsId:(NSString *)smsId walletPassword:(NSString *)walletPassword phone:(NSString *)phone email:(NSString *)email showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//forget password
+(void)forgetSecretWithUserName:(NSString *)userName password:(NSString *)password showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Modify the login password
+(void)updateLoginPasswordWithOldPassword:(NSString *)oldPassword password:(NSString *)password smsId:(NSString *)smsId code:(NSString *)code mark:(NSString *)mark showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Replace the default wallet
+(void)paymentchangeDefaultWalletWithId:(NSString *)userId account:(NSString *)account showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Home to get a list of wallets
+(void)paymentwalletListWithUserId:(NSString *)userId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;


//Import wallet
+(void)leadinWalletWithWalletPassword:(NSString *)walletPassword walletPrivitySecret:(NSString *)walletPrivitySecret walletAccount:(NSString *)walletAccount showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Create a wallet
+(void)createWalletWithPassword:(NSString *)password showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get the wallet key
+(void)getWalletSecretWithUserAccountId:(NSString *)userAccountId walletPassword:(NSString *)walletPassword showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Activate wallet
+(void)walletActiveActionWithUserAccountId:(NSString *)userAccountId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Modify wallet name
+(void)fixWalletNameWithUserId:(NSString *)userId accountName:(NSString *)accountName userAccountId:(NSString *)userAccountId apptoken:(NSString *)apptoken showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Modify wallet password
+(void)fixWalletSecretWithId:(NSString *)UserId userAccountId:(NSString *)userAccountId apptoken:(NSString *)apptoken walletPassword:(NSString *)walletPassword newWalletPassword:(NSString *)newWalletPassword showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Forgot your wallet password
+(void)forgetWalletPasswordWithNewWallletPassword:(NSString *)newWalletPassword secret:(NSString *)secret showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Transfer
+(void)paymentissueCurrencyWithDestinationAccount:(NSString *)destinationAccount value:(NSString *)value currency:(NSString *)currency memo:(NSString *)memo walletPassword:(NSString *)walletPassword userId:(NSString *)userId apptoken:(NSString *)apptoken userAccountId:(NSString *)userAccountId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get a list of deals
+(void)getPaymentsListWithUseraccountId:(NSString *)userAccountId page:(NSString *)page currency:(NSString *)currency minDate:(NSString *)minDate maxDate:(NSString *)maxDate showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get transaction details
+(void)getPaymentsListWithUseraccountId:(NSString *)userAccountId hash:(NSString *)hash showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get a list of messages
+(void)getMessagesListWithPage:(NSNumber *)page showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Acquiring assets
+(void)getBalanceWithAccount:(NSString *)account userId:(NSString *)userId appToken:(NSString *)appToken showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get a list of friends
+(void)getFriendsListWithUserId:(NSString *)userId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get friend personal information
+(void)getFriendInfoWithAdverseUserId:(NSString *)adverseUserId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Search for users (add friends)
+(void)searchUserWithUserName:(NSString *)userName showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//add friend
+(void)addFriendWithAdverseUserId:(NSString *)adverseUserId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//delete friend
+(void)deleteFriendWithAdverseUserId:(NSString *)adverseUserId showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Bind phone number
+(void)bindPhoneWithSmsId:(NSString *)smsId userId:(NSString *)userId code:(NSString *)code password:(NSString *)password apptoken:(NSString *)apptoken phone:(NSString *)phone showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Bind mailbox
+(void)bindEmailWithSmsId:(NSString *)smsId code:(NSString *)code password:(NSString *)password email:(NSString *)email showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Verified
+(void)realNameCertificationWithIdCode:(NSString *)idCode realName:(NSString *)realName showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//change username
+(void)updateNickNameWithNickName:(NSString *)nickName showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get a list of credit information
+(void)getTrustlinesWithAccount:(NSString *)account showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Credit
+(void)trustlineWithUserAccountId:(NSString *)userAccountId walletPassword:(NSString *)walletPassword limit:(NSString *)limit currency:(NSString *)currency counterparty:(NSString *)counterparty showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;


//Cancellation of credit
+(void)cancelTrustlineWithWalletPassword:(NSString *)walletPassword currency:(NSString *)currency counterparty:(NSString *)counterparty showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get credit history
+(void)getHisTrustlinesWithAccount:(NSString *)account marker:(NSString *)marker showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get a list of all currencies
+(void)getAllCurrencyListsShowProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get the current pending order list
+(void)getCurrentOrdersListsWithUserAccountId:(NSString *)userAccountId page:(NSNumber *)page showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get a list of currency trading pending orders
+(void)getExchangeListsWithBaseCurrency:(NSString *)baseCurrency baseCounterparty:(NSString *)baseCounterparty counterCurrency:(NSString *)counterCurrency counterCounterparty:(NSString *)counterCounterparty showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Pending order
+(void)submitOrderWithWalletPassword:(NSString *)walletPassword paysCurrency:(NSString *)paysCurrency paysCounterparty:(NSString *)paysCounterparty paysValue:(NSString *)paysValue getsCurrency:(NSString *)getsCurrency getCounterparty:(NSString *)getsCounterparty getsValue:(NSString *)getsValue type:(NSString *)type showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Withdrawal
+(void)cancelOrderWithUserAccountId:(NSString *)userAccountId WalletPassword:(NSString *)walletPassword sequence:(NSString *)sequence showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Get a list of historical pending orders
+(void)getHisExchangeListsWithUserAccountId:(NSString *)userAccountId page:(NSNumber *)page showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success reLogin:(void(^)(void))reLogin warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;



#pragma mark - member
//Member image upload
+(void)upLoadImageWithImageData:(NSData *)data showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//Add edit user information
+(void)personalInfoAdditionOrEditionWithNickName:(NSString *)nickName birthday:(NSString *)birthday showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//User information query
+(void)personalInfoCheckWithPhoneNum:(NSString *)phoneNum showProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

@end

