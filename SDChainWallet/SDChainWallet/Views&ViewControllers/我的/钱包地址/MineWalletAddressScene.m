//
//  MineWalletAddressScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/21.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "MineWalletAddressScene.h"
#import "Masonry.h"
#import "JKDBHelper.h"
#import "HTTPRequestManager.h"
#import "SecretKeyScene.h"

@interface MineWalletAddressScene ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UILabel *accountLabel;
@property(nonatomic,strong)UIImageView *QRCodeImageView;
@property(nonatomic,strong)UILabel *cueLabel;
@property(nonatomic,strong)UIButton *fuzhiAddressButton;
@property(nonatomic,strong)UIButton *baocunButton;
@property(nonatomic,strong)WalletModel *model;
@end

@implementation MineWalletAddressScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupNavi{
    NSString *title = NSLocalizedStringFromTable(@"钱包地址", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    if(self.friendAccount == nil){
        [[JKDBHelper shareInstance] changeDBWithDirectoryName:WALLETSTABLE];
        NSArray *currentList = [WalletModel findByCriteria:[NSString stringWithFormat:@" WHERE account = '%@' ",self.account]];
        self.model = currentList[0];
        NSString *title = NSLocalizedStringFromTable(@"密钥", @"guojihua", nil);
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(secretAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

-(void)setupView{
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.QRCodeImageView];
    [self.view addSubview:self.cueLabel];
    [self.view addSubview:self.fuzhiAddressButton];
    if(self.friendAccount == nil){
    [self.view addSubview:self.baocunButton];
    }
    
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
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.right.mas_equalTo(kWidth(30));
        make.centerY.equalTo(self.iconImageView.mas_centerY).offset(kHeight(15));
    }];
    
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
    

    
    if(self.friendAccount == nil){
        [self.baocunButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kWidth(30));
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(kHeight(40));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.fuzhiAddressButton.mas_bottom).offset(kHeight(20));
        }];
        self.nameTextField.text = self.model.name;
        self.accountLabel.text = self.model.account;
        self.QRCodeImageView.image = [GlobalMethod codeImageWithString:[NSString stringWithFormat:@"account:%@",self.model.account] size:WIDTH/2 centerImage:[UIImage imageNamed:@"personal_publickey"]];
    }
    else{
        self.nameTextField.enabled = NO;
        self.nameTextField.textColor = [UIColor darkGrayColor];
        self.nameTextField.text = self.userName;
        self.accountLabel.text = self.friendAccount;
        self.QRCodeImageView.image = [GlobalMethod codeImageWithString:[NSString stringWithFormat:@"account:%@",self.friendAccount] size:WIDTH/2 centerImage:[UIImage imageNamed:@"personal_publickey"]];
    }

    
}

#pragma mark - action
-(void)secretAction{
    SecretKeyScene *scene = [[SecretKeyScene alloc] init];
    scene.model = self.model;
    [self.navigationController pushViewController:scene animated:YES];
}


-(void)hideKeyBoard{
    [self.nameTextField resignFirstResponder];
}

-(void)fuzhiWalletAddressAction{
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    if(self.friendAccount != nil){
        pasteboard.string = self.friendAccount;
    }else{
        pasteboard.string = self.model.account;
    }
    NSString *title = NSLocalizedStringFromTable(@"已复制到粘贴板", @"guojihua", nil);
    [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
}

-(void)baocunAction{
    [GlobalMethod loadImageFinished:self.QRCodeImageView.image baocunSuccess:^{
        NSString *title = NSLocalizedStringFromTable(@"保存成功", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nameTextField) {
        if (textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
            return YES;
        }
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [HTTPRequestManager fixWalletNameWithUserId:SYSTEM_GET_(USER_ID) accountName:textField.text userAccountId:self.model.userAccountId apptoken:SYSTEM_GET_(APPTOKEN) showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [[JKDBHelper shareInstance] changeDBWithDirectoryName:WALLETSTABLE];
        NSArray *currentList = [WalletModel findByCriteria:[NSString stringWithFormat:@" WHERE account = '%@' ",self.model.account]];
        self.model = currentList[0];
        self.model.name = textField.text;
        [self.model update];
        self.nameTextField.text = self.model.name;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"fixWalletName" object:nil userInfo:nil];
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *title = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = NO;
    if(textField == self.nameTextField){
        [self.nameTextField resignFirstResponder];
    }else{
        flag = YES;
    }
    return flag;
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
        _nameTextField.delegate = self;
        NSString *title = NSLocalizedStringFromTable(@"未编辑", @"guojihua", nil);
        _nameTextField.placeholder = title;
    }
    return _nameTextField;
}

-(UILabel *)accountLabel{
    if(!_accountLabel){
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.numberOfLines = 0;
        _accountLabel.textColor = [UIColor darkGrayColor];
        _accountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _accountLabel;
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
        NSString *title = NSLocalizedStringFromTable(@"扫一扫付款", @"guojihua", nil);
        _cueLabel.text = title;
        _cueLabel.textColor = [UIColor lightGrayColor];
        _cueLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cueLabel;
}

-(UIButton *)fuzhiAddressButton{
    if(!_fuzhiAddressButton){
        _fuzhiAddressButton = [[UIButton alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"复制钱包地址", @"guojihua", nil);
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
