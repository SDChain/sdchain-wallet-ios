//
//  ConfirmPassWordViewController.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/27.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ConfirmPassWordViewController.h"
#import "Masonry.h"
#import "HTTPRequestManager.h"
#import "ServiceDelegateScene.h"
#import "NSString+validate.h"
#import "BackupsScene.h"

@interface ConfirmPassWordViewController ()

@property(nonatomic,strong)UIImageView *headBackImageView;

@property(nonatomic,strong)UILabel *passWordLabel;
@property(nonatomic,strong)UILabel *passWordConfirmLabel;

@property(nonatomic,strong)UITextField *passWordTextField;
@property(nonatomic,strong)UITextField *passWordConfirmTextField;

@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UIView *lineView2;

@property(nonatomic,strong)UIButton *registButton;

@property(nonatomic,strong)UIButton *readedButton;

@property(nonatomic,strong)UIButton *readContentButton;

@property(nonatomic,assign) BOOL readed;


@end

@implementation ConfirmPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.readed = NO;
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    [self.view addSubview:self.headBackImageView];
    [self.headBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    
    [self.view addSubview:self.passWordLabel];
    [self.passWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.headBackImageView.mas_bottom).offset(50);
        make.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.passWordTextField];
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.passWordLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.lineView1];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.passWordTextField.mas_bottom).offset(4.5);
    }];
    
    [self.view addSubview:self.passWordConfirmLabel];
    [self.passWordConfirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.lineView1.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.passWordConfirmTextField];
    [self.passWordConfirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.passWordConfirmLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.lineView2];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.passWordConfirmTextField.mas_bottom).offset(4.5);
    }];
    
    [self.view addSubview:self.registButton];
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.lineView2.mas_bottom).offset(35);
    }];
     
    [self.view addSubview:self.readedButton];
    [self.readedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-60);
        make.top.equalTo(self.registButton.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
    }];
    
    [self.view addSubview:self.readContentButton];
    [self.readContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(25);
        make.left.equalTo(self.readedButton.mas_right);
        make.centerY.equalTo(self.readedButton.mas_centerY);
    }];

}

#pragma mark - Action

//regist
-(void)registAction{
    if(self.passWordTextField.text.length <6 || self.passWordTextField.text.length >20){
        NSString *qingshurumima = NSLocalizedStringFromTable(@"请输入密码", @"guojihua", nil);
        [self presentAlertWithTitle:qingshurumima message:@"" dismissAfterDelay:1.5 completion:nil];
    }
    else if(self.passWordConfirmTextField.text.length <6 || self.passWordConfirmTextField.text.length >20){
            NSString *qingshuruqianbaomima = NSLocalizedStringFromTable(@"请输入钱包密码", @"guojihua", nil);
        [self presentAlertWithTitle:qingshuruqianbaomima message:@"" dismissAfterDelay:1.5 completion:nil];
    }
    else{
        NSString *phoneStr = @"";
        NSString *emailStr = @"";
        if([NSString valiMobile:self.userName]){
            phoneStr = self.userName;
        }else if ([NSString valiMobile:self.userName]){
            emailStr = self.userName;
        }
        [HTTPRequestManager registWithUserName:self.userName passWord:self.passWordTextField.text smsId:self.smsId walletPassword:self.passWordConfirmTextField.text phone:phoneStr email:emailStr showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            SYSTEM_SET_(self.userName, USER_NAME);
                NSString *zhucechenggong = NSLocalizedStringFromTable(@"注册成功", @"guojihua", nil);
            [self presentAlertWithTitle:zhucechenggong message:@"" dismissAfterDelay:1.5 completion:^{
                SYSTEM_SET_(self.passWordTextField.text, defaultPasword);
                BackupsScene *scene = [[BackupsScene alloc] init];
                scene.account = responseObject[@"account"];
                scene.secret = responseObject[@"secret"];
                scene.userAccountId = responseObject[@"userAccountId"];
                NSArray *viewControllers = self.navigationController.viewControllers;
                [self.navigationController setViewControllers:@[viewControllers[0],scene]];
            }];

        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSString *qingqiushibai = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
            [self presentAlertWithTitle:qingqiushibai message:@"" dismissAfterDelay:1.5 completion:nil];
        }];
    }
}

-(void)readedAction{
    if(self.readed){
        [self.readedButton setImage:[UIImage imageNamed:@"login_unread"] forState:UIControlStateNormal];
        self.registButton.backgroundColor = UNCLICK_COLOR;
        self.registButton.enabled = NO;
        self.readed = NO;
    }else{
        [self.readedButton setImage:[UIImage imageNamed:@"login_readed"] forState:UIControlStateNormal];
        self.registButton.backgroundColor = NAVIBAR_COLOR;
        self.registButton.enabled = YES;
        self.readed = YES;
    }

}

//Six Domain Wallet Agreement
-(void)readContnetAction{
    ServiceDelegateScene *scene = [[ServiceDelegateScene alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if(textField == self.passWordTextField){
        if(self.passWordTextField.text.length >= 16){
            self.passWordTextField.text = [textField.text substringToIndex:16];
            return NO;
        }
        NSCharacterSet*cs1;
        NSCharacterSet*cs2;
        
        cs1 = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        cs2 = [[NSCharacterSet characterSetWithCharactersInString:ENGLISH] invertedSet];
        
        NSString*filtered1 = [[string componentsSeparatedByCharactersInSet:cs1] componentsJoinedByString:@""];
        NSString*filtered2 = [[string componentsSeparatedByCharactersInSet:cs2] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered1] || [string isEqualToString:filtered2];
    }else if (textField == self.passWordConfirmTextField){
        
        if(self.passWordConfirmTextField.text.length >= 6){
            self.passWordConfirmTextField.text = [textField.text substringToIndex:6];
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

-(UILabel *)passWordLabel{
    if(!_passWordLabel){
        _passWordLabel = [[UILabel alloc] init];
        _passWordLabel.font = [UIFont systemFontOfSize:17];
        NSString *mima = NSLocalizedStringFromTable(@"密码", @"guojihua", nil);
        _passWordLabel.text = mima;
        _passWordLabel.textColor = NAVIBAR_COLOR;
    }
    return _passWordLabel;
}

-(UILabel *)passWordConfirmLabel{
    if(!_passWordConfirmLabel){
        _passWordConfirmLabel = [[UILabel alloc] init];
        _passWordConfirmLabel.font = [UIFont systemFontOfSize:17];
        NSString *wangjimima = NSLocalizedStringFromTable(@"钱包密码", @"guojihua", nil);
        _passWordConfirmLabel.text = wangjimima;
        _passWordConfirmLabel.textColor = NAVIBAR_COLOR;
    }
    return _passWordConfirmLabel;
}

-(UITextField *)passWordTextField{
    if(!_passWordTextField){
        _passWordTextField = [[UITextField alloc] init];
        _passWordTextField.keyboardType = UIKeyboardTypePhonePad;
        NSString *qingshurumima = NSLocalizedStringFromTable(@"请输入密码", @"guojihua", nil);
        _passWordTextField.placeholder = qingshurumima;
        _passWordTextField.secureTextEntry = YES;
    }
    return _passWordTextField;
}

-(UITextField *)passWordConfirmTextField{
    if(!_passWordConfirmTextField){
        _passWordConfirmTextField = [[UITextField alloc] init];
        _passWordConfirmTextField.keyboardType = UIKeyboardTypePhonePad;
        NSString *qingshuruqianbaomima = NSLocalizedStringFromTable(@"请输入钱包密码", @"guojihua", nil);
        _passWordConfirmTextField.placeholder = qingshuruqianbaomima;
        _passWordConfirmTextField.secureTextEntry = YES;
    }
    return _passWordConfirmTextField;
}

-(UIView *)lineView1{
    if(!_lineView1){
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = NAVIBAR_COLOR;
    }
    return _lineView1;
}

-(UIView *)lineView2{
    if(!_lineView2){
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = NAVIBAR_COLOR;
    }
    return _lineView2;
}

-(UIButton *)registButton{
    if(!_registButton){
        _registButton = [[UIButton alloc] init];
        NSString *zhuce = NSLocalizedStringFromTable(@"注册", @"guojihua", nil);
        [_registButton setTitle:zhuce forState:UIControlStateNormal];
        [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _registButton.backgroundColor = UNCLICK_COLOR;
        _registButton.enabled = NO;
        _registButton.layer.masksToBounds = YES;
        _registButton.layer.cornerRadius = 15;
        [_registButton addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registButton;
}

-(UIButton *)readedButton{
    if(!_readedButton){
        _readedButton = [[UIButton alloc] init];
        [_readedButton setImage:[UIImage imageNamed:@"login_unread"] forState:UIControlStateNormal];
        NSString *woyiyuedubingtongyi = NSLocalizedStringFromTable(@"我已阅读并同意", @"guojihua", nil);
        [_readedButton setTitle:woyiyuedubingtongyi forState:UIControlStateNormal];
        [_readedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _readedButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _readedButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 100);
        _readedButton.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        [_readedButton addTarget:self action:@selector(readedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readedButton;
}

-(UIButton *)readContentButton{
    if(!_readContentButton){
        _readContentButton = [[UIButton alloc] init];
            NSString *liuyuqianbaoyonghuxieyi = NSLocalizedStringFromTable(@"六域钱包用户协议", @"guojihua", nil);
        [_readContentButton setTitle:[NSString stringWithFormat:@"《%@》",liuyuqianbaoyonghuxieyi] forState:UIControlStateNormal];
        [_readContentButton setTitle:liuyuqianbaoyonghuxieyi forState:UIControlStateHighlighted];
        [_readContentButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        [_readContentButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateHighlighted];
        _readContentButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_readContentButton addTarget:self action:@selector(readContnetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readContentButton;
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
