//
//  WalletAdditionSelectScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/6/8.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "WalletAdditionSelectScene.h"
#import "PopSecretViewManager.h"
#import "EstablishWalletScene.h"
#import "LeadInScene.h"

@interface WalletAdditionSelectScene ()
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *leadInButton;

@end

@implementation WalletAdditionSelectScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"添加钱包", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.view.backgroundColor = BACKGROUNDCOLOR;
    self.createButton.backgroundColor = NAVIBAR_COLOR;
    self.createButton.layer.masksToBounds = YES;
    self.createButton.layer.cornerRadius = 15;
    self.leadInButton.backgroundColor = NAVIBAR_COLOR;
    self.leadInButton.layer.masksToBounds = YES;
    self.leadInButton.layer.cornerRadius = 15;
    
    
    NSString *title1 = NSLocalizedStringFromTable(@"创建钱包", @"guojihua", nil);
    NSString *title2 = NSLocalizedStringFromTable(@"导入钱包", @"guojihua", nil);
    [self.createButton setTitle:title1 forState:UIControlStateNormal];
    [self.leadInButton setTitle:title2 forState:UIControlStateNormal];
}

- (IBAction)createbuttonAction:(id)sender {
            PopSecretViewManager *manager = [PopSecretViewManager shareInstance];
            __weak WalletAdditionSelectScene *weakSelf = self;
            manager.WalletSecretCurrectBlock = ^(NSString *account, NSString *secret, NSString *userAccountId) {
                if(self.createWalletBlock){
                    self.createWalletBlock(account);
                }
                EstablishWalletScene *scene = [[EstablishWalletScene alloc] initWithNibName:@"EstablishWalletScene" bundle:nil];
                scene.account = account;
                scene.secret = secret;
                scene.userAccountId = userAccountId;
                [weakSelf.navigationController pushViewController:scene animated:YES];
            };
            manager.WalletSecretErrorBlock = ^(NSString *content) {
                [weakSelf presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            };
            [manager presentSecretScene];
}

- (IBAction)leadinButtonAction:(id)sender {
    PopSecretViewManager *manager = [PopSecretViewManager shareInstance];
//    __weak WalletAdditionSelectScene *weakSelf = self;
    manager.WalletSecretinputBlock = ^(NSString *secret) {
        LeadInScene *scene = [[LeadInScene alloc] initWithNibName:@"LeadInScene" bundle:nil];
        scene.password = secret;
        __weak WalletAdditionSelectScene *weakSelf = self;
        scene.leadingSuccessBlock = ^(WalletModel *model) {
            if(weakSelf.leadinWalletBlock){
                weakSelf.leadinWalletBlock(model);
            }
        };
        [weakSelf.navigationController pushViewController:scene animated:YES];
    };
    [manager presentInputSecretScene];
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
