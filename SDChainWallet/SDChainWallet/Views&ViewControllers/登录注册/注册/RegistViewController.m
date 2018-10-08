//
//  RegistViewController.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/25.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "RegistViewController.h"
#import "Masonry.h"
#import "ConfirmPassWordViewController.h"
#import "HTTPRequestManager.h"
#import "RSAEncryptor.h"
#import "NSString+validate.h"
#import "ImageCertificationSceneViewController.h"
#import "ChooseAreaView.h"

@interface RegistViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *headBackImageView;

@property(nonatomic,strong)UILabel *countryTitleLabel;
@property(nonatomic,strong)UILabel *countrydetailLabel;
@property(nonatomic,strong)UILabel *accssonyLabel;
@property(nonatomic,strong)UIButton *chooseAreaButton;
@property(nonatomic,strong)UIView *inputContentView;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UITextField *acountTextField;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)UIButton *sendCodeButton;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIButton *nextStepButton;
@property(nonatomic,strong)UIButton *changeRegistButton;

@property(nonatomic,strong)NSString *smsId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *imageCode;
@property(nonatomic,strong)NSString *machineId;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    self.smsId = @"";
    self.imageCode = @"";
    self.machineId = @"";
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
    [self changeActionWithType:[SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]];
    
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGusture];

}

#pragma mark - Action

-(void)hideKeyBoard{
    [self.acountTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}

-(void)popImageCertification{
    if(self.acountTextField.text.length > 0){
        ImageCertificationSceneViewController *scene = [[ImageCertificationSceneViewController alloc] initWithNibName:@"ImageCertificationSceneViewController" bundle:nil];
        __weak RegistViewController *weakSelf = self;
        scene.certifiSuccessBlock = ^(NSString *code,NSString *machineId) {
            self.imageCode = code;
            self.machineId = machineId;
            [weakSelf sendCodeAction];
        };
        [self.navigationController pushViewController:scene animated:YES];
    }else{
        if([SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]){
            NSString *title = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }else if (SYSTEM_GET_(LOGINTYPE) == RegistTypeEmail){
            NSString *title = NSLocalizedStringFromTable(@"请输入邮箱", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }
    }

}

-(void)sendCodeAction{
    self.nextStepButton.enabled = YES;
    if([SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]){
        NSString *mobileStr = [NSString stringWithFormat:@"%@",self.acountTextField.text];
        if(mobileStr.length > 0){
            [HTTPRequestManager loginGetVerifyingCodeWithMobile:self.acountTextField.text machineId:self.machineId imageCode:self.imageCode mark:@"0" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                self.smsId = responseObject[@"smsId"];
                self.userName = responseObject[@"userName"];
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
            NSString *title = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }
    }
    else{
        if(self.acountTextField.text.length > 0){
            
            [HTTPRequestManager loginGetVerifyingCodeWithEmail:self.acountTextField.text machineId:self.machineId imageCode:self.imageCode mark:@"0" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                self.smsId = responseObject[@"smsId"];
                self.userName = responseObject[@"userName"];
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
            NSString *title = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }
        
    }
    

    
}

-(void)registNextStepButtonAction{
    if([self.smsId isEqualToString:@""]){
        NSString *title = NSLocalizedStringFromTable(@"请获取验证码", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }
    else{
        self.nextStepButton.enabled = NO;
        __weak RegistViewController *weakSelf = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.nextStepButton.enabled = YES;
        });
        if([SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]){
            [HTTPRequestManager registWithMobile:self.userName codeId:self.smsId code:self.codeTextField.text showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                ConfirmPassWordViewController *scene = [[ConfirmPassWordViewController alloc] init];
                scene.smsId = self.smsId;
                scene.userName = self.userName;
                [self.navigationController pushViewController:scene animated:YES];
            } warn:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } error:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSString *title = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
                [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            }];
        }
        else{
            [HTTPRequestManager registWithEmail:self.userName codeId:self.smsId code:self.codeTextField.text showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                ConfirmPassWordViewController *scene = [[ConfirmPassWordViewController alloc] init];
                scene.smsId = self.smsId;
                scene.userName = self.userName;
                [self.navigationController pushViewController:scene animated:YES];
            } warn:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } error:^(NSString *content) {
                [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSString *title = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
                [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            }];
        }
    }
    
    

}

-(void)changeAction{
    
    if([SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]){
        SYSTEM_SET_(@"0", LOGINTYPE);
        [self changeActionWithType:NO];
    }
    else{
        SYSTEM_SET_(@"1", LOGINTYPE);
        [self changeActionWithType:YES];
    }
    
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
    [self.inputContentView addSubview:self.changeRegistButton];
    NSString *qingshurushoujihao = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
    self.acountTextField.placeholder = qingshurushoujihao;
    self.acountTextField.text = @"";
    self.codeTextField.text = @"";
    NSString *youxiangzhuce = NSLocalizedStringFromTable(@"邮箱注册", @"guojihua", nil);
    [self.changeRegistButton setTitle:youxiangzhuce forState:UIControlStateNormal];
}

-(void)setupEmailView{
    [self.inputContentView addSubview:self.acountTextField];
    [self.inputContentView addSubview:self.lineView1];
    [self.inputContentView addSubview:self.codeTextField];
    [self.inputContentView addSubview:self.lineView2];
    [self.inputContentView addSubview:self.sendCodeButton];
    [self.inputContentView addSubview:self.nextStepButton];
    [self.inputContentView addSubview:self.changeRegistButton];
    NSString *qingshuruyouxiang = NSLocalizedStringFromTable(@"请输入邮箱", @"guojihua", nil);
    self.acountTextField.placeholder = qingshuruyouxiang;
    self.codeTextField.text = @"";
    NSString *shoujizhuce = NSLocalizedStringFromTable(@"手机注册", @"guojihua", nil);
    [self.changeRegistButton setTitle:shoujizhuce forState:UIControlStateNormal];
}


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
    
    [self.changeRegistButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.changeRegistButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(30);
    }];
    
    
    
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger textLenght;
    if([SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]){
        textLenght = 11;
    }else{
        textLenght = 30;
    }
    if (textField == self.acountTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if([SYSTEM_GET_(LOGINTYPE) isEqualToString:@"1"]){
            if (self.acountTextField.text.length >= 11) {
                self.acountTextField.text = [textField.text substringToIndex:11];
                return NO;
            }
            NSCharacterSet*cs;
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
            NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return [string isEqualToString:filtered];
        }else{
            if (self.acountTextField.text.length >= 30) {
                self.acountTextField.text = [textField.text substringToIndex:30];
                return NO;
            }
            NSCharacterSet*cs1;
            NSCharacterSet*cs2;
            
            cs1 = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
            cs2 = [[NSCharacterSet characterSetWithCharactersInString:ENGLISH_EMAIL] invertedSet];
            
            NSString*filtered1 = [[string componentsSeparatedByCharactersInSet:cs1] componentsJoinedByString:@""];
            NSString*filtered2 = [[string componentsSeparatedByCharactersInSet:cs2] componentsJoinedByString:@""];
            
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
        NSString *qingshurushoujihao = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
        _acountTextField.placeholder = qingshurushoujihao;
        _acountTextField.delegate = self;
        _acountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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
        NSString *shuruyanzhengma = NSLocalizedStringFromTable(@"输入验证码", @"guojihua", nil);
        _codeTextField.placeholder = shuruyanzhengma;
        _codeTextField.delegate = self;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeTextField;
}

-(UIButton *)sendCodeButton{
    if(!_sendCodeButton){
        _sendCodeButton = [[UIButton alloc] init];
        NSString *huoquyanzhengma = NSLocalizedStringFromTable(@"获取验证码", @"guojihua", nil);
        [_sendCodeButton setTitle:huoquyanzhengma forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendCodeButton addTarget:self action:@selector(popImageCertification) forControlEvents:UIControlEventTouchUpInside];
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
        _nextStepButton.enabled = NO;
        _nextStepButton.layer.cornerRadius = 20.0;
        [_nextStepButton addTarget:self action:@selector(registNextStepButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
    
}

-(UIButton *)changeRegistButton{
    if(!_changeRegistButton){
        _changeRegistButton = [[UIButton alloc] init];
        [_changeRegistButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _changeRegistButton.titleLabel.font = [UIFont systemFontOfSize:15];
        NSString *youxiangzhuce = NSLocalizedStringFromTable(@"邮箱注册", @"guojihua", nil);
        [_changeRegistButton setTitle:youxiangzhuce forState:UIControlStateNormal];
        [_changeRegistButton addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeRegistButton;
}

-(UIView *)inputContentView{
    if(!_inputContentView){
        _inputContentView = [[UIView alloc] init];
        
    }
    return _inputContentView;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([NSString testCodeNumber:self.codeTextField.text]){
        self.nextStepButton.enabled = YES;
        self.nextStepButton.backgroundColor = NAVIBAR_COLOR;
    }
    else{
        self.nextStepButton.enabled = NO;
        self.nextStepButton.backgroundColor = [UIColor lightGrayColor];
//        if(![NSString valiMobile:self.acountTextField.text]){
//            [self presentAlertWithTitle:@"请输入正确手机号" message:@"" dismissAfterDelay:1.5 completion:nil];
//        }
//        if(![NSString testCodeNumber:self.codeTextField.text]){
//            [self presentAlertWithTitle:@"请输入6位验证码" message:@"" dismissAfterDelay:1.5 completion:nil];
//        }
    }
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
