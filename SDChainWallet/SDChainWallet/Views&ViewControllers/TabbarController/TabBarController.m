//
//  TabBarController.m
//  HuiTongTingChe
//
//  Created by 钱伟成 on 2017/8/23.
//  Copyright © 2017年 HuiTong. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "TabBarButton.h"
#import "AssetsScene.h"
#import "TransferAccountsScene.h"
#import "MineScene.h"
#import "BussinessScene.h"
#import "QuotesScene.h"

@interface TabBarController ()<UINavigationControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) BaseNavigationController * assetsNavigationController;              // 资产
@property (nonatomic, strong) BaseNavigationController * transferAccountsNavigationController;    // 转账
@property (nonatomic, strong) BaseNavigationController * businessNavi;                           // 交易
@property (nonatomic, strong) BaseNavigationController * quotesNavi;                              // 行情
@property (nonatomic, strong) BaseNavigationController * personalNavigationController;            // 个人中心


@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBar];
    
    // Do any additional setup after loading the view.
}


#pragma mark - Setup

- (void)setupTabBar {
    
    self.delegate = self;
    
    self.tabBar.translucent = NO;
    
    [self setViewControllers:@[self.assetsNavigationController,
                               self.transferAccountsNavigationController,
//                               self.businessNavi,
                               self.quotesNavi,
                               self.personalNavigationController]];
}



#pragma mark - tabbar delegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

        NSNotification *notification = [NSNotification notificationWithName:@"qingkong" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];


}

#pragma mark - Getter

- (BaseNavigationController *)assetsNavigationController {
    if (!_assetsNavigationController) {
        AssetsScene * scene = [[AssetsScene alloc] initWithNibName:@"AssetsScene" bundle:nil];
        _assetsNavigationController = [[BaseNavigationController alloc] initWithRootViewController:scene];
        _assetsNavigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:NAVIBAR_COLOR};
        [_assetsNavigationController.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        [_assetsNavigationController.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
        NSString *title = NSLocalizedStringFromTable(@"资产", @"guojihua", nil);
        _assetsNavigationController.tabBarItem.title = title;
        _assetsNavigationController.tabBarItem.image = [[UIImage imageNamed:@"assets_barIcon_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _assetsNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"assets_barIcon_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _assetsNavigationController;
}

- (BaseNavigationController *)transferAccountsNavigationController {
    if (!_transferAccountsNavigationController) {
        TransferAccountsScene * scene = [[TransferAccountsScene alloc] initWithNibName:@"TransferAccountsScene" bundle:nil];
        _transferAccountsNavigationController = [[BaseNavigationController alloc] initWithRootViewController:scene];
        
        _transferAccountsNavigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:NAVIBAR_COLOR};
        [_transferAccountsNavigationController.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        [_transferAccountsNavigationController.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
        NSString *title = NSLocalizedStringFromTable(@"转账", @"guojihua", nil);
        _transferAccountsNavigationController.tabBarItem.title = title;
        _transferAccountsNavigationController.tabBarItem.image = [[UIImage imageNamed:@"transferAccounts_barIcon_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _transferAccountsNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"transferAccounts_barIcon_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _transferAccountsNavigationController;
}

- (BaseNavigationController *)businessNavi {
    if (!_businessNavi) {
        BussinessScene * scene = [[BussinessScene alloc] init];
        _businessNavi = [[BaseNavigationController alloc] initWithRootViewController:scene];
        
        _businessNavi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:NAVIBAR_COLOR};
        [_businessNavi.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        [_businessNavi.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
        NSString *title = NSLocalizedStringFromTable(@"交易", @"guojihua", nil);
        _businessNavi.tabBarItem.title = title;
        _businessNavi.tabBarItem.image = [[UIImage imageNamed:@"business_babbar_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _businessNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"business_babbar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _businessNavi;
}

- (BaseNavigationController *)quotesNavi {
    if (!_quotesNavi) {
        QuotesScene * scene = [[QuotesScene alloc] init];
        _quotesNavi = [[BaseNavigationController alloc] initWithRootViewController:scene];
        
        _quotesNavi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:NAVIBAR_COLOR};
        [_quotesNavi.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        [_quotesNavi.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
        NSString *title = NSLocalizedStringFromTable(@"行情_tab", @"guojihua", nil);
        _quotesNavi.tabBarItem.title = title;
        _quotesNavi.tabBarItem.image = [[UIImage imageNamed:@"tab_quotes"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _quotesNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_quotes_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _quotesNavi;
}

- (BaseNavigationController *)personalNavigationController {
    if (!_personalNavigationController) {
        MineScene * scene = [[MineScene alloc] init];
        _personalNavigationController = [[BaseNavigationController alloc] initWithRootViewController:scene];
        _personalNavigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:NAVIBAR_COLOR};
        [_personalNavigationController.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        [_personalNavigationController.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
        NSString *title = NSLocalizedStringFromTable(@"个人中心", @"guojihua", nil);
        _personalNavigationController.tabBarItem.title = title;
        _personalNavigationController.tabBarItem.image = [[UIImage imageNamed:@"personal_barIcon_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _personalNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"personal_barIcon_delected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _personalNavigationController;
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
