//
//  AboutUsScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/22.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "AboutUsScene.h"
#import "AboutUsCell.h"

@interface AboutUsScene ()
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation AboutUsScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"关于我们", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self.view addSubview:self.webView];
    
    NSString *requestStr = [ABOUT_URL stringByAppendingString:@"about.html"];
    NSString *language = [GlobalMethod getCurrentLanguage];
    if([language isEqualToString:@"en"]){
        requestStr = [ABOUT_URL stringByAppendingString:@"about_en.html"];
    }
    else if([language isEqualToString:@"tc"]){
        requestStr = [ABOUT_URL stringByAppendingString:@"about_tc.html"];
    }
    [self loadString:requestStr];

//    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)loadString:(NSString *)str  {
    NSString *urlStr = str;

    NSURL *url = [NSURL URLWithString:urlStr];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [self.webView loadRequest:request];
}

- (UIWebView *)webView   {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
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
