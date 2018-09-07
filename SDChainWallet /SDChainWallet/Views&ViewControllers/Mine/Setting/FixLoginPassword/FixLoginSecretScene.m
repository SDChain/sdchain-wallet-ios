//
//  FixLoginSecretScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/1.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "FixLoginSecretScene.h"
#import "HTTPRequestManager.h"
#import "NSString+validate.h"
#import "Masonry.h"

@interface FixLoginSecretScene ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UIButton *confirmButton;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIView *lineView3;
@property(nonatomic,strong)UIView *lineView4;
@property(nonatomic,strong)UIView *lineView5;
@property(nonatomic,strong)UIView *lineView6;
@property(nonatomic,strong)UITextField *acountTextField;
@property(nonatomic,strong)UITextField *originalSecretTextField;
@property(nonatomic,strong)UITextField *novelSecretTextField;
@property(nonatomic,strong)UITextField *confirmSecretTextField;
@property(nonatomic,strong)UITextField *certificationTextField;
@property(nonatomic,strong)UIButton *sendCodeButton;
@property(nonatomic,strong)NSString *smsId;
@property(nonatomic,strong)NSString *markStr;

@end

@implementation FixLoginSecretScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self setupView];
    NSString *title = NSLocalizedStringFromTable(@"修改登录密码", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    if(self.type == typeLoginMobile){
        self.markStr = @"0";
    }
    else{
        self.markStr = @"1";
    }
    // Do any additional setup after loading the view.
}

-(void)hideKeyBoard{
    [self.acountTextField resignFirstResponder];
    [self.originalSecretTextField resignFirstResponder];
    [self.originalSecretTextField resignFirstResponder];
    [self.confirmSecretTextField resignFirstResponder];
    [self.certificationTextField resignFirstResponder];
}

-(void)setupView{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:gusture];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.confirmButton];
    [self.contentView addSubview:self.lineView1];
    [self.contentView addSubview:self.lineView2];
    [self.contentView addSubview:self.lineView3];
    [self.contentView addSubview:self.lineView4];
    [self.contentView addSubview:self.lineView5];
    [self.contentView addSubview:self.lineView6];
    [self.contentView addSubview:self.acountTextField];
    [self.contentView addSubview:self.originalSecretTextField];
    [self.contentView addSubview:self.novelSecretTextField];
    [self.contentView addSubview:self.confirmSecretTextField];
    [self.contentView addSubview:self.certificationTextField];
    [self.contentView addSubview:self.sendCodeButton];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kHeight(15));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(250));
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(20));
        make.right.mas_equalTo(kWidth(-20));
        make.height.mas_equalTo(kHeight(40));
        make.top.equalTo(self.contentView.mas_bottom).offset(kHeight(30));
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(50));
        make.left.mas_equalTo(kWidth(15));
        make.height.mas_equalTo(0.7);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(100));
        make.left.mas_equalTo(kWidth(15));
        make.height.mas_equalTo(0.7);
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(150));
        make.left.mas_equalTo(kWidth(15));
        make.height.mas_equalTo(0.7);
    }];
    
    [self.lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(200));
        make.left.mas_equalTo(kWidth(15));
        make.height.mas_equalTo(0.7);
    }];
    
    [self.lineView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
    
    [self.acountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(15));
        make.right.mas_equalTo(kWidth(-15));
        make.top.mas_equalTo(kHeight(5));
        make.height.mas_equalTo(kHeight(40));
    }];
    
    [self.originalSecretTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(15));
        make.right.mas_equalTo(kWidth(-15));
        make.top.mas_equalTo(kHeight(55));
        make.height.mas_equalTo(kHeight(40));
    }];
    
    [self.novelSecretTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(15));
        make.right.mas_equalTo(kWidth(-15));
        make.top.mas_equalTo(kHeight(105));
        make.height.mas_equalTo(kHeight(40));
    }];
    
    [self.confirmSecretTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(15));
        make.right.mas_equalTo(kWidth(-15));
        make.top.mas_equalTo(kHeight(155));
        make.height.mas_equalTo(kHeight(40));
    }];
    
    [self.certificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(15));
        make.right.mas_equalTo(kWidth(-120));
        make.top.mas_equalTo(kHeight(205));
        make.height.mas_equalTo(kHeight(40));
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.mas_equalTo(kWidth(-10));
        make.centerY.equalTo(self.certificationTextField.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(kHeight(40));
    }];

}

-(void)setupNavi{
    
}
#pragma mark - action

-(void)fixLoginSecretSendCodeAction{
    if(self.type == typeLoginMobile){
        [HTTPRequestManager GetVerifyingCodeWithMobile:SYSTEM_GET_(USER_NAME)  mark:@"1" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.smsId = responseObject[@"smsId"];
            [GlobalMethod startTime:59 sendAuthCodeBtn:self.sendCodeButton];
            NSString *title = NSLocalizedStringFromTable(@"验证码已发送", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    else{
        [HTTPRequestManager GetVerifyingCodeWithEmail:SYSTEM_GET_(USER_NAME) mark:@"1" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            [GlobalMethod startTime:59 sendAuthCodeBtn:self.sendCodeButton];
            self.smsId = responseObject[@"smsId"];
            NSString *title = NSLocalizedStringFromTable(@"验证码已发送", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}

-(void)confirmButttonAction{
    if (self.originalSecretTextField.text.length < 6 && self.originalSecretTextField.text.length > 20){
        NSString *title = NSLocalizedStringFromTable(@"6-16位密码", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if (![self.novelSecretTextField.text isEqualToString: self.confirmSecretTextField.text]){
        NSString *title = NSLocalizedStringFromTable(@"两次密码输入不一致", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if (self.certificationTextField.text.length == 0){
        NSString *title = NSLocalizedStringFromTable(@"请输入验证码", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }else{
        [HTTPRequestManager updateLoginPasswordWithOldPassword:self.originalSecretTextField.text password:self.confirmSecretTextField.text smsId:self.smsId code:self.certificationTextField.text mark:self.markStr showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.navigationController popViewControllerAnimated:YES];
            NSString *title = NSLocalizedStringFromTable(@"修改成功", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            
        } reLogin:^{
            
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString *title = NSLocalizedStringFromTable(@"请求错误", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }];
    }
}

-(void)buttonEnableAction{
    self.confirmButton.backgroundColor = NAVIBAR_COLOR;
    self.confirmButton.enabled = YES;
}

-(void)buttonUnableAction{
    self.confirmButton.backgroundColor = UNCLICK_COLOR;
    self.confirmButton.enabled = NO;
}


#pragma mark - UITextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger accountLenght = [NSString stringWithFormat:@"%@",SYSTEM_GET_(USER_NAME)].length;
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (textField == self.acountTextField){
        if(self.acountTextField.text.length >= accountLenght){
            self.acountTextField.text = [textField.text substringToIndex:accountLenght];
            return NO;
        }
        NSCharacterSet*cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if(textField == self.originalSecretTextField){
        if(self.originalSecretTextField.text.length >= 20){
            self.originalSecretTextField.text = [textField.text substringToIndex:20];
            return NO;
        }
        NSCharacterSet*cs1;
        NSCharacterSet*cs2;
        
        cs1 = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        cs2 = [[NSCharacterSet characterSetWithCharactersInString:ENGLISH] invertedSet];
        
        NSString*filtered1 = [[string componentsSeparatedByCharactersInSet:cs1] componentsJoinedByString:@""];
        NSString*filtered2 = [[string componentsSeparatedByCharactersInSet:cs2] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered1] || [string isEqualToString:filtered2];
        
    }else if (textField == self.novelSecretTextField){
        if(self.novelSecretTextField.text.length >= 20){
            self.novelSecretTextField.text = [textField.text substringToIndex:20];
            return NO;
        }
        NSCharacterSet*cs1;
        NSCharacterSet*cs2;
        
        cs1 = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        cs2 = [[NSCharacterSet characterSetWithCharactersInString:ENGLISH] invertedSet];
        
        NSString*filtered1 = [[string componentsSeparatedByCharactersInSet:cs1] componentsJoinedByString:@""];
        NSString*filtered2 = [[string componentsSeparatedByCharactersInSet:cs2] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered1] || [string isEqualToString:filtered2];
    }else if (textField == self.confirmSecretTextField){
        if(self.confirmSecretTextField.text.length >= 20){
            self.confirmSecretTextField.text = [textField.text substringToIndex:20];
            return NO;
        }
        NSCharacterSet*cs1;
        NSCharacterSet*cs2;
        
        cs1 = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        cs2 = [[NSCharacterSet characterSetWithCharactersInString:ENGLISH] invertedSet];
        
        NSString*filtered1 = [[string componentsSeparatedByCharactersInSet:cs1] componentsJoinedByString:@""];
        NSString*filtered2 = [[string componentsSeparatedByCharactersInSet:cs2] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered1] || [string isEqualToString:filtered2];
    }
    
    
    
    else if (textField == self.certificationTextField){
        if(self.certificationTextField.text.length >= 6){
            self.certificationTextField.text = [textField.text substringToIndex:6];
            return NO;
        }
        NSCharacterSet*cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([NSString validatePassword:self.originalSecretTextField.text] && [NSString validatePassword:self.novelSecretTextField.text] && [NSString validatePassword:self.confirmSecretTextField.text] && self.certificationTextField.text.length == 6){
        
        [self buttonEnableAction];
    }else{
        [self buttonUnableAction];
    }
}


#pragma mark - getter
-(UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

-(UIButton *)confirmButton{
    if(!_confirmButton){
        _confirmButton = [[UIButton alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"确定", @"guojihua", nil);
        [_confirmButton setTitle:title forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButttonAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.backgroundColor = NAVIBAR_COLOR;
        _confirmButton.layer.cornerRadius = kHeight(20);
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

-(UITextField *)acountTextField{
    if(!_acountTextField){
        _acountTextField = [[UITextField alloc] init];
        _acountTextField.keyboardType = UIKeyboardTypePhonePad;
        _acountTextField.delegate = self;
        _acountTextField.enabled = NO;
        if(self.type == typeLoginMobile){
            NSString *title = NSLocalizedStringFromTable(@"手机号", @"guojihua", nil);
            _acountTextField.placeholder = title;
        }else{
            NSString *title = NSLocalizedStringFromTable(@"邮箱", @"guojihua", nil);
            _acountTextField.placeholder = title;
        }
        _acountTextField.text = SYSTEM_GET_(USER_NAME);
    }
    return _acountTextField;
}

-(UITextField *)originalSecretTextField{
    if(!_originalSecretTextField){
        _originalSecretTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"原密码", @"guojihua", nil);
        _originalSecretTextField.placeholder = title;
        _originalSecretTextField.delegate = self;
    }
    return _originalSecretTextField;
}

-(UITextField *)novelSecretTextField{
    if(!_novelSecretTextField){
        _novelSecretTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"6-16位密码", @"guojihua", nil);
        _novelSecretTextField.placeholder = title;
        _novelSecretTextField.secureTextEntry = YES;
        _novelSecretTextField.delegate = self;
    }
    return _novelSecretTextField;
}

-(UITextField *)confirmSecretTextField{
    if(!_confirmSecretTextField){
        _confirmSecretTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"确认密码", @"guojihua", nil);
        _confirmSecretTextField.placeholder = title;
        _confirmSecretTextField.secureTextEntry = YES;
        _confirmSecretTextField.delegate = self;
    }
    return _confirmSecretTextField;
}

-(UITextField *)certificationTextField{
    if(!_certificationTextField){
        _certificationTextField = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"验证码", @"guojihua", nil);
        _certificationTextField.placeholder = title;
        _certificationTextField.keyboardType = UIKeyboardTypeNumberPad;
        _certificationTextField.delegate = self;
    }
    return _certificationTextField;
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

-(UIView *)lineView6{
    if(!_lineView6){
        _lineView6 = [[UIView alloc] init];
        _lineView6.backgroundColor = LINE_COLOR;
    }
    return _lineView6;
}

-(UIButton *)sendCodeButton{
    if(!_sendCodeButton){
        _sendCodeButton = [[UIButton alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"获取验证码", @"guojihua", nil);
        [_sendCodeButton setTitle:title forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        [_sendCodeButton addTarget:self action:@selector(fixLoginSecretSendCodeAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _sendCodeButton;
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
