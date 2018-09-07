//
//  ForgetSecretScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/10.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ForgetSecretScene.h"
#import "Masonry.h"
#import "HTTPRequestManager.h"
#import "ConfirmNewPassWordScene.h"
#import "NSString+validate.h"

@interface ForgetSecretScene ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *headBackImageView;
@property(nonatomic,strong)UIView *inputContentView;
@property(nonatomic,strong)UILabel *acountTitleLabel;
@property(nonatomic,strong)UITextField *acountTextField;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UILabel *codeTitleLabel;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)UIButton *sendCodeButton;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIButton *nextStepButton;

@property(nonatomic,strong)NSString *smsId;
@property(nonatomic,strong)NSString *smsCode;

@end

@implementation ForgetSecretScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self setupView];
    [self setupLayOut];
    // Do any additional setup after loading the view.
}

-(void)hideKeyBoard{
    [self.acountTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}

-(void)setupView{
    [self.view addSubview:self.headBackImageView];
    [self.view addSubview:self.inputContentView];
    [self.headBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    
    [self.inputContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBackImageView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.inputContentView addSubview:self.acountTitleLabel];
    [self.inputContentView addSubview:self.acountTextField];
    [self.inputContentView addSubview:self.lineView1];
    [self.inputContentView addSubview:self.codeTitleLabel];
    [self.inputContentView addSubview:self.codeTextField];
    [self.inputContentView addSubview:self.lineView2];
    [self.inputContentView addSubview:self.sendCodeButton];
    [self.inputContentView addSubview:self.nextStepButton];
    
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGusture];
}

-(void)setupLayOut{
    
    
    [self.acountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(50);
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
    
    
}

#pragma mark - action
-(void)sendCodeAction{
    
    if([NSString valiMobile:self.acountTextField.text]){
        [HTTPRequestManager GetVerifyingCodeWithMobile:self.acountTextField.text  mark:@"1" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.smsId = responseObject[@"smsId"];
            self.smsCode = responseObject[@"smsCode"];
            [GlobalMethod startTime:59 sendAuthCodeBtn:self.sendCodeButton];
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else if ([NSString validateEmail:self.acountTextField.text]){
        [HTTPRequestManager GetVerifyingCodeWithEmail:self.acountTextField.text mark:@"1" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.smsId = responseObject[@"smsId"];
            self.smsCode = responseObject[@"smsCode"];
            [GlobalMethod startTime:59 sendAuthCodeBtn:self.sendCodeButton];
            NSLog(@"%@",responseObject);
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    else{
            NSString *qingshuruzhengqueshoujihao = NSLocalizedStringFromTable(@"手机号/邮箱", @"guojihua", nil);
        [self presentAlertWithTitle:qingshuruzhengqueshoujihao message:@"" dismissAfterDelay:1.5 completion:nil];
    }
}

-(void)forgetSecretNextStepButtonAction{
    if([NSString valiMobile:self.acountTextField.text] && [NSString testCodeNumber:self.codeTextField.text]){
        [HTTPRequestManager registWithMobile:self.acountTextField.text codeId:self.smsId code:self.codeTextField.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            ConfirmNewPassWordScene *scene = [[ConfirmNewPassWordScene alloc] init];
            scene.accountString = self.acountTextField.text;
            [self.navigationController pushViewController:scene animated:YES];
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];

    }
    else if ([NSString validateEmail:self.acountTextField.text] && [NSString testCodeNumber:self.codeTextField.text]){
        [HTTPRequestManager registWithEmail:self.acountTextField.text codeId:self.smsId code:self.codeTextField.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            ConfirmNewPassWordScene *scene = [[ConfirmNewPassWordScene alloc] init];
            scene.accountString = self.acountTextField.text;
            [self.navigationController pushViewController:scene animated:YES];
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(([NSString valiMobile:self.acountTextField.text] && [NSString testCodeNumber:self.codeTextField.text]) || ([NSString validateEmail: self.acountTextField.text] && [NSString testCodeNumber:self.codeTextField.text])){
        self.nextStepButton.backgroundColor = NAVIBAR_COLOR;
        self.nextStepButton.enabled = YES;
    }
    else{
        self.nextStepButton.backgroundColor = UNCLICK_COLOR;
        self.nextStepButton.enabled = NO;
    }

    
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSLog(@"%@",SYSTEM_GET_(USER_NAME));
    if (textField == self.acountTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (self.acountTextField.text.length >= 30) {
            self.acountTextField.text = [textField.text substringToIndex:30];
            return NO;
        }
//        NSCharacterSet*cs;
//        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
//        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        return [string isEqualToString:filtered];
    }else if (textField == self.codeTextField){
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if(self.codeTextField.text.length >= 6){
            self.codeTextField.text = [textField.text substringToIndex:6];
            return NO;
        }
        NSCharacterSet*cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

#pragma mark - getter

-(UIImageView *)headBackImageView{
    if(!_headBackImageView){
        _headBackImageView = [[UIImageView alloc] init];
        _headBackImageView.image = [UIImage imageNamed:@"denglu_backImage"];
    }
    return _headBackImageView;
}

-(UILabel *)acountTitleLabel{
    if(!_acountTitleLabel){
        _acountTitleLabel = [[UILabel alloc] init];
        _acountTitleLabel.textColor = NAVIBAR_COLOR;
        _acountTitleLabel.font = [UIFont systemFontOfSize:17];
            NSString *yonghuming = NSLocalizedStringFromTable(@"用户名", @"guojihua", nil);
        _acountTitleLabel.text = yonghuming;
    }
    return _acountTitleLabel;
}

-(UITextField *)acountTextField{
    if(!_acountTextField){
        _acountTextField = [[UITextField alloc] init];
        _acountTextField.delegate = self;
         NSString *shoujihaoyouxiang = NSLocalizedStringFromTable(@"手机号/邮箱", @"guojihua", nil);
        _acountTextField.placeholder = shoujihaoyouxiang;
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
         NSString *yanzhengma = NSLocalizedStringFromTable(@"验证码", @"guojihua", nil);
        _codeTitleLabel.text = yanzhengma;
        _codeTitleLabel.font = [UIFont systemFontOfSize:17];
        _codeTitleLabel.textColor = NAVIBAR_COLOR;
    }
    return _codeTitleLabel;
    
    
}

-(UITextField *)codeTextField{
    if(!_codeTextField){
        _codeTextField = [[UITextField alloc] init];
        NSString *qingshuruyanzhengma = NSLocalizedStringFromTable(@"请输入验证码", @"guojihua", nil);
        _codeTextField.placeholder = qingshuruyanzhengma;
        _codeTextField.delegate = self;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeTextField;
}

-(UIButton *)sendCodeButton{
    if(!_sendCodeButton){
        _sendCodeButton = [[UIButton alloc] init];
        NSString *huoqumima = NSLocalizedStringFromTable(@"获取验证码", @"guojihua", nil);
        [_sendCodeButton setTitle:huoqumima forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendCodeButton addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
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
        NSString *xiayibu = NSLocalizedStringFromTable(@"下一步", @"guojihua", nil);
        [_nextStepButton setTitle:xiayibu forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _nextStepButton.backgroundColor = [UIColor lightGrayColor];
        _nextStepButton.layer.masksToBounds = YES;
        _nextStepButton.layer.cornerRadius = 15.0;
        [_nextStepButton addTarget:self action:@selector(forgetSecretNextStepButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _nextStepButton.enabled = NO;
    }
    return _nextStepButton;
    
}


-(UIView *)inputContentView{
    if(!_inputContentView){
        _inputContentView = [[UIView alloc] init];
        
    }
    return _inputContentView;
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
