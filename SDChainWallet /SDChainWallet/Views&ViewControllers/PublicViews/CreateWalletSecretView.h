//
//  CreateWalletSecretView.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/27.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateWalletSecretView : UIView

@property(nonatomic,strong) NSString *type;

@property(nonatomic,copy)void (^CreateWalletSecretCurrectBlock)(NSString *account,NSString *secret, NSString *userAccountId);

@property(nonatomic,copy)void (^CreateWalletSecretErrorBlock)(NSString *);

@property(nonatomic,copy)void (^CreateWalletSecretInputBlock)(NSString *);

-(instancetype)initWithFrame:(CGRect)frame;

-(void)showPaymentSecretInputView;

-(void)hidePaymentSecretInputView;

@end
