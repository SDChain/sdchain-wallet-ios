//
//  PopSecretViewManager.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/27.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopSecretViewManager : NSObject

@property(nonatomic,copy)void (^WalletSecretUnsetBlock)(void);

@property(nonatomic,copy)void (^WalletSecretCurrectBlock)(NSString *account,NSString *secret, NSString *userAccountId);

@property(nonatomic,copy)void (^WalletSecretErrorBlock)(NSString *);

@property(nonatomic,copy)void (^WalletSecretinputBlock)(NSString *);

+(PopSecretViewManager *)shareInstance;
-(PopSecretViewManager *)shareInstance;

- (void)presentSecretScene;
- (void)presentInputSecretScene;
- (void)dismissSecretScene;

@end

@protocol PopSecretViewManagerDelegate <NSObject>

-(void)secretManager:(PopSecretViewManager *)manager paymentSuccessWithResponse:(id)response;

-(void)secretManager:(PopSecretViewManager *)manager content:(NSString *)content;

-(void)secretManager:(PopSecretViewManager *)manager loginFalure:(NSError *)falure;

@end
