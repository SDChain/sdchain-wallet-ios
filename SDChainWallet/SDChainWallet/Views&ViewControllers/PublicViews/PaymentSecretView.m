//
//  PaymentSecretView.m
//  HuiTongTingChe
//
//  Created by 钱伟成 on 2017/11/3.
//  Copyright © 2017年 HuiTong. All rights reserved.
//

#import "PaymentSecretView.h"

static NSInteger const kPasswordCount = 6;
static CGFloat const kDotWidth        = 10;

@interface PaymentSecretView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic, strong) NSMutableArray <UILabel *> *pwdIndicators;

@property (nonatomic,strong) UILabel * briefLabel;

@property (nonatomic,strong)UIButton *confirmButton;

@property (nonatomic,strong)UIButton *cancleButton;

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic,strong) UIView *contentView;

@end

@implementation PaymentSecretView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self){
        self = [super initWithFrame:frame];
        [self addSubview:self.backGroundView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.inputView];
        [self.contentView addSubview:self.briefLabel];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.confirmButton];
        [self.inputView addSubview:self.pwdTextField];
        CGFloat width = self.inputView.bounds.size.width/kPasswordCount;
        for (int i = 0; i < kPasswordCount; i ++) {
            UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-kDotWidth)/2.f + i*width, (self.inputView.bounds.size.height-kDotWidth)/2.f, kDotWidth, kDotWidth)];
            dot.backgroundColor = [UIColor blackColor];
            dot.layer.cornerRadius = kDotWidth/2;
            dot.clipsToBounds = YES;
            dot.hidden = YES;
            [self.inputView addSubview:dot];
            [self.pwdIndicators addObject:dot];
            if (i == kPasswordCount - 1) {
                continue;
            }
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, self.inputView.bounds.size.height)];
            line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
            [self.inputView addSubview:line];
        }
        [self.pwdTextField becomeFirstResponder];
    }
    return self;
}

-(void)showPaymentSecretInputView{
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication  sharedApplication].keyWindow addSubview:self];
        self.backGroundView.alpha = 0.5;
    }];
    
}

-(void)hidePaymentSecretInputView{
   [self  removeFromSuperview];

}

#pragma mark - request

-(void)requestValidate{
//    [HTTPRequestManager validatePaymentSecretWithPhoneNum:SYSTEM_GET_(LOGINNAME) passWord:self.pwdTextField.text showProgress:NO success:^(NSURLSessionDataTask *task, id responseObject) {
//        if(self.PaymemtSecretCurrectBlock){
//            self.PaymemtSecretCurrectBlock();
//        }
//    } error:^(NSString *content) {
//        if(self.PaymemtSecretErrorBlock){
//            self.PaymemtSecretErrorBlock();
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if(self.PaymemtSecretErrorBlock){
//            self.PaymemtSecretErrorBlock();
//        }
//    }];

}

#pragma mark - delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= kPasswordCount && string.length) {
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - action

- (void)textDidChange:(UITextField *)textField {
    [self setDotWithCount:textField.text.length];
    if (textField.text.length == 6) {
        self.confirmButton.enabled = YES;
        self.confirmButton.backgroundColor = NAVIBAR_COLOR;
    }
    else{
        self.confirmButton.enabled = NO;
        self.confirmButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in self.pwdIndicators) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[self.pwdIndicators objectAtIndex:i]).hidden = NO;
    }
}

-(UIView *)backGroundView{
    if(!_backGroundView){
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backGroundView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePaymentSecretInputView)];
        [_backGroundView addGestureRecognizer:gesture];
        _backGroundView.alpha = 0;
    }
    return _backGroundView;
}

-(UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(kWidth(25), kHeight(160), WIDTH-kWidth(50), kHeight(210))];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 2;
    }
    return _contentView;
}

- (UIView *)inputView {
    if (_inputView == nil) {
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(kWidth(25), kHeight(80), WIDTH-kWidth(100), (WIDTH-kWidth(100))/6)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.layer.borderWidth = 1.f;
        _inputView.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.].CGColor;
    }
    return _inputView;
}

- (UILabel *)line {
    if (_line == nil) {
        _line = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(25),kHeight(59), WIDTH - kWidth(100) , kHeight(1))];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

- (UITextField *)pwdTextField {
    if (_pwdTextField == nil) {
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pwdTextField.hidden = YES;
        _pwdTextField.delegate = self;
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_pwdTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pwdTextField;
}

-(UILabel *)briefLabel{
    if(!_briefLabel){
        _briefLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-kWidth(120), kHeight(25), kWidth(200), kHeight(25))];
        _briefLabel.textColor = [UIColor blackColor];
        _briefLabel.font = [UIFont systemFontOfSize:19];
        _briefLabel.textAlignment = NSTextAlignmentCenter;
        NSString *keyong = NSLocalizedStringFromTable(@"请输入密码", @"guojihua", nil);
        _briefLabel.text = keyong;
        
    }
    return _briefLabel;
}

- (NSMutableArray *)pwdIndicators {
    if (_pwdIndicators == nil) {
        _pwdIndicators = [[NSMutableArray alloc]init];
    }
    return _pwdIndicators;
}

-(UIButton *)confirmButton{
    if(!_confirmButton){
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth(25), kHeight(85) + (WIDTH - kWidth(20))/6, (WIDTH - kWidth(100)), kHeight(40))];
        _confirmButton.backgroundColor = [UIColor lightGrayColor];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 5;
        NSString *queren = NSLocalizedStringFromTable(@"确认", @"guojihua", nil);
        [_confirmButton setTitle:queren forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.enabled = NO;
    }
    return _confirmButton;
}

-(UIButton *)cancleButton{
    if(!_cancleButton){
        _cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth(20), kHeight(100)+ (WIDTH - kWidth(20))/6, (WIDTH - kWidth(100))/2, kHeight(40))];
        _cancleButton.backgroundColor = [UIColor lightGrayColor];
        _cancleButton.layer.masksToBounds = YES;
        _cancleButton.layer.cornerRadius = 20;
        NSString *quxiao = NSLocalizedStringFromTable(@"取消", @"guojihua", nil);
        [_cancleButton setTitle:quxiao forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancleButton addTarget:self action:@selector(hidePaymentSecretInputView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

-(void)confirmAction{
    if(self.PaymemtSecretCurrectBlock){
        self.PaymemtSecretCurrectBlock(self.pwdTextField.text);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
