//
//  PaymentSecretManager.m
//  HuiTongTingChe
//
//  Created by 钱伟成 on 2017/11/2.
//  Copyright © 2017年 HuiTong. All rights reserved.
//

#import "PaymentSecretManager.h"
#import "BaseNavigationController.h"
#import "PaymentSecretView.h"

@implementation PaymentSecretManager

+ (PaymentSecretManager *)shareInstance {
    static dispatch_once_t once;
    static PaymentSecretManager * __singleton__;
    dispatch_once(&once, ^{
        __singleton__ = [[self alloc] init];
    });
    return __singleton__;
}

- (PaymentSecretManager *)shareInstance {
    return [[self class] shareInstance];
}

-(void)presentSecretScene{
    PaymentSecretView *secretView = [[PaymentSecretView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    __weak PaymentSecretManager *weakSelf = self;
    
    __weak PaymentSecretView *weakView = secretView;
    secretView.PaymemtSecretCurrectBlock = ^(NSString *passWord) {
        [weakView hidePaymentSecretInputView];
        if(weakSelf.PaymemtSecretCurrectBlock){
            weakSelf.PaymemtSecretCurrectBlock(passWord);
        }
    };
    secretView.PaymemtSecretErrorBlock = ^{
        [weakView hidePaymentSecretInputView];
        if(weakSelf.PaymemtSecretErrorBlock){
            weakSelf.PaymemtSecretErrorBlock();
        }
    };
    
    [secretView showPaymentSecretInputView];

}


- (void)dismissSecretScene {
    [[UIApplication sharedApplication].delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
