//
//  FriendDetailScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/2.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "FriendDetailScene.h"
#import "HTTPRequestManager.h"
#import "AppDelegate.h"
#import "MineWalletAddressScene.h"
#import "TransferAccountsScene.h"

@interface FriendDetailScene ()
@property (weak, nonatomic) IBOutlet UIView *headBackview;
@property (weak, nonatomic) IBOutlet UILabel *trueNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconIamgeView;
@property (weak, nonatomic) IBOutlet UILabel *friendshiplabel;

@property(nonatomic,strong)NSString *friendUserName;   //用户名
@property(nonatomic,strong)NSString *friendRealName;   //真实姓名
@property(nonatomic,strong)NSString *friendNickName;   //昵称
@property(nonatomic,strong)NSString *friendAccount;    //默认钱包
@property(nonatomic,strong)NSString *mobile;           //手机
@property(nonatomic,strong)NSString *email;            //邮箱
@property(nonatomic,strong)NSString *isFriend;         //是否好友

@property (weak, nonatomic) IBOutlet UILabel *zhuanzhangLabel;

@property (weak, nonatomic) IBOutlet UILabel *walletAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *realTitleLabel;

@end

@implementation FriendDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self requestInfo];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.headBackview.backgroundColor = NAVIBAR_COLOR;
    self.iconIamgeView.layer.masksToBounds = YES;
    self.iconIamgeView.layer.cornerRadius = WIDTH/75*7;
    NSString *title1 = NSLocalizedStringFromTable(@"钱包地址", @"guojihua", nil);
    NSString *title2 = NSLocalizedStringFromTable(@"真实姓名", @"guojihua", nil);
    NSString *title3 = NSLocalizedStringFromTable(@"转账", @"guojihua", nil);
    self.walletAddressLabel.text = title1;
    self.realTitleLabel.text = title2;
    self.zhuanzhangLabel.text = title3;

}

-(void)requestInfo{
    [HTTPRequestManager getFriendInfoWithAdverseUserId:self.friendUserId showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.friendAccount = responseObject[@"account"];
        self.friendNickName = responseObject[@"nickName"];
        self.isFriend = [responseObject[@"isFriend"] boolValue] ? @"1":@"";
        self.email = responseObject[@"email"];
        self.mobile= responseObject[@"phone"];
        self.friendRealName = responseObject[@"realName"];
        self.friendUserName = responseObject[@"userName"];
        
        self.trueNameLabel.text = self.friendRealName;
        [self refreshFriendShip];
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

-(void)refreshFriendShip{
    if([self.isFriend isEqualToString:@"1"]){
        NSString *title = NSLocalizedStringFromTable(@"删除", @"guojihua", nil);
        self.friendshiplabel.text = title;
    }
    else{
        NSString *title = NSLocalizedStringFromTable(@"添加", @"guojihua", nil);
        self.friendshiplabel.text = title;
    }
}

- (IBAction)deleteFriendAction:(id)sender {
    if([self.isFriend isEqualToString:@"1"]){
        [HTTPRequestManager deleteFriendWithAdverseUserId:self.friendUserId showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.isFriend = @"";
            [self refreshFriendShip];
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
    }else{
        [HTTPRequestManager addFriendWithAdverseUserId:self.friendUserId showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.isFriend = @"1";
            [self refreshFriendShip];
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
    
}
- (IBAction)translateAction:(id)sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tab = (UITabBarController *)app.window.rootViewController;
     TransferAccountsScene*scene = [[TransferAccountsScene alloc] initWithNibName:@"TransferAccountsScene" bundle:nil];
    scene.accountStr = self.friendAccount;
    BaseNavigationController *naviScene = [[BaseNavigationController alloc] initWithRootViewController:scene];
    [naviScene setViewControllers:@[scene]];
    NSArray *arr = tab.viewControllers;
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr];
    arr1[1] = naviScene;
    [tab setViewControllers:arr1];
    naviScene.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                  NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                  NSForegroundColorAttributeName:NAVIBAR_COLOR};
    [naviScene.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [naviScene.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
    NSString *title = NSLocalizedStringFromTable(@"转账", @"guojihua", nil);
    naviScene.tabBarItem.title = title;
    naviScene.tabBarItem.image = [[UIImage imageNamed:@"transferAccounts_barIcon_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    naviScene.tabBarItem.selectedImage = [[UIImage imageNamed:@"transferAccounts_barIcon_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tab.selectedIndex = 1;
    
//    //添加 字典，将label的值通过key值设置传递
//
//    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.friendAccount,@"textOne",nil];
//
//    //创建通知
//
//    NSNotification *notification = [NSNotification notificationWithName:@"xuanze" object:nil userInfo:dict];
//
//
//    //通过通知中心发送通知
//
//    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
- (IBAction)walletAddressAction:(id)sender {
    if(self.friendAccount.length > 0){
    MineWalletAddressScene *scene = [[MineWalletAddressScene alloc] init];
    scene.friendAccount = self.friendAccount;
    scene.userName = self.friendUserName;
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
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
