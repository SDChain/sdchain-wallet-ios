//
//  MineCodeImageScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/20.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "MineCodeImageScene.h"
#import "Masonry.h"

@interface MineCodeImageScene ()

@end

@implementation MineCodeImageScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"我的二维码", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    UILabel *label = [[UILabel alloc] init];
    NSString *detail = NSLocalizedStringFromTable(@"我的二维码", @"guojihua", nil);
    label.text = detail;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(kHeight(70));
        make.height.mas_equalTo(25);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [GlobalMethod codeImageWithString:[NSString stringWithFormat:@"userId:%@",SYSTEM_GET_(USER_ID)] size:WIDTH/2 centerImage:[UIImage imageNamed:@"personal_myqrcode"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(kHeight(120));
        make.width.height.mas_equalTo(WIDTH/2);
    }];
    // Do any additional setup after loading the view.
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
