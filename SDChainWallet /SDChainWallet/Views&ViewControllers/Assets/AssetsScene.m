
//
//  AssetsScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/15.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "AssetsScene.h"
#import "PopSideMenuView.h"
#import "EstablishWalletScene.h"
#import "AssetsCell.h"
#import "PaymentSecretManager.h"
#import "YQLightLab.h"
#import "Masonry.h"
#import "ScanScene.h"
#import <LBXScanViewStyle.h>
#import "StyleDIY.h"
#import "Global.h"
#import <LBXScanViewController.h>
#import "HTTPRequestManager.h"
#import "BalanceModel.h"
#import "PopSecretViewManager.h"
#import "FriendDetailScene.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "TransferListScene.h"
#import "MineWalletAddressScene.h"
#import "TransferAccountsScene.h"
#import "MineScene.h"
#import "ChooseFriendScene.h"
#import "WalletAdditionSelectScene.h"

@interface AssetsScene ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *headIconView;
@property (weak, nonatomic) IBOutlet UIImageView *headIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *headIconButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuntLabel;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIButton *activeButton;
@property (strong, nonatomic) YQLightLable *shimLabel;
@property (nonatomic,assign) BOOL isActive;
@property (weak, nonatomic) IBOutlet UIButton *QrCodeButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)WalletModel *currentWallet;

@property (nonatomic,strong)NSArray <BalanceModel *>*balanceArray;

@end

@implementation AssetsScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(fixWalletNameAction) name:@"fixWalletName" object:nil];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    NSString *title = NSLocalizedStringFromTable(@"资产", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"assets_rightBarButton") style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"assets_scanBarButton") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.isActive = NO;
    [self setupView];
    self.currentWallet = [[WalletModel alloc] configureWithUserAccountId:SYSTEM_GET_(USERACCOUNTID) name:SYSTEM_GET_(WALLETNAME) account:SYSTEM_GET_(ACCOUNT) isDefault:@"1"];
    [self requestWalletsListFirst];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.shimLabel.hidden == NO){
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - setup
-(void)setupView{
    
    self.view1.backgroundColor = NAVIBAR_COLOR;
    self.headIconView.layer.masksToBounds = YES;
    self.headIconView.layer.cornerRadius = self.headIconView.frame.size.width/2;
    
    self.headIconImageView.layer.masksToBounds = YES;
    self.headIconImageView.layer.cornerRadius = self.headIconImageView.frame.size.width/2;
    
    self.activeButton.layer.masksToBounds = YES;
    self.activeButton.layer.cornerRadius = 10;
    self.activeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.activeButton.layer.borderWidth = 0.5;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AssetsCell" bundle:nil] forCellReuseIdentifier:@"AssetsCell"];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    self.tableView.tableHeaderView = headView;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    self.tableView.tableFooterView = footView;
    __weak AssetsScene *weakSelf = self;
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf requestBalance];
    }];

    [self.view addSubview:self.shimLabel];
    [self.shimLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - action

//Modify wallet name
-(void)fixWalletNameAction{
    [self requestWalletsListWithAcount:SYSTEM_GET_(ACCOUNT)];
}

//List of assets requested for local storage
-(void)saveBalancesWithDict:(NSDictionary *)dict{
    NSArray *responseArr = dict[@"balances"];
    SYSTEM_SET_(responseArr, BALANCES);
    SYSTEM_SET_(dict[@"reserveBase"], FREEZE);
}

//Refresh the interface data after requesting the wallet list
-(void)refreshDataWithModel:(WalletModel *)model{
    NSLog(@".......%@",model.account);
    self.nameLabel.text = model.name;
    self.accuntLabel.text = model.account;
    self.currentWallet = model;
    SYSTEM_SET_(model.account, ACCOUNT);
    SYSTEM_SET_(model.userAccountId, USERACCOUNTID);
    SYSTEM_SET_(model.name, WALLETNAME);
    [self.tableView.mj_header beginRefreshing];
}

//Acquiring assets
-(void)requestBalance{
    [HTTPRequestManager getBalanceWithAccount:self.currentWallet.account userId:SYSTEM_GET_(USER_ID) appToken:SYSTEM_GET_(APPTOKEN) showProgress:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [self saveBalancesWithDict:responseObject];
        self.isActive = YES;
        self.shimLabel.hidden = YES;
        NSArray *responseArr = responseObject[@"balances"];
        NSMutableArray *arr = [NSMutableArray array];
        [responseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BalanceModel *model = [BalanceModel modelWithDict:obj];
            [arr addObject:model];
        }];
        self.balanceArray = arr;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } reLogin:^(void){
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        NSString *title = NSLocalizedStringFromTable(@"未激活", @"guojihua", nil);
        self.shimLabel.text = title;
        self.shimLabel.hidden = NO;
        self.isActive = NO;
        NSDictionary *dict = @{@"counterparty":@"",
                               @"currency":@"SDA",
                               @"value":@"0"
                               };
        BalanceModel *model = [BalanceModel modelWithDict:dict];
        self.balanceArray = @[model];
        [self.tableView reloadData];
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        [self.tableView.mj_header endRefreshing];
    } error:^(NSString *content) {
        NSString *title = NSLocalizedStringFromTable(@"未激活", @"guojihua", nil);
        self.shimLabel.text = title;
        self.shimLabel.hidden = NO;
        self.isActive = NO;
        NSDictionary *dict = @{@"counterparty":@"",
                               @"currency":@"SDA",
                               @"value":@"0"
                               };
        BalanceModel *model = [BalanceModel modelWithDict:dict];
        self.balanceArray = @[model];
        [self.tableView reloadData];
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *title = NSLocalizedStringFromTable(@"未激活", @"guojihua", nil);
        self.shimLabel.text = title;
        self.shimLabel.hidden = YES;
        self.isActive = NO;
        NSDictionary *dict = @{@"counterparty":@"",
                               @"currency":@"SDA",
                               @"value":@"0"
                               };
        BalanceModel *model = [BalanceModel modelWithDict:dict];
        self.balanceArray = @[model];
        [self.tableView reloadData];
        NSString *qingqiushibai = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
        [self presentAlertWithTitle:qingqiushibai message:@"" dismissAfterDelay:1.5 completion:nil];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

//Recycling assets
-(void)requestBalanceCricle{
            NSString *title = NSLocalizedStringFromTable(@"激活中", @"guojihua", nil);
    self.shimLabel.text = title;
    [HTTPRequestManager getBalanceWithAccount:self.currentWallet.account userId:SYSTEM_GET_(USER_ID) appToken:SYSTEM_GET_(APPTOKEN) showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.isActive = YES;
        self.shimLabel.hidden = YES;
        NSArray *responseArr = responseObject[@"balances"];
        NSMutableArray *arr = [NSMutableArray array];
        [responseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BalanceModel *model = [BalanceModel modelWithDict:obj];
            [arr addObject:model];
        }];
        self.balanceArray = arr;
        [self.tableView reloadData];
    } reLogin:^(void){
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self requestBalanceCricle];
        NSString *title = NSLocalizedStringFromTable(@"激活中", @"guojihua", nil);
        self.shimLabel.text = title;
        self.shimLabel.hidden = NO;
        self.isActive = NO;
        NSDictionary *dict = @{@"counterparty":@"",
                               @"currency":@"SDA",
                               @"value":@"0"
                               };
        BalanceModel *model = [BalanceModel modelWithDict:dict];
        self.balanceArray = @[model];
        [self.tableView reloadData];
    } error:^(NSString *content) {
        NSString *title = NSLocalizedStringFromTable(@"未激活", @"guojihua", nil);
        self.shimLabel.text = title;
        self.shimLabel.hidden = NO;
        self.isActive = NO;
        NSDictionary *dict = @{@"counterparty":@"",
                               @"currency":@"SDA",
                               @"value":@"0"
                               };
        BalanceModel *model = [BalanceModel modelWithDict:dict];
        self.balanceArray = @[model];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *title = NSLocalizedStringFromTable(@"未激活", @"guojihua", nil);
        self.shimLabel.text = title;
        self.shimLabel.hidden = YES;
        self.isActive = NO;
        NSDictionary *dict = @{@"counterparty":@"",
                               @"currency":@"SDA",
                               @"value":@"0"
                               };
        BalanceModel *model = [BalanceModel modelWithDict:dict];
        self.balanceArray = @[model];
        [self.tableView reloadData];
        NSString *qingqiushibai = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
        [self presentAlertWithTitle:qingqiushibai message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
    
}

//First request wallet list
-(void)requestWalletsListFirst{
    [HTTPRequestManager paymentwalletListWithUserId:SYSTEM_GET_(USER_ID) showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *wallets = responseObject[@"walletList"];
        [[JKDBHelper shareInstance] changeDBWithDirectoryName:WALLETSTABLE];
        [WalletModel clearTable];
        for (int i = 0; i < wallets.count; i++) {
            NSDictionary *dict = wallets[i];
            WalletModel *model = [[[WalletModel alloc] init] configureWithUserAccountId:dict[@"userAccountId"] name:dict[@"name"] account:dict[@"account"] isDefault:dict[@"isdefault"]];
            [model save];
        }
        NSArray *currentList = [WalletModel findByCriteria:[NSString stringWithFormat:@" WHERE isDefault = '%@' ",@"1"]];
        WalletModel *defaultModel = currentList[0];
        [self refreshDataWithModel:defaultModel];
        
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.shimLabel.hidden = YES;
        NSString *qingqiushibai = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
        [self presentAlertWithTitle:qingqiushibai message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

//Request wallet list
-(void)requestWalletsListWithAcount:(NSString *)account{
    [HTTPRequestManager paymentwalletListWithUserId:SYSTEM_GET_(USER_ID) showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *wallets = responseObject[@"walletList"];
        [[JKDBHelper shareInstance] changeDBWithDirectoryName:WALLETSTABLE];
        [WalletModel clearTable];
        for (int i = 0; i < wallets.count; i++) {
            NSDictionary *dict = wallets[i];
            WalletModel *model = [[[WalletModel alloc] init] configureWithUserAccountId:dict[@"userAccountId"] name:dict[@"name"] account:dict[@"account"] isDefault:dict[@"isdefault"]];
            if(account && [model.account isEqualToString:account]){
                self.currentWallet = model;
                [self refreshDataWithModel:model];
            }
            [model save];
        }
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.shimLabel.hidden = YES;
        NSString *qingqiushibai = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
        [self presentAlertWithTitle:qingqiushibai message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

//Navigation bar left, sweep
-(void)leftBarAction{
    [self InnerStyle];
}

//Activation button
- (void)activeLabelAction {
    if(self.isActive){
    }else{
        [HTTPRequestManager walletActiveActionWithUserAccountId:self.currentWallet.userAccountId showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            [self performSelector:@selector(requestBalance) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
            NSString *yijihuo = NSLocalizedStringFromTable(@"已激活", @"guojihua", nil);
            [self presentAlertWithTitle:yijihuo message:@"" dismissAfterDelay:1.5 completion:nil];
            self.isActive = YES;
            [self requestBalanceCricle];
        } reLogin:^{
            [GlobalMethod loginOutAction];
        } warn:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            self.isActive = NO;
            [self requestBalance];
        } error:^(NSString *content) {
            [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
            self.isActive = NO;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString *qingqiushibai = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
            [self presentAlertWithTitle:qingqiushibai message:@"" dismissAfterDelay:1.5 completion:nil];
            self.isActive = NO;
        }];
    }
}

//Click on QR code, wallet address
- (IBAction)codeButtonAction:(id)sender {
    MineWalletAddressScene *scene = [[MineWalletAddressScene alloc] init];
    scene.account = self.currentWallet.account;
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
}

- (void)InnerStyle
{
    [self openScanVCWithStyle:[StyleDIY qqStyle]];
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    ScanScene *scene = [ScanScene new];
    scene.type = typeAssetType;
    __weak AssetsScene *weakSelf = self;
    scene.scanSceneFriendBlock = ^(NSString *userId) {
//        FriendDetailScene *scene = [[FriendDetailScene alloc] initWithNibName:@"FriendDetailScene" bundle:nil];
//        scene.friendUserId = userId;
//        [weakSelf.navigationController popViewControllerAnimated:NO];
//        scene.hidesBottomBarWhenPushed = YES;
//
//        [weakSelf.navigationController pushViewController:scene animated:NO];
        [weakSelf.navigationController popViewControllerAnimated:NO];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tab = (UITabBarController *)app.window.rootViewController;
        MineScene *scene1 = [[MineScene alloc] init];
        ChooseFriendScene *scene2 = [[ChooseFriendScene alloc] initWithNibName:@"ChooseFriendScene" bundle:nil];
        scene2.hidesBottomBarWhenPushed = YES;
        FriendDetailScene *scene3 = [[FriendDetailScene alloc] initWithNibName:@"FriendDetailScene" bundle:nil];
        scene3.friendUserId = userId;
        scene3.hidesBottomBarWhenPushed = YES;
        BaseNavigationController *naviScene = [[BaseNavigationController alloc] initWithRootViewController:scene1];
        [naviScene setViewControllers:@[scene1,scene2,scene3]];
        NSArray *arr = tab.viewControllers;
        NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr];
        arr1[2] = naviScene;
        [tab setViewControllers:arr1];
        naviScene.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:NAVIBAR_COLOR};
        [naviScene.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        [naviScene.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
        NSString *title = NSLocalizedStringFromTable(@"个人中心", @"guojihua", nil);
        naviScene.tabBarItem.title = title;
        naviScene.tabBarItem.image = [[UIImage imageNamed:@"personal_barIcon_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        naviScene.tabBarItem.selectedImage = [[UIImage imageNamed:@"personal_barIcon_delected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tab.selectedIndex = 2;
    };
    scene.scanSceneWalletBlock = ^(NSString *account) {
        [weakSelf.navigationController popViewControllerAnimated:NO];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tab = (UITabBarController *)app.window.rootViewController;
        TransferAccountsScene*scene = [[TransferAccountsScene alloc] initWithNibName:@"TransferAccountsScene" bundle:nil];
        scene.accountStr = account;
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
    };
    scene.style = style;
    scene.isOpenInterestRect = YES;
    scene.libraryType = [Global sharedManager].libraryType;
    scene.scanCodeType = [Global sharedManager].scanCodeType;
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
}

-(void)rightBarAction{
    
    [[JKDBHelper shareInstance]changeDBWithDirectoryName:WALLETSTABLE];
    NSArray *wallets = [WalletModel findAll];
    __weak AssetsScene *weakSelf = self;
    PopSideMenuView  *view = [[PopSideMenuView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    view.wallets = wallets;
    view.block = ^(NSString *text) {            //Create a wallet
        WalletAdditionSelectScene *scene = [[WalletAdditionSelectScene alloc] initWithNibName:@"WalletAdditionSelectScene" bundle:nil];
        scene.hidesBottomBarWhenPushed = YES;
        scene.createWalletBlock = ^(NSString *account){
            [weakSelf requestWalletsListWithAcount:account];
        };
        scene.leadinWalletBlock = ^(WalletModel *model) {
            [self refreshDataWithModel:model];
            [weakSelf requestWalletsListWithAcount:model.account];
        };
        [self.navigationController pushViewController:scene animated:YES];
    };
    
    view.loginoutBlock = ^{
        [GlobalMethod loginOutAction];
    };
    view.selectedBlock = ^(WalletModel *model) {
        [weakSelf refreshDataWithModel:model];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:view];

}

#pragma mark - UITableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.balanceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetsCell" forIndexPath:indexPath];
    [cell setupCellWithModel:self.balanceArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferListScene *scene = [[TransferListScene alloc] initWithNibName:@"TransferListScene" bundle:nil];
    BalanceModel *model = self.balanceArray[indexPath.row];
    scene.currency = model.currency;
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
}

#pragma - getter
-(YQLightLable *)shimLabel{
    if(!_shimLabel){
        _shimLabel = [[YQLightLable alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x+self.nameLabel.frame.size.width+kWidth(25), self.nameLabel.frame.origin.y-kHeight(15), kWidth(60), kHeight(20))];
        NSString *title = NSLocalizedStringFromTable(@"未激活", @"guojihua", nil);
        _shimLabel.text = title;
        _shimLabel.textAlignment = NSTextAlignmentCenter;
        _shimLabel.textColor = [UIColor orangeColor];
        _shimLabel.font = [UIFont systemFontOfSize:12];
        _shimLabel.direction = YQLightLableDirectionToLeft;
        _shimLabel.hidden = YES;
        _shimLabel.layer.cornerRadius = 10;
        _shimLabel.layer.masksToBounds = YES;
        _shimLabel.layer.borderWidth = 0.7;
        _shimLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activeLabelAction)];
        [_shimLabel addGestureRecognizer:gusture];
    }
    return _shimLabel;
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
