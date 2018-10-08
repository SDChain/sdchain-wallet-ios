//
//  AboutUsScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/22.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "AboutUsScene.h"
#import "AboutUsCell.h"

@interface AboutUsScene ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutUsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0){
        cell.titleLabel.text = @"六域官网";
        cell.detailLabel.text = @"https://sdchain,io/";
    }
    else if (indexPath.row == 1){
        cell.titleLabel.text = @"联系邮箱";
        cell.detailLabel.text = @"service@sdchain.io";
    }
    else if (indexPath.row == 2){
        cell.titleLabel.text = @"电报-频道";
        cell.detailLabel.text = @"https://t.me/sdchaincn";
    }
    else if (indexPath.row == 3){
        cell.titleLabel.text = @"电报-中文交流群";
        cell.detailLabel.text = @"";
    }
    else if (indexPath.row == 4){
        cell.titleLabel.text = @"Beechat中文";
        cell.detailLabel.text = @"";
    }
    else if (indexPath.row == 5){
        cell.titleLabel.text = @"脸书社区（中）";
        cell.detailLabel.text = @"";
    }
    else if (indexPath.row == 6){
        cell.titleLabel.text = @"推特";
        cell.detailLabel.text = @"";
    }
    else if (indexPath.row == 7){
        cell.titleLabel.text = @"官方社区论坛";
        cell.detailLabel.text = @"";
    }
    else if (indexPath.row == 8){
        cell.titleLabel.text = @"官方微博";
        cell.detailLabel.text = @"";
    }
    else if (indexPath.row == 9){
        cell.titleLabel.text = @"官方客服微信号";
        cell.detailLabel.text = @"";
    }
    else if (indexPath.row == 10){
        cell.titleLabel.text = @"官方QQ号";
        cell.detailLabel.text = @"";
    }
    else if (indexPath.row == 11){
        cell.titleLabel.text = @"QQ群";
        cell.detailLabel.text = @"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){

    }
    else if (indexPath.row == 1){

    }
    else if (indexPath.row == 2){

    }
    else if (indexPath.row == 3){

    }
    else if (indexPath.row == 4){

    }
    else if (indexPath.row == 5){

    }
    else if (indexPath.row == 6){

    }
    else if (indexPath.row == 7){

    }
    else if (indexPath.row == 8){

    }
    else if (indexPath.row == 9){

    }
    else if (indexPath.row == 10){

    }
    else if (indexPath.row == 11){

    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, WIDTH, 10);
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView  *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = LINE_COLOR;
        [_tableView registerNib:[UINib  nibWithNibName:@"AboutUsCell" bundle:nil] forCellReuseIdentifier:@"AboutUsCell"];
    }
    return _tableView;
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
