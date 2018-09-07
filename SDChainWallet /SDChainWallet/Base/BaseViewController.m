//
//  BaseViewController.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/15.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background color of the app
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    // Custom back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Do any additional setup after loading the view.
}

- (void)setTitleViewWithTitle:(NSString *)title {
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)setTitleViewWithBlackTitle:(NSString * _Nonnull)title{
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    label.text = title;
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message dismissAfterDelay:(NSTimeInterval)delay completion:(void(^)(void))completion {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (completion) {
        [self presentViewController:alertController animated:YES completion:^{
            NSDictionary * dict = @{@"alert_controller":alertController,
                                    @"completion":completion};
            [self performSelector:@selector(dismissAlertControllerWithDict:) withObject:dict afterDelay:delay];
        }];
    } else {
        [self presentViewController:alertController animated:YES completion:^{
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:delay];
        }];
    }
    
}

- (void)dismissAlertController:(UIAlertController *)alertController {
    [alertController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissAlertControllerWithDict:(NSDictionary *)dict {
    [dict[@"alert_controller"] dismissViewControllerAnimated:YES completion:^{
        void(^completion)(void) = dict[@"completion"];
        completion();
    }];
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
