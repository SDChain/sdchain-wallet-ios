//
//  LoginMainViewController.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/20.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "LoginMainViewController.h"
#import "LoginInputView.h"
#import "RegistViewController.h"
#import "TabBarController.h"
#import "AppDelegate.h"
#import "ForgetSecretScene.h"
#import "HTTPRequestManager.h"
#import "NSString+validate.h"


#import "ServiceDelegateScene.h"


@interface LoginMainViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UILabel *accounttitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passsWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *secretButton;

@property (nonatomic,assign) BOOL isPasswordSecret;


@end

@implementation LoginMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)receiveNotification:(NSNotification *)noti
{

    NSLog(@"%@ === %@ === %@", noti.object, noti.userInfo, noti.name);
    self.passsWordTextField.text = [noti.userInfo objectForKey:@"password"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(SYSTEM_GET_(USER_NAME)){
        self.accountTextField.text = SYSTEM_GET_(USER_NAME);
    }
    if(SYSTEM_GET_(defaultPasword)){
        self.passsWordTextField.text = SYSTEM_GET_(defaultPasword);
        SYSTEM_SET_(nil, defaultPasword);
    }
}
-(void)setupNavi{

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

-(void)hideKeyBoard{
    [self.accountTextField resignFirstResponder];
    [self.passsWordTextField resignFirstResponder];
}

-(void)setupView{
    self.isPasswordSecret = YES;
    [self.secretButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    self.passsWordTextField.secureTextEntry = YES;
    
    self.nextStepButton.layer.masksToBounds = YES;
    self.nextStepButton.layer.cornerRadius = 15;
    [self internationalAction];
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGusture];
}

-(void)internationalAction{
    NSString *zhuanghu = NSLocalizedStringFromTable(@"账户", @"guojihua", nil);
    NSString *zhuanghu1 = NSLocalizedStringFromTable(@"手机号/邮箱", @"guojihua", nil);
    NSString *mima = NSLocalizedStringFromTable(@"密码", @"guojihua", nil);
    NSString *mima1 = NSLocalizedStringFromTable(@"6-16位密码", @"guojihua", nil);
    NSString *zhuce = NSLocalizedStringFromTable(@"注册", @"guojihua", nil);
    NSString *wangjimima = NSLocalizedStringFromTable(@"忘记密码", @"guojihua", nil);
    NSString *denglu = NSLocalizedStringFromTable(@"登录", @"guojihua", nil);
    
    self.accounttitleLabel.text = zhuanghu;
    self.accountTextField.placeholder = zhuanghu1;
    self.passwordTitleLabel.text = mima;
    self.passsWordTextField.placeholder = mima1;
    [self.registButton setTitle:zhuce forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitle:wangjimima forState:UIControlStateNormal];
    [self.nextStepButton setTitle:denglu forState:UIControlStateNormal];
}

- (IBAction)secretButtonAction:(id)sender {
    if(self.isPasswordSecret){
        [self.secretButton setImage:[UIImage imageNamed:@"login_open"] forState:UIControlStateNormal];
        self.passsWordTextField.secureTextEntry = NO;
        self.isPasswordSecret = NO;
    }else{
        [self.secretButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        self.passsWordTextField.secureTextEntry = YES;
        self.isPasswordSecret = YES;
    }
}


- (IBAction)loginAction:(id)sender {
    
    if(![NSString valiMobile:self.accountTextField.text] && ![NSString validateEmail:self.accountTextField.text]){
        NSString *title = NSLocalizedStringFromTable(@"请输入正确账号", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if(self.passsWordTextField.text.length < 6 || self.passsWordTextField.text.length>20){
        NSString *title = NSLocalizedStringFromTable(@"6-16位密码", @"guojihua", nil);

        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }else{
        [HTTPRequestManager appLoginWithUserName:self.accountTextField.text passWord:self.passsWordTextField.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *title = NSLocalizedStringFromTable(@"登录成功", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
            [[UserCenter sharedInstance] setupWithData:responseObject];
            UserModel *user = [UserCenter sharedInstance].userModel;
            SYSTEM_SET_(user.userId, USER_ID);
            SYSTEM_SET_(user.userName, USER_NAME);
            SYSTEM_SET_(user.passwordKey, PASSWORDKEY);
            SYSTEM_SET_(user.account, ACCOUNT);
            SYSTEM_SET_(user.walletName, WALLETNAME);
            SYSTEM_SET_(user.userAccountId, USERACCOUNTID);
            SYSTEM_SET_(responseObject[@"type"], TYPE);
            SYSTEM_SET_(user.apptoken, APPTOKEN);
            SYSTEM_SET_(user.mobile, PHONE);
            SYSTEM_SET_(user.email, EMAIL);
            
            TabBarController * tabBarController = [[TabBarController alloc] init];
            [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
            
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString *title = NSLocalizedStringFromTable(@"6-16位密码", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }];
    }
    
}

- (IBAction)registAction:(id)sender {
    RegistViewController * scene = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
    
}
- (IBAction)forgetSecretAction:(id)sender {
    ForgetSecretScene *scene = [[ForgetSecretScene alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.accountTextField) {
        //Here in the if time in order to obtain the delete operation, if there is no secondary if will cause the delete key can not be used when the word limit is reached.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (self.accountTextField.text.length >= 30) {
            self.accountTextField.text = [textField.text substringToIndex:30];
            return NO;
        }
    }else if (textField == self.passsWordTextField){
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (self.passsWordTextField.text.length >= 16) {
            self.passsWordTextField.text = [textField.text substringToIndex:16];
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
