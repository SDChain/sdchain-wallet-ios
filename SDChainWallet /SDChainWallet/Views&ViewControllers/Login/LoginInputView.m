//
//  LoginInputView.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/20.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "LoginInputView.h"
#import "Masonry.h"

@implementation LoginInputView


-(instancetype)initWithtype:(RegistType)type{
    if(self){
        


        [self setupViewWithType:type];
    }
    return self;
    
}



-(void)setupViewWithType:(RegistType)type{
    [self addSubview:self.acountTitleLabel];
    [self addSubview:self.acountTextField];
    [self addSubview:self.lineView1];
    [self addSubview:self.codeTitleLabel];
    [self addSubview:self.codeTextField];
    [self addSubview:self.lineView2];
    [self addSubview:self.sendCodeButton];
    [self addSubview:self.nextStepButton];
    [self addSubview:self.changeRegistButton];
    
    if(type == RegistTypeMobile){
        
        
    }
    else{
        
        
    }
    
    [self setupLayout];
    
}


-(void)setupLayout{
    [self.countryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.countrydetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countryTitleLabel.mas_top);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(30);
    }];
    
    [self.acountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.equalTo(self.countryTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.acountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.acountTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.acountTextField.mas_bottom).offset(4.5);
    }];
    
    [self.codeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.lineView1.mas_bottom).offset(30);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-130);
        make.top.equalTo(self.codeTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.codeTextField.mas_bottom).offset(4.5);
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.bottom.equalTo(self.lineView2.mas_top).offset(-10);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.lineView2.mas_bottom).offset(35);
    }];
    
    [self.changeRegistButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
}


    


#pragma mark - getter

-(UILabel *)countryTitleLabel{
    if(!_countryTitleLabel){
        _countryTitleLabel = [[UILabel alloc] init];
        _countryTitleLabel.textColor = NAVIBAR_COLOR;
        _countryTitleLabel.font = [UIFont systemFontOfSize:17];
        NSString *title = NSLocalizedString(@"国家/地区", nil);
        _countryTitleLabel.text = title;
    }
    return _countryTitleLabel;
}

-(UILabel *)countrydetailLabel{
    if(!_countrydetailLabel){
        _countrydetailLabel = [[UILabel alloc] init];
        _countrydetailLabel.textColor = [UIColor blackColor];
        _countrydetailLabel.font = [UIFont systemFontOfSize:17];
        NSString *title = NSLocalizedString(@"+86中国", nil);
        _countrydetailLabel.text = title;
    }
    return _countrydetailLabel;
}

-(UILabel *)acountTitleLabel{
    if(!_acountTitleLabel){
        _acountTitleLabel = [[UILabel alloc] init];
        _acountTitleLabel.textColor = NAVIBAR_COLOR;
        _acountTitleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _acountTitleLabel;
}

-(UITextField *)acountTextField{
    if(!_acountTextField){
        _acountTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedString(@"输入邮箱/手机号", nil);
        _acountTextField.placeholder = title;
    }
    return _acountTextField;
}

-(UIView *)lineView1{
    if(!_lineView1){
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = NAVIBAR_COLOR;
    }
    return _lineView1;
}

-(UILabel *)codeTitleLabel{
    if(!_codeTitleLabel){
        _codeTitleLabel = [[UILabel alloc] init];
        NSString *title = NSLocalizedString(@"验证码", nil);
        _codeTitleLabel.text = title;
        _codeTitleLabel.font = [UIFont systemFontOfSize:17];
        _codeTitleLabel.textColor = NAVIBAR_COLOR;
    }
    return _codeTitleLabel;
    
    
}

-(UITextField *)codeTextField{
    if(!_codeTextField){
        _codeTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedString(@"输入验证码", nil);
        _codeTextField.placeholder = title;
    }
    return _codeTextField;
}

-(UIButton *)sendCodeButton{
    if(!_sendCodeButton){
        _sendCodeButton = [[UIButton alloc] init];
        NSString *title = NSLocalizedString(@"获取验证码", nil);
        [_sendCodeButton setTitle:title forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sendCodeButton;
}

-(UIView *)lineView2{
    if(!_lineView2){
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = NAVIBAR_COLOR;
    }
    return _lineView2;
}

-(UIButton *)nextStepButton{
    if(!_nextStepButton){
        _nextStepButton = [[UIButton alloc] init];
        NSString *title = NSLocalizedString(@"下一步", nil);
        [_nextStepButton setTitle:title forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _nextStepButton.backgroundColor = NAVIBAR_COLOR;
        _nextStepButton.layer.masksToBounds = YES;
        _nextStepButton.layer.cornerRadius = 15.0;
    }
    return _nextStepButton;
    
}

-(UIButton *)changeRegistButton{
    if(!_changeRegistButton){
        _changeRegistButton = [[UIButton alloc] init];
        [_changeRegistButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _changeRegistButton.titleLabel.font = [UIFont systemFontOfSize:15];
        NSString *title = NSLocalizedString(@"邮箱注册", nil);
        [_changeRegistButton setTitle:title forState:UIControlStateNormal];
        [_changeRegistButton addTarget:self action:@selector(changeTypeActionWithType) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeRegistButton;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
