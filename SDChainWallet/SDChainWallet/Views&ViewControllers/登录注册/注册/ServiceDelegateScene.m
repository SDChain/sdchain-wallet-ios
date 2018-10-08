//
//  ServiceDelegateScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/8.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ServiceDelegateScene.h"
#import "UIImage+EasyExtend.h"


@interface ServiceDelegateScene ()
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation ServiceDelegateScene

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSString *title = NSLocalizedStringFromTable(@"服务协议", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self.view addSubview:self.webView];
    NSString *requestStr = [ABOUT_URL stringByAppendingString:@"serviceAgreement.html"];
    NSString *language = [GlobalMethod getCurrentLanguage];
    if([language isEqualToString:@"en"]){
        requestStr = [ABOUT_URL stringByAppendingString:@"serviceAgreement_en.html"];
    }
    else if([language isEqualToString:@"tc"]){
        requestStr = [ABOUT_URL stringByAppendingString:@"serviceAgreement_tc.html"];
    }
    [self loadString:requestStr];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage * image = [UIImage imageWithColor:NAVIBAR_COLOR];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    // 设置导航栏文字颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIImage * image = [UIImage imageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    // 设置导航栏文字颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)loadString:(NSString *)str  {
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = str;
//    if (![str hasPrefix:@"http://"]) {
//        urlStr = [NSString stringWithFormat:@"http://m.baidu.com/s?word=%@", str];
//    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
}

- (UIWebView *)webView   {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _webView;
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
