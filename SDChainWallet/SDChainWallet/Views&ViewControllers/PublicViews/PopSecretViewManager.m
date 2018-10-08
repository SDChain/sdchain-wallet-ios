//
//  PopSecretViewManager.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/27.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "PopSecretViewManager.h"
#import "CreateWalletSecretView.h"

@implementation PopSecretViewManager

+ (PopSecretViewManager *)shareInstance {
    static dispatch_once_t once;
    static PopSecretViewManager * __singleton__;
    dispatch_once(&once, ^{
        __singleton__ = [[self alloc] init];
    });
    return __singleton__;
}

-(void)presentSecretScene{
    CreateWalletSecretView *secretView = [[CreateWalletSecretView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    __weak PopSecretViewManager *weakSelf = self;
    
    __weak CreateWalletSecretView *weakView = secretView;
    secretView.CreateWalletSecretCurrectBlock = ^(NSString *account, NSString *secret, NSString *userAccountId) {
        [weakView hidePaymentSecretInputView];
        if(weakSelf.WalletSecretCurrectBlock){
            weakSelf.WalletSecretCurrectBlock(account,secret,userAccountId);
        }
    };
    secretView.CreateWalletSecretErrorBlock = ^(NSString *content) {
        [weakView hidePaymentSecretInputView];
        if(weakSelf.WalletSecretErrorBlock){
            weakSelf.WalletSecretErrorBlock(content);
        }
    };
    
    [secretView showPaymentSecretInputView];
    
}

- (void)presentInputSecretScene{
    CreateWalletSecretView *secretView = [[CreateWalletSecretView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    __weak PopSecretViewManager *weakSelf = self;
    __weak CreateWalletSecretView *weakView = secretView;
    secretView.CreateWalletSecretInputBlock = ^(NSString *secret) {
        [weakView hidePaymentSecretInputView];
        if(weakSelf.WalletSecretinputBlock){
            weakSelf.WalletSecretinputBlock(secret);
        }
    };
    [secretView showPaymentSecretInputView];
}


- (PopSecretViewManager *)shareInstance {
    return [[self class] shareInstance];
}

- (void)dismissSecretScene {
    [[UIApplication sharedApplication].delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
