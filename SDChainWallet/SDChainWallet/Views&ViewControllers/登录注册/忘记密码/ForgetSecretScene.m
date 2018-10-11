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
#import "ChooseAreaView.h"

@interface ForgetSecretScene ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *headBackImageView;
@property(nonatomic,strong)UILabel *countryTitleLabel;
@property(nonatomic,strong)UILabel *countrydetailLabel;
@property(nonatomic,strong)UILabel *accssonyLabel;
@property(nonatomic,strong)UIButton *chooseAreaButton;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIView *inputContentView;
@property(nonatomic,strong)UITextField *acountTextField;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)UIButton *sendCodeButton;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIButton *nextStepButton;
@property(nonatomic,strong)UIButton *changeForgetButton;

@property(nonatomic,strong)NSString *smsId;
@property(nonatomic,strong)NSString *smsCode;
@property(nonatomic,strong)NSString *areaCode;

@end

@implementation ForgetSecretScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self setupView];
    [self changeActionWithType:[SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]];
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
    [self.inputContentView addSubview:self.sendCodeButton];
    [self.inputContentView addSubview:self.nextStepButton];
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGusture];
}

-(void)changeActionWithType:(BOOL)type{
    [self.inputContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if(type){
        [self setupMobileView];
        [self setupMobileLayOut];
    }
    else{
        [self setupEmailView];
        [self setupEmailLayOut];
    }
    [self checkAccount];
}

-(void)setupMobileView{
    [self.inputContentView addSubview:self.countryTitleLabel];
    [self.inputContentView addSubview:self.countrydetailLabel];
    [self.inputContentView addSubview:self.lineView];
    [self.inputContentView addSubview:self.accssonyLabel];
    [self.inputContentView addSubview:self.chooseAreaButton];
    [self.inputContentView addSubview:self.acountTextField];
    [self.inputContentView addSubview:self.lineView1];
    [self.inputContentView addSubview:self.codeTextField];
    [self.inputContentView addSubview:self.lineView2];
    [self.inputContentView addSubview:self.sendCodeButton];
    [self.inputContentView addSubview:self.nextStepButton];
    [self.inputContentView addSubview:self.changeForgetButton];
    NSString *qingshurushoujihao = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
    self.acountTextField.placeholder = qingshurushoujihao;
    self.acountTextField.text = @"";
    self.codeTextField.text = @"";
    [self.changeForgetButton setTitle:NSLocalizedStringFromTable(@"通过邮箱找回", @"guojihua", nil) forState:UIControlStateNormal];
}

-(void)setupEmailView{
    [self.inputContentView addSubview:self.acountTextField];
    [self.inputContentView addSubview:self.lineView1];
    [self.inputContentView addSubview:self.codeTextField];
    [self.inputContentView addSubview:self.lineView2];
    [self.inputContentView addSubview:self.sendCodeButton];
    [self.inputContentView addSubview:self.nextStepButton];
    [self.inputContentView addSubview:self.changeForgetButton];
    NSString *qingshuruyouxiang = NSLocalizedStringFromTable(@"请输入邮箱", @"guojihua", nil);
    self.acountTextField.placeholder = qingshuruyouxiang;
    self.codeTextField.text = @"";
    [self.changeForgetButton setTitle:NSLocalizedStringFromTable(@"通过手机找回", @"guojihua", nil) forState:UIControlStateNormal];
}

//-(void)setupLayOut{
//
//    [self.acountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(40);
//        make.right.mas_equalTo(-40);
//        make.top.mas_equalTo(50);
//        make.height.mas_equalTo(35);
//    }];
//
//    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(40);
//        make.right.mas_equalTo(-40);
//        make.height.mas_equalTo(1);
//        make.top.equalTo(self.acountTextField.mas_bottom).offset(4.5);
//    }];
//    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(40);
//        make.right.mas_equalTo(-130);
//        make.top.equalTo(self.lineView1.mas_bottom).offset(24);
//        make.height.mas_equalTo(35);
//    }];
//    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(40);
//        make.right.mas_equalTo(-40);
//        make.height.mas_equalTo(1);
//        make.top.equalTo(self.codeTextField.mas_bottom).offset(4.5);
//    }];
//    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-40);
//        make.bottom.equalTo(self.lineView2.mas_top).offset(-10);
//        make.height.mas_equalTo(35);
//        make.width.mas_equalTo(80);
//    }];
//
//    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.height.mas_equalTo(40);
//        make.right.mas_equalTo(-40);
//        make.top.equalTo(self.lineView2.mas_bottom).offset(35);
//    }];
//}
-(void)setupMobileLayOut{
    [self.countryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(55);
        make.height.mas_equalTo(30);
    }];
    
    [self.countrydetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countryTitleLabel.mas_top);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.countryTitleLabel.mas_bottom).offset(4);
    }];
    
    [self.accssonyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countryTitleLabel.mas_top);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(30);
    }];
    
    [self.chooseAreaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countryTitleLabel.mas_top).offset(-5);
        make.left.equalTo(self.countrydetailLabel.mas_left);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.accssonyLabel.mas_right);
    }];
    
    [self.acountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.lineView.mas_bottom).offset(24);
        make.height.mas_equalTo(35);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(1);
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
        make.height.mas_equalTo(1);
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
    
    [self.changeForgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(30);
    }];
    
    
    
}

-(void)setupEmailLayOut{
    
    [self.acountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(54);
        make.height.mas_equalTo(35);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(1);
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
        make.height.mas_equalTo(1);
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
    
    [self.changeForgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(30);
    }];
    
    
    
}



#pragma mark - action

//选择国家、地区
-(void)chooseAreaAction{
    [self.acountTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    ChooseAreaView *popView = [[ChooseAreaView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    popView.ConfirmBlock = ^{
        NSDictionary *dict = SYSTEM_GET_(CURRENTAREA);
        if([[GlobalMethod getCurrentLanguage] isEqualToString:@"tc"]){
            self.countrydetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"tw"]];
        }else if ([[GlobalMethod getCurrentLanguage] isEqualToString:@"en"]){
            self.countrydetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"en"]];
        }else{
            self.countrydetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"zh"]];
        }
    };
    [popView showAction];
}

-(void)sendCodeAction{
    
    if([SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]){
        [HTTPRequestManager GetVerifyingCodeWithMobile:self.acountTextField.text  mark:@"1" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.smsId = responseObject[@"smsId"];
            self.smsCode = responseObject[@"smsCode"];
            NSDictionary *dict = SYSTEM_GET_(CURRENTAREA);
            self.areaCode = [NSString stringWithFormat:@"%d",[dict[@"code"] intValue]];
            [GlobalMethod startTime:59 sendAuthCodeBtn:self.sendCodeButton];
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
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
}

-(void)changeFindPasswordAction{
    if([self.changeForgetButton.titleLabel.text isEqualToString:NSLocalizedStringFromTable(@"通过邮箱找回", @"guojihua", nil)]){
        SYSTEM_SET_(@"0", LOGINTYPE);
        [self changeActionWithType:NO];
    }else{
        SYSTEM_SET_(@"1", LOGINTYPE);
        [self changeActionWithType:YES];
    }
}

-(void)checkAccount{
    BOOL loginType = ([SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]) ? YES:NO;
    
//    NSString *loginName = SYSTEM_GET_(PHONE);
//    if(loginType && ![loginName containsString:@"@"]){
//        self.acountTextField.text = loginName;
//    }else if (!loginType && [loginName containsString:@"@"]){
//        self.acountTextField.text = loginName;
//    }else{
//        self.acountTextField.text = @"";
//    }
}

-(void)forgetSecretNextStepButtonAction{
    if(self.smsId){
        if([SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]){
            [HTTPRequestManager registWithMobile:self.acountTextField.text codeId:self.smsId code:self.codeTextField.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                ConfirmNewPassWordScene *scene = [[ConfirmNewPassWordScene alloc] init];
                scene.accountString = [self.areaCode stringByAppendingString:[NSString stringWithFormat:@"%@",self.acountTextField.text]];
                scene.phoneString = [NSString stringWithFormat:@"%@",self.acountTextField.text];
                [self.navigationController pushViewController:scene animated:YES];
            } warn:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } error:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }
        else{
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
    }else{
        [self presentAlertWithTitle:NSLocalizedStringFromTable(@"请获取验证码", @"guojihua", nil) message:@"" dismissAfterDelay:1.5 completion:nil];
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([NSString testCodeNumber:self.codeTextField.text]){
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
        NSCharacterSet*cs1;
        NSCharacterSet*cs2;
        
        cs1 = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        cs2 = [[NSCharacterSet characterSetWithCharactersInString:ENGLISH_EMAIL] invertedSet];
        
        NSString*filtered1 = [[string componentsSeparatedByCharactersInSet:cs1] componentsJoinedByString:@""];
        NSString*filtered2 = [[string componentsSeparatedByCharactersInSet:cs2] componentsJoinedByString:@""];
        if(string.length > 1){
            return YES;
        }else{
            return [string isEqualToString:filtered1] || [string isEqualToString:filtered2];
        }
        

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

-(UILabel *)countryTitleLabel{
    if(!_countryTitleLabel){
        _countryTitleLabel = [[UILabel alloc] init];
        _countryTitleLabel.textColor = NAVIBAR_COLOR;
        _countryTitleLabel.font = [UIFont systemFontOfSize:17];
        NSString *guojiadiqu = NSLocalizedStringFromTable(@"国家/地区", @"guojihua", nil);
        _countryTitleLabel.text = guojiadiqu;
    }
    return _countryTitleLabel;
}

-(UILabel *)countrydetailLabel{
    if(!_countrydetailLabel){
        _countrydetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, WIDTH/2+kHeight(50), WIDTH-230, 30)];
        _countrydetailLabel.textColor = [UIColor blackColor];
        _countrydetailLabel.font = [UIFont systemFontOfSize:17];
        _countrydetailLabel.textAlignment = NSTextAlignmentRight;
        if(SYSTEM_GET_(CURRENTAREA)){
            NSDictionary *dict = SYSTEM_GET_(CURRENTAREA);
            if([[GlobalMethod getCurrentLanguage] isEqualToString:@"tc"]){
                _countrydetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"tw"]];
            }else if ([[GlobalMethod getCurrentLanguage] isEqualToString:@"en"]){
                _countrydetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"en"]];
            }else{
                _countrydetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"zh"]];
            }
        }else{
            NSDictionary *dict = @{
                                   @"en": @"China",
                                   @"zh": @"中国",
                                   @"tw": @"中國",
                                   @"locale": @"CN",
                                   @"code": @"86"
                                   };
            SYSTEM_SET_(dict, CURRENTAREA);
            NSString *jiazhongguo = NSLocalizedStringFromTable(@"中国", @"guojihua", nil);
            _countrydetailLabel.text = [NSString stringWithFormat:@"+86 %@",jiazhongguo];
        }
    }
    return _countrydetailLabel;
}

-(UILabel *)accssonyLabel{
    if(!_accssonyLabel){
        _accssonyLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-60, WIDTH/2+kHeight(50), 20, 30)];
        _accssonyLabel.textColor = [UIColor lightGrayColor];
        _accssonyLabel.font = KICON_FONT(17);
        _accssonyLabel.text = @"\U0000e729";
    }
    return _accssonyLabel;
}

-(UIButton *)chooseAreaButton{
    if(!_chooseAreaButton){
        _chooseAreaButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-160, WIDTH/2+kHeight(40)+5, 120, 40)];
        [_chooseAreaButton addTarget:self action:@selector(chooseAreaAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseAreaButton;
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
-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = NAVIBAR_COLOR;
    }
    return _lineView;
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

-(UIButton *)changeForgetButton{
    if(!_changeForgetButton){
        _changeForgetButton = [[UIButton alloc] init];
        [_changeForgetButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _changeForgetButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_changeForgetButton addTarget:self action:@selector(changeFindPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeForgetButton;
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
