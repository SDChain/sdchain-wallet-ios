//
//  LeadInScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/6/8.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "LeadInScene.h"
#import "HTTPRequestManager.h"
#import "ScanScene.h"
#import "LBXScanViewStyle.h"
#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewController.h"

@interface LeadInScene ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *publicSecretTextField;
@property (weak, nonatomic) IBOutlet UITextField *privicySecretTextField;
@property (weak, nonatomic) IBOutlet UIButton *leadInButton;


@end

@implementation LeadInScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    NSString *title = NSLocalizedStringFromTable(@"导入钱包", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.view.backgroundColor = BACKGROUNDCOLOR;
    self.leadInButton.layer.cornerRadius = 15.0;
    self.leadInButton.layer.masksToBounds = YES;
    NSString *title = NSLocalizedStringFromTable(@"开始导入", @"guojihua", nil);
    [self.leadInButton setTitle:title forState:UIControlStateNormal];
    [self.leadInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leadInButton.backgroundColor = UNCLICK_COLOR;
    self.leadInButton.enabled = NO;
    self.leadInButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.leadInButton addTarget:self action:@selector(startLeadingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *title2 = NSLocalizedStringFromTable(@"请输入公钥", @"guojihua", nil);
    NSString *title3 = NSLocalizedStringFromTable(@"请输入私钥", @"guojihua", nil);
    self.publicSecretTextField.placeholder = title2;
    self.privicySecretTextField.placeholder = title3;
}

-(void)startLeadingButtonAction{

    
    [HTTPRequestManager leadinWalletWithWalletPassword:self.password walletPrivitySecret:self.privicySecretTextField.text walletAccount:self.publicSecretTextField.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        WalletModel *model = [[[WalletModel alloc] init] configureWithUserAccountId:responseObject[@"id"] name:responseObject[@"name"] account:responseObject[@"account"] isDefault:responseObject[@"isDefault"]];
        __weak LeadInScene *weakSelf = self;
        if(self.leadingSuccessBlock){
            self.leadingSuccessBlock(model);
        }
        NSString *title = NSLocalizedStringFromTable(@"导入成功", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
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

- (IBAction)scanAction:(id)sender {
    UIButton *button = (UIButton *)sender;
//    if(button.tag == 1001){
//        
//    }else if (button.tag == 1002){
//        
//    }
    [self scanAction];
}

-(void)scanAction{
    [self InnerStyleForgetAction];
}

- (void)InnerStyleForgetAction{
    [self openScanSceneWithStyle:[StyleDIY qqStyle]];
}

- (void)openScanSceneWithStyle:(LBXScanViewStyle*)style{
    ScanScene *scene = [ScanScene new];
    scene.type = typeLeadingIn;
    __weak LeadInScene *weakSelf = self;
    scene.scanScenePrivateBlock = ^(NSString *private) {
        weakSelf.privicySecretTextField.text = private;
        [weakSelf checkInput];
    };
    scene.scanSceneWalletBlock = ^(NSString *public) {
        weakSelf.publicSecretTextField.text = public;
        [weakSelf checkInput];
    };
    scene.style = style;
    scene.isOpenInterestRect = YES;
    scene.libraryType = [Global sharedManager].libraryType;
    scene.scanCodeType = [Global sharedManager].scanCodeType;
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
}

#pragma mark -  UITextField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkInput];
}

-(void)checkInput{
    if(self.publicSecretTextField.text.length > 0 && self.privicySecretTextField.text.length > 0){
        self.leadInButton.backgroundColor = NAVIBAR_COLOR;
        self.leadInButton.enabled = YES;
    }else{
        self.leadInButton.backgroundColor = UNCLICK_COLOR;
        self.leadInButton.enabled = NO;
    }}

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
