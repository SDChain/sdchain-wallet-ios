//
//  RegistViewController.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/25.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

static CGFloat const kRegistHeight = 30;




#import "RegistViewController.h"
#import "Masonry.h"
#import "LoginInputView.h"
#import "ConfirmPassWordViewController.h"
#import "HTTPRequestManager.h"
#import "NSString+validate.h"
#import "ImageCertificationSceneViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *headBackImageView;

@property(nonatomic,strong)UILabel *countryTitleLabel;
@property(nonatomic,strong)UILabel *countrydetailLabel;
@property(nonatomic,strong)UIView *inputContentView;
@property(nonatomic,strong)UILabel *acountTitleLabel;
@property(nonatomic,strong)UITextField *acountTextField;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UILabel *codeTitleLabel;
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
    self.type = RegistTypeMobile;
    [self setupMobileView];
    [self setupMobileLayOut];
    
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGusture];

}

#pragma mark - Action

-(void)hideKeyBoard{
    [self.acountTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}

-(void)popImageCertification{
    if([NSString valiMobile:self.acountTextField.text] || [NSString validateEmail:self.acountTextField.text]){
        ImageCertificationSceneViewController *scene = [[ImageCertificationSceneViewController alloc] initWithNibName:@"ImageCertificationSceneViewController" bundle:nil];
        __weak RegistViewController *weakSelf = self;
        scene.certifiSuccessBlock = ^(NSString *code,NSString *machineId) {
            self.imageCode = code;
            self.machineId = machineId;
            [weakSelf sendCodeAction];
        };
        [self.navigationController pushViewController:scene animated:YES];
    }else{
        if(self.type == RegistTypeMobile){
            NSString *title = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }else if (self.type == RegistTypeEmail){
            NSString *title = NSLocalizedStringFromTable(@"请输入邮箱", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }
    }

}

-(void)sendCodeAction{
    self.nextStepButton.enabled = YES;
    if(self.type == RegistTypeMobile){
        NSString *mobileStr = [NSString stringWithFormat:@"%@",self.acountTextField.text];
        if([NSString valiMobile:mobileStr]){
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
        if(self.type == RegistTypeMobile){
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
    
    if(self.type == RegistTypeMobile){
        self.type = RegistTypeEmail;
    }
    else{
        self.type = RegistTypeMobile;
    }
    [self changeActionWithType:self.type];
}

-(void)changeActionWithType:(RegistType)type{
    [self.inputContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if(type == RegistTypeMobile){
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
    [self.inputContentView addSubview:self.acountTitleLabel];
    [self.inputContentView addSubview:self.acountTextField];
    [self.inputContentView addSubview:self.lineView1];
    [self.inputContentView addSubview:self.codeTitleLabel];
    [self.inputContentView addSubview:self.codeTextField];
    [self.inputContentView addSubview:self.lineView2];
    [self.inputContentView addSubview:self.sendCodeButton];
    [self.inputContentView addSubview:self.nextStepButton];
    [self.inputContentView addSubview:self.changeRegistButton];
    NSString *shoujihao = NSLocalizedStringFromTable(@"手机号", @"guojihua", nil);
    self.acountTitleLabel.text = shoujihao;
    NSString *qingshurushoujihao = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
    self.acountTextField.placeholder = qingshurushoujihao;
    self.acountTextField.text = @"";
    self.codeTextField.text = @"";
    NSString *youxiangzhuce = NSLocalizedStringFromTable(@"邮箱注册", @"guojihua", nil);
    [self.changeRegistButton setTitle:youxiangzhuce forState:UIControlStateNormal];
    
}

-(void)setupEmailView{
    [self.inputContentView addSubview:self.acountTitleLabel];
    [self.inputContentView addSubview:self.acountTextField];
    [self.inputContentView addSubview:self.lineView1];
    [self.inputContentView addSubview:self.codeTitleLabel];
    [self.inputContentView addSubview:self.codeTextField];
    [self.inputContentView addSubview:self.lineView2];
    [self.inputContentView addSubview:self.sendCodeButton];
    [self.inputContentView addSubview:self.nextStepButton];
    [self.inputContentView addSubview:self.changeRegistButton];
    NSString *youxiang = NSLocalizedStringFromTable(@"邮箱", @"guojihua", nil);
    self.acountTitleLabel.text = youxiang;
    NSString *qingshuruyouxiang = NSLocalizedStringFromTable(@"请输入邮箱", @"guojihua", nil);
    self.acountTextField.placeholder = qingshuruyouxiang;
    self.codeTextField.text = @"";
    NSString *shoujizhuce = NSLocalizedStringFromTable(@"手机注册", @"guojihua", nil);
    [self.changeRegistButton setTitle:shoujizhuce forState:UIControlStateNormal];
}


-(void)setupMobileLayOut{
    
    [self.countryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(50);
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
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(30);
    }];
    
    
    
}


-(void)setupEmailLayOut{
    

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
    if(self.type == RegistTypeMobile){
        textLenght = 11;
    }else{
        textLenght = 30;
    }
    if (textField == self.acountTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if(self.type == RegistTypeMobile){
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
        _countrydetailLabel = [[UILabel alloc] init];
        _countrydetailLabel.textColor = [UIColor blackColor];
        _countrydetailLabel.font = [UIFont systemFontOfSize:17];
        NSString *jiazhongguo = NSLocalizedStringFromTable(@"中国", @"guojihua", nil);
        _countrydetailLabel.text = [NSString stringWithFormat:@"+86%@",jiazhongguo];
    }
    return _countrydetailLabel;
}

-(UILabel *)acountTitleLabel{
    if(!_acountTitleLabel){
        _acountTitleLabel = [[UILabel alloc] init];
        _acountTitleLabel.textColor = NAVIBAR_COLOR;
        _acountTitleLabel.font = [UIFont systemFontOfSize:17];
        NSString *shoujihao = NSLocalizedStringFromTable(@"手机号", @"guojihua", nil);
        _acountTitleLabel.text = shoujihao;
    }
    return _acountTitleLabel;
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
    if(([NSString valiMobile:self.acountTextField.text] || [NSString validateEmail:self.acountTextField.text]) && [NSString testCodeNumber:self.codeTextField.text]){
        self.nextStepButton.enabled = YES;
        self.nextStepButton.backgroundColor = NAVIBAR_COLOR;
    }
    else{
        self.nextStepButton.enabled = NO;
        self.nextStepButton.backgroundColor = [UIColor lightGrayColor];
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
