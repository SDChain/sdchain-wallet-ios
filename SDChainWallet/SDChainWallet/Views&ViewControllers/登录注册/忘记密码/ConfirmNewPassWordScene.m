//
//  ConfirmNewPassWordScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/11.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ConfirmNewPassWordScene.h"
#import "Masonry.h"
#import "HTTPRequestManager.h"
#import "NSString+validate.h"

@interface ConfirmNewPassWordScene ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *headBackImageView;
@property(nonatomic,strong)UIView *inputContentView;
@property(nonatomic,strong)UITextField *acountTextField;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIButton *nextStepButton;

@end

@implementation ConfirmNewPassWordScene

- (void)viewDidLoad {
    [super viewDidLoad];

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

    [self.inputContentView addSubview:self.acountTextField];
    [self.inputContentView addSubview:self.lineView1];
    [self.inputContentView addSubview:self.codeTextField];
    [self.inputContentView addSubview:self.lineView2];
    [self.inputContentView addSubview:self.nextStepButton];
}


-(void)setupLayOut{
    
    [self.acountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(50);
        make.height.mas_equalTo(35);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.acountTextField.mas_bottom).offset(4.5);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-130);
        make.top.equalTo(self.lineView1.mas_bottom).offset(24);
        make.height.mas_equalTo(35);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.codeTextField.mas_bottom).offset(4.5);
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(kHeight(40));
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.lineView2.mas_bottom).offset(35);
    }];
    
    
}

#pragma mark - action

-(void)confirmNextStepButtonAction{
    if([self.acountTextField.text isEqualToString:self.codeTextField.text]){
        [HTTPRequestManager forgetSecretWithUserName:self.accountString password:self.acountTextField.text phone:self.phoneString showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            SYSTEM_SET_(self.accountString, USER_NAME);
            SYSTEM_SET_(self.codeTextField.text, defaultPasword);
            if([self.accountString containsString:@"@"]){
                SYSTEM_SET_(self.accountString, EMAIL);
            }else{
                SYSTEM_SET_(self.phoneString, PHONE);
            }

            [self.navigationController popToRootViewControllerAnimated:YES];
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSString *qingqiushibai = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
            [self presentAlertWithTitle:qingqiushibai message:@"" dismissAfterDelay:1.5 completion:nil];
        }];
    }else{
        NSString *liangcimimashurubuyizhi = NSLocalizedStringFromTable(@"两次密码输入不一致", @"guojihua", nil);
        [self presentAlertWithTitle:liangcimimashurubuyizhi message:@"" dismissAfterDelay:1.5 completion:nil];
    }
}

#pragma mark - UITextField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.acountTextField.text isEqualToString:self.codeTextField.text] && self.acountTextField.text.length >= 6){
        self.nextStepButton.backgroundColor = NAVIBAR_COLOR;
        self.nextStepButton.enabled = YES;
    }
    else{
        self.nextStepButton.backgroundColor = UNCLICK_COLOR;
        self.nextStepButton.enabled = NO;
    }
}

#pragma mark - UITextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if(textField.text.length >= 16){
        textField.text = [textField.text substringToIndex:16];
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

#pragma mark - getter

-(UIImageView *)headBackImageView{
    if(!_headBackImageView){
        _headBackImageView = [[UIImageView alloc] init];
        _headBackImageView.image = [UIImage imageNamed:@"denglu_backImage"];
    }
    return _headBackImageView;
}

-(UITextField *)acountTextField{
    if(!_acountTextField){
        _acountTextField = [[UITextField alloc] init];
         NSString *shuruxinmima = NSLocalizedStringFromTable(@"请输入6~16位登录密码", @"guojihua", nil);
        _acountTextField.placeholder = shuruxinmima;
        _acountTextField.delegate = self;
        _acountTextField.secureTextEntry = YES;
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

-(UITextField *)codeTextField{
    if(!_codeTextField){
        _codeTextField = [[UITextField alloc] init];
            NSString *qingshuruquerenmima = NSLocalizedStringFromTable(@"请再次输入登录密码", @"guojihua", nil);
        _codeTextField.placeholder = qingshuruquerenmima;
        _codeTextField.secureTextEntry = YES;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
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
            NSString *denglu = NSLocalizedStringFromTable(@"修改", @"guojihua", nil);
        [_nextStepButton setTitle:denglu forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _nextStepButton.backgroundColor = UNCLICK_COLOR;
        _nextStepButton.layer.masksToBounds = YES;
        _nextStepButton.layer.cornerRadius = kHeight(15);
        [_nextStepButton addTarget:self action:@selector(confirmNextStepButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
