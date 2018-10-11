//
//  LoginScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/9/6.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "LoginScene.h"
#import "Masonry.h"
#import "RegistViewController.h"
#import "TabBarController.h"
#import "AppDelegate.h"
#import "ForgetSecretScene.h"
#import "HTTPRequestManager.h"
#import "NSString+validate.h"
#import "ServiceDelegateScene.h"
#import "ChooseAreaView.h"

@interface LoginScene ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *headBackImageView;
@property(nonatomic,strong)UIView *inputContentView;
@property(nonatomic,strong)UILabel *countryTitleLabel;
@property(nonatomic,strong)UILabel *countryDetailLabel;
@property(nonatomic,strong)UILabel *accssonyLabel;
@property(nonatomic,strong)UIButton *chooseAreaButton;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UITextField *passwordTextField;
@property(nonatomic,strong)UIView *lineView3;
@property(nonatomic,strong)UIButton *eyeButton;

@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIButton *changeRegistButton;

@property(nonatomic,strong)NSString *loginType;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@end

@implementation LoginScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    if(SYSTEM_GET_(LOGINTYPE)){
        self.loginType = SYSTEM_GET_(LOGINTYPE);
    }
    else{
        self.loginType = @"1";
        SYSTEM_SET_(@"1", LOGINTYPE);
    }
    [self setupNavi];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(SYSTEM_GET_(LOGINTYPE)){
        self.loginType = SYSTEM_GET_(LOGINTYPE);
    }
    else{
        self.loginType = @"1";
        SYSTEM_SET_(@"1", LOGINTYPE);
    }
    if(SYSTEM_GET_(USER_NAME)){
        [self checkAccount];
    }
    if(SYSTEM_GET_(defaultPasword)){
        self.passwordTextField.text = SYSTEM_GET_(defaultPasword);
        SYSTEM_SET_(nil, defaultPasword);
    }
        [self setupView];
}

-(void)checkAccount{

    if(SYSTEM_GET_(USER_NAME)){
        NSString *loginName = SYSTEM_GET_(USER_NAME);
        if([self.loginType isEqualToString:@"1"] && ![loginName containsString:@"@"]){
            self.accountTextField.text = SYSTEM_GET_(PHONE);
        }else if (![self.loginType isEqualToString:@"1"] && [loginName containsString:@"@"]){
            self.accountTextField.text = SYSTEM_GET_(EMAIL);
        }else{
            self.accountTextField.text = @"";
        }
    }else{
        self.accountTextField.text = @"";
    }

}

-(void)setupNavi{
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

-(void)setupView{
    
    [self.registButton setTitle:NSLocalizedStringFromTable(@"注册", @"guojihua", nil) forState:UIControlStateNormal];
    [self.forgetButton setTitle:NSLocalizedStringFromTable(@"忘记密码", @"guojihua", nil) forState:UIControlStateNormal];
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGusture];
    [self.view addSubview:self.headBackImageView];
    [self.headBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    [self.view addSubview:self.inputContentView];
    
    [self.view addSubview:self.countryTitleLabel];
    [self.view addSubview:self.countryDetailLabel];
    [self.view addSubview:self.accssonyLabel];
    [self.view addSubview:self.chooseAreaButton];
    [self.view addSubview:self.lineView1];
    [self.inputContentView addSubview:self.accountTextField];
    [self.inputContentView addSubview:self.lineView2];
    [self.inputContentView addSubview:self.passwordTextField];
    [self.inputContentView addSubview:self.lineView3];
    [self.inputContentView addSubview:self.eyeButton];
    [self.inputContentView addSubview:self.loginButton];
    [self.inputContentView addSubview:self.changeRegistButton];
    [self refreshLayout];
}

#pragma mark - Action

-(void)hideKeyBoard{
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)receiveNotification:(NSNotification *)noti
{
    self.passwordTextField.text = [noti.userInfo objectForKey:@"password"];
}

-(void)refreshLayout{
    if([self.loginType isEqualToString:@"1"]){
        self.countryTitleLabel.hidden = NO;
        self.countryDetailLabel.hidden = NO;
        self.accssonyLabel.hidden = NO;
        self.chooseAreaButton.hidden = NO;
        self.lineView1.hidden = NO;
        self.accountTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.accountTextField.placeholder = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
        self.inputContentView.frame = CGRectMake(0, WIDTH/2+kHeight(85), WIDTH, self.view.frame.size.height-125-WIDTH/2);
    }else{
        self.countryTitleLabel.hidden = YES;
        self.countryDetailLabel.hidden = YES;
        self.accssonyLabel.hidden = YES;
        self.chooseAreaButton.hidden = YES;
        self.lineView1.hidden = YES;
        self.accountTextField.keyboardType = UIKeyboardTypeDefault;
        self.accountTextField.placeholder = NSLocalizedStringFromTable(@"请输入邮箱", @"guojihua", nil);
        self.inputContentView.frame = CGRectMake(0, WIDTH/2+kHeight(20), WIDTH, self.view.frame.size.height-125-WIDTH/2);
    }
}

-(void)loginButtonAction{
    NSString *loginAccount  = self.accountTextField.text;
    BOOL logtype = [self.loginType isEqualToString:@"1"]? YES:NO;
    BOOL logAccount = [loginAccount containsString:@"@"]? YES:NO;
    if(self.accountTextField.text.length == 0){
    }else if(logtype && logAccount){
        NSString *title = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
        
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if(!logtype && !logAccount){
        NSString *title = NSLocalizedStringFromTable(@"请输入邮箱", @"guojihua", nil);
        
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }
    else if(self.passwordTextField.text.length < 6 || self.passwordTextField.text.length>20){
        NSString *title = NSLocalizedStringFromTable(@"6~16位密码", @"guojihua", nil);
        
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }else{
        [HTTPRequestManager appLoginWithUserName:self.accountTextField.text passWord:self.passwordTextField.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *title = NSLocalizedStringFromTable(@"登录成功", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            [[UserCenter sharedInstance] setupWithData:responseObject];
            UserModel *user = [UserCenter sharedInstance].userModel;
            SYSTEM_SET_(user.userId, USER_ID);
            SYSTEM_SET_(user.userName, USER_NAME);
            SYSTEM_SET_(user.areaCode, USER_AREA);
            SYSTEM_SET_(user.passwordKey, PASSWORDKEY);
            SYSTEM_SET_(user.account, ACCOUNT);
            SYSTEM_SET_(user.walletName, WALLETNAME);
            SYSTEM_SET_(user.userAccountId, USERACCOUNTID);
            SYSTEM_SET_(responseObject[@"type"], TYPE);
            SYSTEM_SET_(user.apptoken, APPTOKEN);
            if(user.email.length > 0){
                SYSTEM_SET_(user.email, EMAIL);
            }
            else if([user.userName containsString:@"@"]){
                SYSTEM_SET_(user.userName, EMAIL);
            }
            SYSTEM_SET_(user.mobile, PHONE);

            
            TabBarController * tabBarController = [[TabBarController alloc] init];
            [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
            
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

//选择国家、地区
-(void)chooseAreaAction{
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    ChooseAreaView *popView = [[ChooseAreaView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    popView.ConfirmBlock = ^{
        NSDictionary *dict = SYSTEM_GET_(CURRENTAREA);
        if([[GlobalMethod getCurrentLanguage] isEqualToString:@"tc"]){
            self.countryDetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"tw"]];
        }else if ([[GlobalMethod getCurrentLanguage] isEqualToString:@"en"]){
            self.countryDetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"en"]];
        }else{
            self.countryDetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"zh"]];
        }
    };
    [popView showAction];
}

//注册
- (IBAction)registButtonAction:(id)sender {
    RegistViewController * scene = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
}

//忘记密码
- (IBAction)forgetPasswordButtonAction:(id)sender {
    ForgetSecretScene *scene = [[ForgetSecretScene alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
}

//密码密文/明文
- (void)passwordSecretAction{
    if(self.passwordTextField.secureTextEntry == YES){
        self.passwordTextField.secureTextEntry = NO;
        [self.eyeButton setImage:[UIImage imageNamed:@"login_open"] forState:UIControlStateNormal];
    }else{
        self.passwordTextField.secureTextEntry = YES;
        [self.eyeButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    }
}

//切换登录方式
-(void)changeLoginTypeAction{
    if([self.loginType isEqualToString:@"1"]){
        self.loginType = @"0";
        SYSTEM_SET_(@"0", LOGINTYPE);
        [self.changeRegistButton setTitle:NSLocalizedStringFromTable(@"切换手机登录", @"guojihua", nil) forState:UIControlStateNormal];
    }else{
        self.loginType = @"1";
        SYSTEM_SET_(@"1", LOGINTYPE);
        [self.changeRegistButton setTitle:NSLocalizedStringFromTable(@"切换邮箱登录", @"guojihua", nil) forState:UIControlStateNormal];
    }
    [self checkAccount];
    self.passwordTextField.text = @"";
    [self refreshLayout];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.accountTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (self.accountTextField.text.length >= 30) {
            self.accountTextField.text = [textField.text substringToIndex:30];
            return NO;
        }
    }else if (textField == self.passwordTextField){
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (self.passwordTextField.text.length >= 16) {
            self.passwordTextField.text = [textField.text substringToIndex:16];
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
        _countryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, WIDTH/2+kHeight(50), 150, 30)];
        _countryTitleLabel.textColor = NAVIBAR_COLOR;
        _countryTitleLabel.font = [UIFont systemFontOfSize:17];
        NSString *guojiadiqu = NSLocalizedStringFromTable(@"国家/地区", @"guojihua", nil);
        _countryTitleLabel.text = guojiadiqu;
    }
    return _countryTitleLabel;
}

-(UILabel *)countryDetailLabel{
    if(!_countryDetailLabel){
        _countryDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, WIDTH/2+kHeight(50), WIDTH-190, 30)];
        _countryDetailLabel.textColor = [UIColor blackColor];
        _countryDetailLabel.font = [UIFont systemFontOfSize:17];
        _countryDetailLabel.textAlignment = NSTextAlignmentRight;
        if(SYSTEM_GET_(CURRENTAREA)){
            NSDictionary *dict = SYSTEM_GET_(CURRENTAREA);
            if([[GlobalMethod getCurrentLanguage] isEqualToString:@"tc"]){
                self.countryDetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"tw"]];
            }else if ([[GlobalMethod getCurrentLanguage] isEqualToString:@"en"]){
                self.countryDetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"en"]];
            }else{
                self.countryDetailLabel.text = [NSString stringWithFormat:@"+%@ %@",dict[@"code"],dict[@"zh"]];
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
            _countryDetailLabel.text = [NSString stringWithFormat:@"+86 %@",jiazhongguo];
        }
    }
    return _countryDetailLabel;
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

-(UITextField *)accountTextField{
    if(!_accountTextField){
        _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, kHeight(25), WIDTH-80, kHeight(40))];
        NSString *qingshurushoujihao = NSLocalizedStringFromTable(@"请输入手机号", @"guojihua", nil);
        _accountTextField.placeholder = qingshurushoujihao;
        _accountTextField.delegate = self;
        _accountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _accountTextField;
}

-(UITextField *)passwordTextField{
    if(!_passwordTextField){
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, kHeight(90), WIDTH-70-kWidth(50), kHeight(40))];
        NSString *qingshurushoujihao = NSLocalizedStringFromTable(@"6~16位密码", @"guojihua", nil);
        _passwordTextField.placeholder = qingshurushoujihao;
        _passwordTextField.delegate = self;
        _passwordTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

-(UIView *)lineView1{
    if(!_lineView1){
        _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(40, WIDTH/2+kHeight(85), WIDTH-80, 1)];
        _lineView1.backgroundColor = NAVIBAR_COLOR;
    }
    return _lineView1;
}

-(UIView *)lineView2{
    if(!_lineView2){
        _lineView2 = [[UIView alloc] initWithFrame:CGRectMake(40, kHeight(65), WIDTH-80, 1)];
        _lineView2.backgroundColor = NAVIBAR_COLOR;
    }
    return _lineView2;
}

-(UIView *)lineView3{
    if(!_lineView3){
        _lineView3 = [[UIView alloc] initWithFrame:CGRectMake(40, kHeight(130), WIDTH-80, 1)];
        _lineView3.backgroundColor = NAVIBAR_COLOR;
    }
    return _lineView3;
}

-(UIButton *)eyeButton{
    if(!_eyeButton){
        _eyeButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-20-kWidth(50), kHeight(85), kWidth(50), kWidth(50))];
        [_eyeButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        [_eyeButton addTarget:self action:@selector(passwordSecretAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeButton;
}

-(UIButton *)loginButton{
    if(!_loginButton){
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(40, kHeight(175), WIDTH-80, kHeight(40))];
        [_loginButton setTitle:NSLocalizedStringFromTable(@"登录", @"guojihua", nil) forState:UIControlStateNormal];
        _loginButton.backgroundColor = NAVIBAR_COLOR;
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = kHeight(15);
        _loginButton.layer.masksToBounds = YES;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIButton *)changeRegistButton{
    if(!_changeRegistButton){
        _changeRegistButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2-60, kHeight(225), 120, kHeight(30))];
        _changeRegistButton.titleLabel.font = [UIFont systemFontOfSize:13];
        NSString *title = [self.loginType isEqualToString:@"1"] ? NSLocalizedStringFromTable(@"切换邮箱登录", @"guojihua", nil):NSLocalizedStringFromTable(@"切换手机登录", @"guojihua", nil);
        [_changeRegistButton setTitle:title forState:UIControlStateNormal];
        [_changeRegistButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        [_changeRegistButton addTarget:self action:@selector(changeLoginTypeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeRegistButton;
}

-(UIView *)inputContentView{
    if(!_inputContentView){
        _inputContentView = [[UIView alloc] initWithFrame:CGRectMake(0, WIDTH/2+kHeight(85), WIDTH, self.view.frame.size.height-125-WIDTH/2)];
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
