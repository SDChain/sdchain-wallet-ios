//
//  BindMobileScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/21.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "BindMobileScene.h"
#import "Masonry.h"
#import "NSString+validate.h"
#import "HTTPRequestManager.h"


@interface BindMobileScene ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *inputView;

@property(nonatomic,strong)UIView *lineView1;

@property(nonatomic,strong)UIView *lineView2;

@property(nonatomic,strong)UIView *lineView3;

@property(nonatomic,strong)UIView *lineView4;

@property(nonatomic,strong)UIView *lineView5;

@property(nonatomic,strong)UITextField *currentMobileTextField;

@property(nonatomic,strong)UILabel *currentMobileLabel;

@property(nonatomic,strong)UITextField *mobileTextField;

@property(nonatomic,strong)UITextField *identifyingCodeTextField;

@property(nonatomic,strong)UITextField *loginPassWordTextField;

@property(nonatomic,strong)UIButton *sendCodeButton;

@property(nonatomic,strong)UIButton *confirmButton;

@property(nonatomic,strong)NSString *smsId;

@property(nonatomic,strong)NSString *identifyingMobile;              //用于验证是否验证码手机

@end

@implementation BindMobileScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];
    [self setupData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupData{
    self.smsId = @"";
}

-(void)setupNavi{
    
    if(self.accountType == typeMobile){
        if(self.bindType == typeBind){
            NSString *title = NSLocalizedStringFromTable(@"绑定手机", @"guojihua", nil);
            [self setTitleViewWithTitle:title];
        }
        else{
            NSString *title = NSLocalizedStringFromTable(@"换绑手机", @"guojihua", nil);
            [self setTitleViewWithTitle:title];
        }
    }else{
        if(self.bindType == typeBind){
            NSString *title = NSLocalizedStringFromTable(@"绑定邮箱", @"guojihua", nil);
            [self setTitleViewWithTitle:title];
        }
        else{
            NSString *title = NSLocalizedStringFromTable(@"换绑邮箱", @"guojihua", nil);
            [self setTitleViewWithTitle:title];
        }
    }

}

- (void)setupView{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.confirmButton];
    
    [self.inputView addSubview:self.lineView1];
    [self.inputView addSubview:self.lineView2];
    [self.inputView addSubview:self.lineView3];
    [self.inputView addSubview:self.lineView4];

    [self.inputView addSubview:self.mobileTextField];
    [self.inputView addSubview:self.identifyingCodeTextField];
    [self.inputView addSubview:self.loginPassWordTextField];
    [self.inputView addSubview:self.sendCodeButton];
    
    if(self.bindType == typeRemoveBind){
        
        [self.inputView addSubview:self.lineView5];
        [self.inputView addSubview:self.currentMobileTextField];
        [self.inputView addSubview:self.currentMobileLabel];
        [self setupLayoutRemoveBind];
    }
    else{
        [self setupLayoutBind];
    }
    if(self.accountType == typeMobile){
        self.currentMobileLabel.text = SYSTEM_GET_(PHONE);
    }else{
        self.currentMobileLabel.text = SYSTEM_GET_(EMAIL);
    }
    
}

-(void)setupLayoutBind{
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(10));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(kHeight(150));
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
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(0.6));
    }];
    
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(kWidth(10));
        make.top.mas_equalTo(kHeight(5));
        make.height.mas_equalTo(40);
    }];
    
    [self.identifyingCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(10));
        make.right.mas_equalTo(kWidth(110));
        make.top.mas_equalTo(kHeight(55));
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

-(void)setupLayoutRemoveBind{
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
    
    [self.currentMobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(10));
        make.height.mas_equalTo(kHeight(30));
        make.top.mas_equalTo(kHeight(10));
        make.width.mas_equalTo(150);
    }];
    
    [self.currentMobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kWidth(-10));
        make.height.mas_equalTo(kHeight(30));
        make.top.mas_equalTo(kHeight(10));
        make.width.mas_equalTo(160);
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
    self.identifyingMobile = self.mobileTextField.text;
    if([NSString valiMobile:mobileStr]){
        if(self.accountType == typeMobile){
        [HTTPRequestManager GetVerifyingCodeWithMobile:self.mobileTextField.text  mark:@"1" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.smsId = responseObject[@"smsId"];
            [GlobalMethod startTime:59 sendAuthCodeBtn:self.sendCodeButton];
            NSString *title = NSLocalizedStringFromTable(@"验证码已发送", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString *title = NSLocalizedStringFromTable(@"发送失败", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }];
        }else{
            NSString *title = NSLocalizedStringFromTable(@"邮箱号格式不正确", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }
    }else if([NSString validateEmail:mobileStr]){
        if(self.accountType == typeEmail){
        [HTTPRequestManager GetVerifyingCodeWithEmail:self.mobileTextField.text mark:@"1" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.smsId = responseObject[@"smsId"];
            [GlobalMethod startTime:59 sendAuthCodeBtn:self.sendCodeButton];
            NSString *title = NSLocalizedStringFromTable(@"验证码已发送", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString *title = NSLocalizedStringFromTable(@"发送失败", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }];}
        else{
            NSString *title = NSLocalizedStringFromTable(@"手机号格式不正确", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }
    }
    else{
        NSString *title = NSLocalizedStringFromTable(@"请输入正确账号", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }
}

-(void)confirmBindMobileAction{
//    if([self.mobileTextField.text isEqualToString:self.identifyingMobile]){
        if(self.accountType == typeMobile){
            [HTTPRequestManager bindPhoneWithSmsId:self.smsId userId:SYSTEM_GET_(USER_ID) code:self.identifyingCodeTextField.text password:self.loginPassWordTextField.text apptoken:SYSTEM_GET_(APPTOKEN) phone:self.mobileTextField.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                SYSTEM_SET_(self.mobileTextField.text, PHONE);
                __weak BindMobileScene *weakSelf = self;
                NSString *title = NSLocalizedStringFromTable(@"绑定成功", @"guojihua", nil);
                [self  presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                
            } reLogin:^{
                [GlobalMethod loginOutAction];
            } warn:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } error:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSString *title = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
                [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            }];
        }else{
            [HTTPRequestManager bindEmailWithSmsId:self.smsId code:self.identifyingCodeTextField.text password:self.loginPassWordTextField.text email:self.mobileTextField.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                SYSTEM_SET_(self.mobileTextField.text, EMAIL);
                __weak BindMobileScene *weakSelf = self;
                NSString *title = NSLocalizedStringFromTable(@"绑定成功", @"guojihua", nil);
                [self  presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            } reLogin:^{
                [GlobalMethod loginOutAction];
            } warn:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } error:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSString *title = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
                [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            }];
        }
//    }else{
//        NSString *title = NSLocalizedStringFromTable(@"验证码无效", @"guojihua", nil);
//        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
//    }

}

#pragma mark - UITextField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.smsId.length > 0 && self.identifyingCodeTextField.text.length > 0 && self.loginPassWordTextField.text.length > 0 && self.mobileTextField.text.length > 0){
        self.confirmButton.enabled = YES;
        self.confirmButton.backgroundColor = NAVIBAR_COLOR;
    }
    else{
        self.confirmButton.enabled = NO;
        self.confirmButton.backgroundColor = LINE_COLOR;
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

-(UIView *)lineView5{
    if(!_lineView5){
        _lineView5 = [[UIView alloc] init];
        _lineView5.backgroundColor = LINE_COLOR;
    }
    return _lineView5;
}

-(UITextField *)currentMobileTextField{
    if(!_currentMobileTextField){
        _currentMobileTextField = [[UITextField alloc] init];
        if(self.accountType == typeEmail){
            NSString *title = NSLocalizedStringFromTable(@"当前邮箱号", @"guojihua", nil);
            _currentMobileTextField.text = title;
        }
        else{
            NSString *title = NSLocalizedStringFromTable(@"当前手机号", @"guojihua", nil);
            _currentMobileTextField.text = title;
        }
        _currentMobileTextField.enabled = NO;
    }
    return _currentMobileTextField;
}

-(UILabel *)currentMobileLabel{
    if(!_currentMobileLabel){
        _currentMobileLabel = [[UILabel alloc] init];
    }
    return _currentMobileLabel;
}

-(UITextField *)mobileTextField{
    if(!_mobileTextField){
        _mobileTextField = [[UITextField alloc] init];
        _mobileTextField.delegate = self;
        if(self.accountType == typeEmail){
            NSString *title = NSLocalizedStringFromTable(@"邮箱", @"guojihua", nil);
            _mobileTextField.placeholder = title;
        }
        else{
             NSString *title = NSLocalizedStringFromTable(@"手机号", @"guojihua", nil);
            _mobileTextField.placeholder = title;
        }
    }
    return _mobileTextField;
}

-(UITextField *)identifyingCodeTextField{
    if(!_identifyingCodeTextField){
        _identifyingCodeTextField = [[UITextField alloc] init];
        _identifyingCodeTextField.delegate = self;
        NSString *title = NSLocalizedStringFromTable(@"验证码", @"guojihua", nil);
        _identifyingCodeTextField.placeholder = title;
    }
    return _identifyingCodeTextField;
}

-(UITextField *)loginPassWordTextField{
    if(!_loginPassWordTextField){
        _loginPassWordTextField = [[UITextField alloc] init];
        _loginPassWordTextField.delegate = self;
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
        [_confirmButton addTarget:self action:@selector(confirmBindMobileAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.backgroundColor = UNCLICK_COLOR;
    }
    return _confirmButton;
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
