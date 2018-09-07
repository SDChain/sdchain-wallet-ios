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

@interface TabBarController ()<UINavigationControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) BaseNavigationController * assetsNavigationController;              // assets
@property (nonatomic, strong) BaseNavigationController * transferAccountsNavigationController;    // Transfer
@property (nonatomic, strong) BaseNavigationController * personalNavigationController;            // Personal center


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
