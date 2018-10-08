//
//  BaseNavigationController.m
//  BaseProject6.15
//
//  Created by 钱伟成 on 2017/6/16.
//  Copyright © 2017年 Zeepson. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImage+EasyExtend.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage * image = [UIImage imageWithColor:NAVIBAR_COLOR];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:image];
    
//    // 设置导航栏背景颜色
//    self.navigationBar.barTintColor = RGB(63, 81, 181);
    
    // 设置导航栏文字颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置导航栏标题样式
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.titleTextAttributes = dict;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (IOS11_OR_LATER) {// 如果iOS 11走else的代码，系统自己的文字和箭头会出来
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, -4) forBarMetrics:UIBarMetricsDefault];
        UIImage *backButtonImage = [[UIImage imageNamed:@"return_image"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        [UINavigationBar appearance].backIndicatorImage = backButtonImage;

        [UINavigationBar appearance].backIndicatorTransitionMaskImage =backButtonImage;
    }else

    {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
        UIImage *returnImage = [[UIImage imageNamed:@"return_image"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[returnImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, -10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
    // Do any additional setup after loading the view.
}

- (void)replaceViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSMutableArray * mArray = [NSMutableArray arrayWithArray:self.viewControllers];
    [mArray removeLastObject];
    [mArray addObject:viewController];
    [self setViewControllers:mArray animated:YES];
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
