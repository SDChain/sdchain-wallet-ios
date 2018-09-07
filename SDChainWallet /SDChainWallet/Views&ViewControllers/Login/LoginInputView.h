//
//  LoginInputView.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/20.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginInputView : UIView

@property(nonatomic,strong)UILabel *countryTitleLabel;
@property(nonatomic,strong)UILabel *countrydetailLabel;
@property(nonatomic,strong)UILabel *acountTitleLabel;
@property(nonatomic,strong)UITextField *acountTextField;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UILabel *codeTitleLabel;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)UIButton *sendCodeButton;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIButton *nextStepButton;
@property(nonatomic,strong)UIButton *changeRegistButton;

-(instancetype)initWithtype:(RegistType)type;


@end
