//
//  SecretKeyScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/21.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "SecretKeyScene.h"
#import "Masonry.h"
#import "HTTPRequestManager.h"
#import "PaymentSecretManager.h"

@interface SecretKeyScene ()

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UILabel *accountLabel;
@property(nonatomic,strong)UIImageView *QRCodeImageView;
@property(nonatomic,strong)UILabel *cueLabel;
@property(nonatomic,strong)UIButton *fuzhiAddressButton;
@property(nonatomic,strong)UIButton *baocunButton;
@property(nonatomic,strong)UIButton *inputLockButton;
@property(nonatomic,strong)NSString *walletPassword;
@property(nonatomic,strong)NSString *secretStr;



@end

@implementation SecretKeyScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"密钥", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)unSecretView{
    [self.view addSubview:self.inputLockButton];
    [self.inputLockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(kHeight(45));
        make.width.height.mas_equalTo(WIDTH/2);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

-(void)setupSecretView{
    if(self.inputLockButton){
        [self.inputLockButton removeFromSuperview];
    }
    [self.view addSubview:self.QRCodeImageView];
    [self.view addSubview:self.cueLabel];
    [self.view addSubview:self.fuzhiAddressButton];
    [self.view addSubview:self.baocunButton];
    
    [self.QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(kHeight(45));
        make.width.height.mas_equalTo(WIDTH/2);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.cueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.QRCodeImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(kHeight(20));
    }];
    
    [self.fuzhiAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(30));
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(kHeight(40));
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.cueLabel.mas_bottom).offset(kHeight(50));
    }];
    
    [self.baocunButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(30));
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(kHeight(40));
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.fuzhiAddressButton.mas_bottom).offset(kHeight(20));
    }];

}

-(void)setupView{
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.accountLabel];

    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGusture];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kWidth(30));
        make.width.height.mas_equalTo(kWidth(60));
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(kWidth(10));
        make.right.mas_equalTo(kWidth(30));
        make.centerY.equalTo(self.iconImageView.mas_centerY).offset(kHeight(-10));
        
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(kWidth(10));
        make.right.mas_equalTo(kWidth(30));
        make.centerY.equalTo(self.iconImageView.mas_centerY).offset(kHeight(10));
    }];
    [self unSecretView];
    self.nameTextField.text = self.model.name;
    self.accountLabel.text = SYSTEM_GET_(USER_NAME);

    
}

-(void)popSecretInputView{
    //支付密码
    PaymentSecretManager *manager = [PaymentSecretManager shareInstance];
    __weak SecretKeyScene *weakSelf = self;
    manager.PaymemtSecretCurrectBlock = ^(NSString *passWord) {
        weakSelf.walletPassword = passWord;
        [weakSelf requestWalletSecret];
    };
    [manager presentSecretScene];
}

-(void)requestWalletSecret{
    [HTTPRequestManager getWalletSecretWithUserAccountId:self.model.userAccountId walletPassword:self.walletPassword showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self setupSecretView];
        self.secretStr = responseObject[@"secret"];
            self.QRCodeImageView.image = [GlobalMethod codeImageWithString:[NSString stringWithFormat:@"privatekey:%@",responseObject[@"secret"]] size:WIDTH/2 centerImage:[UIImage imageNamed:@"personal_privicykey"]];
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *title = NSLocalizedStringFromTable(@"请求错误", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

#pragma mark - action

-(void)hideKeyBoard{
    [self.nameTextField resignFirstResponder];
}

-(void)fuzhiWalletAddressAction{
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.secretStr;
    NSString *title = NSLocalizedStringFromTable(@"已复制到粘贴板", @"guojihua", nil);
    [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
}

-(void)baocunAction{
    [GlobalMethod loadImageFinished:self.QRCodeImageView.image baocunSuccess:^{
        NSString *title = NSLocalizedStringFromTable(@"保存成功", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
-(UIImageView *)iconImageView{
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"mine_iconDefaultImage"];
    }
    return _iconImageView;
}

-(UITextField*)nameTextField{
    if(!_nameTextField){
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.font = [UIFont systemFontOfSize:17];
        _nameTextField.enabled = NO;
    }
    return _nameTextField;
}

-(UILabel *)accountLabel{
    if(!_accountLabel){
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.numberOfLines = 0;
        _accountLabel.textColor = [UIColor darkGrayColor];
        _accountLabel.font = [UIFont systemFontOfSize:13];
    }
    return _accountLabel;
}

-(UIButton *)inputLockButton{
    if(!_inputLockButton){
        _inputLockButton = [[UIButton alloc] init];
        _inputLockButton.layer.borderColor = LINE_COLOR.CGColor;
        _inputLockButton.layer.borderWidth = 1.0;
        [_inputLockButton setImage:[UIImage imageNamed:@"private_lock"] forState:UIControlStateNormal];
        [_inputLockButton setImage:[UIImage imageNamed:@"private_lock"] forState:UIControlStateHighlighted];
        [_inputLockButton addTarget:self action:@selector(popSecretInputView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputLockButton;
}

-(UIImageView *)QRCodeImageView{
    if(!_QRCodeImageView){
        _QRCodeImageView = [[UIImageView alloc] init];
    }
    return _QRCodeImageView;
}

-(UILabel *)cueLabel{
    if(!_cueLabel){
        _cueLabel = [[UILabel alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"请妥善保存密钥", @"guojihua", nil);
        _cueLabel.text = title;
        _cueLabel.textColor = [UIColor redColor];
        _cueLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cueLabel;
}

-(UIButton *)fuzhiAddressButton{
    if(!_fuzhiAddressButton){
        _fuzhiAddressButton = [[UIButton alloc] init];
         NSString *title = NSLocalizedStringFromTable(@"复制钱包密钥", @"guojihua", nil);
        [_fuzhiAddressButton setTitle:title forState:UIControlStateNormal];
        [_fuzhiAddressButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _fuzhiAddressButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _fuzhiAddressButton.layer.masksToBounds = YES;
        _fuzhiAddressButton.layer.cornerRadius = kHeight(20);
        _fuzhiAddressButton.layer.borderColor = LINE_COLOR.CGColor;
        _fuzhiAddressButton.layer.borderWidth = 1;
        [_fuzhiAddressButton addTarget:self action:@selector(fuzhiWalletAddressAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fuzhiAddressButton;
}

-(UIButton *)baocunButton{
    if(!_baocunButton){
        _baocunButton = [[UIButton alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"保存到相册", @"guojihua", nil);
        [_baocunButton setTitle:title forState:UIControlStateNormal];
        [_baocunButton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _baocunButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _baocunButton.layer.masksToBounds = YES;
        _baocunButton.layer.cornerRadius = kHeight(20);
        _baocunButton.layer.borderColor = LINE_COLOR.CGColor;
        _baocunButton.layer.borderWidth = 1;
        [_baocunButton addTarget:self action:@selector(baocunAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _baocunButton;
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
