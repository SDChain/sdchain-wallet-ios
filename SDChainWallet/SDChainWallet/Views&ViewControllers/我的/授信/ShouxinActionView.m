//
//  ShouxinActionView.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/1.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ShouxinActionView.h"
#import "Masonry.h"


@interface ShouxinActionView ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *shouxinLabel;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIView *lineView3;
@property(nonatomic,strong)UIView *lineView4;
@property(nonatomic,strong)UIButton *shouxinButton;
@property(nonatomic,strong)UIButton *cancleButton;
@property(nonatomic,strong)UITextField *wangguandizhi;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *shuliangTextField;



@end

@implementation ShouxinActionView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self){
        self = [super initWithFrame:frame];
    }
    [self setupView];
    
    return self;
}

-(void)showShouxinActionView{
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication  sharedApplication].keyWindow addSubview:self];
        self.backView.alpha = 0.5;
    }];

}

-(void)setupView{
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.shouxinLabel];
    [self.contentView addSubview:self.cancleButton];
    [self.contentView addSubview:self.lineView1];
    [self.contentView addSubview:self.lineView2];
    [self.contentView addSubview:self.lineView3];
    [self.contentView addSubview:self.lineView4];
    [self.contentView addSubview:self.wangguandizhi];
    [self.contentView addSubview:self.nameTextField];
    [self.contentView addSubview:self.shuliangTextField];
    [self.contentView addSubview:self.shouxinButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(40);
    }];
    
    [self.shouxinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(kHeight(30));
        make.top.mas_equalTo(kHeight(10));
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kWidth(40));
        make.centerY.equalTo(self.shouxinLabel.mas_centerY);
        make.right.mas_equalTo(kWidth(-5));
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(50));
        make.height.mas_equalTo(0.7);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(kWidth(15));
        make.top.mas_equalTo(kHeight(100));
        make.height.mas_equalTo(0.7);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(kWidth(15));
        make.top.mas_equalTo(kHeight(150));
        make.height.mas_equalTo(0.7);
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(200));
        make.height.mas_equalTo(0.7);
    }];
    
    [self.wangguandizhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(15));
        make.right.mas_equalTo(kWidth(-15));
        make.width.mas_equalTo(WIDTH-kWidth(30));
        make.height.mas_equalTo(kHeight(40));
        make.top.mas_equalTo(kHeight(55));
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(15));
        make.right.mas_equalTo(kWidth(-15));
        make.width.mas_equalTo(WIDTH-kWidth(30));
        make.height.mas_equalTo(kHeight(40));
        make.top.mas_equalTo(kHeight(105));
    }];
    
    [self.shuliangTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(15));
        make.right.mas_equalTo(kWidth(-15));
        make.width.mas_equalTo(WIDTH-kWidth(30));
        make.height.mas_equalTo(kHeight(40));
        make.top.mas_equalTo(kHeight(155));
    }];
    
    [self.shouxinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kHeight(225));
        make.left.mas_equalTo(kWidth(40));
        make.right.mas_equalTo(kWidth(-40));
        make.height.mas_equalTo(kHeight(40));
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.wangguandizhi.text.length == 0 || self.nameTextField.text.length == 0 || self.shuliangTextField.text.length == 0){
        self.shouxinButton.backgroundColor = UNCLICK_COLOR;
        self.shouxinButton.enabled = NO;
    }else{
        self.shouxinButton.backgroundColor = NAVIBAR_COLOR;
        self.shouxinButton.enabled = YES;
    }
}


#pragma mark - action
-(void)cancleButtonAction{
    [self removeFromSuperview];
}

-(void)shouxinAction{
    if(self.shouxinBlock){
        self.shouxinBlock(self.wangguandizhi.text, self.nameTextField.text, self.shuliangTextField.text);
    }
    [self removeFromSuperview];
}

#pragma mark - getter

-(UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0;
        UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popOut)];
        [_backView addGestureRecognizer:gusture];
    }
    return _backView;
}

-(void)popOut{
    [self removeFromSuperview];
}

-(UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

-(UILabel *)shouxinLabel{
    if(!_shouxinLabel){
        _shouxinLabel = [[UILabel alloc] init];
        _shouxinLabel.text = @"手动授信";
        _shouxinLabel.textAlignment = NSTextAlignmentCenter;
        _shouxinLabel.font = [UIFont systemFontOfSize:15];
        _shouxinLabel.textColor = NAVIBAR_COLOR;
    }
    return _shouxinLabel;
}

-(UIView *)lineView1{
    if(!_lineView1){
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = LINE_COLOR;
    }
    return _lineView1;
}

-(UIView *)lineView2{
    if(!_lineView2){
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = LINE_COLOR;
    }
    return _lineView2;
}

-(UIView *)lineView3{
    if(!_lineView3){
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = LINE_COLOR;
    }
    return _lineView3;
}

-(UIView *)lineView4{
    if(!_lineView4){
        _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = LINE_COLOR;
    }
    return _lineView4;
}

-(UITextField *)wangguandizhi{
    if(!_wangguandizhi){
        _wangguandizhi = [[UITextField alloc] init];
        _wangguandizhi.placeholder = @"Token网管地址";
    }
    return _wangguandizhi;
}

-(UITextField *)shuliangTextField{
    if(!_shuliangTextField){
        _shuliangTextField = [[UITextField alloc] init];
        _shuliangTextField.placeholder = @"Token数量";
    }
    return _shuliangTextField;
}

-(UITextField *)nameTextField{
    if(!_nameTextField){
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.placeholder = @"Token名称";
    }
    return _nameTextField;
}

-(UIButton *)cancleButton{
    if(!_cancleButton){
        _cancleButton = [[UIButton alloc] init];
        [_cancleButton setImage:[UIImage imageNamed:@"shouxin_cancle"] forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

-(UIButton *)shouxinButton{
    if(!_shouxinButton){
        _shouxinButton = [[UIButton alloc] init];
        _shouxinButton.backgroundColor = UNCLICK_COLOR;
        [_shouxinButton setTitle:@"授信" forState:UIControlStateNormal];
        [_shouxinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _shouxinButton.enabled = NO;
        _shouxinButton.layer.masksToBounds = YES;
        _shouxinButton.layer.cornerRadius = kHeight(15);
        [_shouxinButton addTarget:self action:@selector(shouxinAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shouxinButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
