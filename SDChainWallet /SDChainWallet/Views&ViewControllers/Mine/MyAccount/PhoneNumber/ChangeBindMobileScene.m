//
//  ChangeBindMobileScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/21.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ChangeBindMobileScene.h"
#import "Masonry.h"
#import "NSString+validate.h"
#import "HTTPRequestManager.h"

@interface ChangeBindMobileScene ()

@property(nonatomic,strong)UIView *inputView;

@property(nonatomic,strong)UIView *lineView1;

@property(nonatomic,strong)UIView *lineView2;

@property(nonatomic,strong)UIView *lineView3;

@property(nonatomic,strong)UIView *lineView4;

@property(nonatomic,strong)UIView *lineView5;

@property(nonatomic,strong)UITextField *binedMobileTextField;

@property(nonatomic,strong)UITextField *mobileTextField;

@property(nonatomic,strong)UITextField *identifyingCodeTextField;

@property(nonatomic,strong)UITextField *loginPassWordTextField;

@property(nonatomic,strong)UIButton *sendCodeButton;

@property(nonatomic,strong)UIButton *confirmButton;


@end

@implementation ChangeBindMobileScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"换绑手机", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.confirmButton];
    
    [self.inputView addSubview:self.lineView1];
    [self.inputView addSubview:self.lineView2];
    [self.inputView addSubview:self.lineView3];
    [self.inputView addSubview:self.lineView4];
    [self.inputView addSubview:self.lineView5];
    [self.inputView addSubview:self.mobileTextField];
    [self.inputView addSubview:self.identifyingCodeTextField];
    [self.inputView addSubview:self.loginPassWordTextField];
    [self.inputView addSubview:self.sendCodeButton];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(10));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(kHeight(200));
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kHeight(40));
        make.right.mas_equalTo(kHeight(-40));
        make.top.equalTo(self.inputView.mas_bottom).offset(kHeight(50));
        make.height.mas_equalTo(kHeight(40));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(0.6));
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(0.6));
        make.top.mas_equalTo(kHeight(50));
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(0.6));
        make.top.mas_equalTo(kHeight(100));
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(0.6));
        make.top.mas_equalTo(kHeight(150));
    }];
    
    [self.lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(0.6));
    }];
    
    [self.binedMobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(kWidth(10));
        make.top.mas_equalTo(kHeight(5));
        make.height.mas_equalTo(40);
    }];
    
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(kWidth(10));
        make.top.mas_equalTo(kHeight(55));
        make.height.mas_equalTo(40);
    }];
    
    [self.identifyingCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(10));
        make.right.mas_equalTo(kWidth(110));
        make.top.mas_equalTo(kHeight(105));
        make.height.mas_equalTo(40);
    }];
    
    [self.loginPassWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(kWidth(10));
        make.bottom.mas_equalTo(kHeight(-5));
        make.height.mas_equalTo(40);
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kWidth(-10));
        make.centerY.equalTo(self.identifyingCodeTextField.mas_centerY);
        make.width.mas_equalTo(kWidth(100));
        make.height.mas_equalTo(kHeight(40));
    }];
}

#pragma mark - action
-(void)sendCodeAction{
    NSString *mobileStr = [NSString stringWithFormat:@"%@",self.mobileTextField.text];
    if([NSString valiMobile:mobileStr]){
        [HTTPRequestManager GetVerifyingCodeWithMobile:self.mobileTextField.text  mark:@"0" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [GlobalMethod startTime:59 sendAuthCodeBtn:self.sendCodeButton];
            NSString *title = NSLocalizedStringFromTable(@"验证码已发送", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        NSString *title = NSLocalizedStringFromTable(@"请输入正确手机号", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }
}

#pragma mark - getter

-(UIView *)inputView{
    if(!_inputView){
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = [UIColor whiteColor];
    }
    return _inputView;
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

-(UITextField *)binedMobileTextField{
    if(!_binedMobileTextField){
        _binedMobileTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"已绑定手机号", @"guojihua", nil);
        _binedMobileTextField.placeholder = title;
    }
    return _binedMobileTextField;
}

-(UITextField *)mobileTextField{
    if(!_mobileTextField){
        _mobileTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
        _mobileTextField.placeholder = title;
    }
    return _mobileTextField;
}

-(UITextField *)identifyingCodeTextField{
    if(!_identifyingCodeTextField){
        _identifyingCodeTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"验证码", @"guojihua", nil);
        _identifyingCodeTextField.placeholder = title;
    }
    return _identifyingCodeTextField;
}

-(UITextField *)loginPassWordTextField{
    if(!_loginPassWordTextField){
        _loginPassWordTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"登录密码", @"guojihua", nil);
        _loginPassWordTextField.placeholder = title;
    }
    return _loginPassWordTextField;
}

-(UIButton *)sendCodeButton{
    if(!_sendCodeButton){
        _sendCodeButton = [[UIButton alloc] init];
         NSString *title = NSLocalizedStringFromTable(@"获取验证码", @"guojihua", nil);
        [_sendCodeButton setTitle:title forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendCodeButton addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCodeButton;
}

-(UIButton *)confirmButton{
    if(!_confirmButton){
        _confirmButton = [[UIButton alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"确定", @"guojihua", nil);
        [_confirmButton setTitle:title forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 15;
        _confirmButton.backgroundColor = UNCLICK_COLOR;
    }
    return _confirmButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
