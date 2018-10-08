//
//  PaymentSecretView.h
//  HuiTongTingChe
//
//  Created by 钱伟成 on 2017/11/3.
//  Copyright © 2017年 HuiTong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PaymentSecretView : UIView

@property(nonatomic,copy)void (^PaymemtSecretCurrectBlock)(NSString *);

@property(nonatomic,copy)void (^PaymemtSecretErrorBlock)(void);

-(instancetype)initWithFrame:(CGRect)frame;

-(void)showPaymentSecretInputView;

-(void)hidePaymentSecretInputView;



@end
