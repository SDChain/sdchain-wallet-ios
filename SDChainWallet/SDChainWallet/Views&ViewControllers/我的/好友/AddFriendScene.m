//
//  AddFriendScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/15.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "AddFriendScene.h"
#import "ScanScene.h"
#import "LBXScanViewStyle.h"
#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewController.h"
#import "HTTPRequestManager.h"
#import "FriendDetailScene.h"

@interface AddFriendScene ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation AddFriendScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
        NSString *title = NSLocalizedStringFromTable(@"请输入手机号或邮箱", @"guojihua", nil);
    self.searchBar.placeholder = title;
    // Do any additional setup after loading the view from its nib.
}

-(void)setupNavi{
    NSString *title = NSLocalizedStringFromTable(@"添加好友", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"friend_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(InnerStyle)];
    
    
//    UIButton *rightButton = [[UIButton alloc] init];
//    [rightButton addTarget:self action:@selector(InnerStyle) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton setImage:[UIImage imageNamed:@"friend_scan"] forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - action
#pragma mark -无边框，内嵌4个角
- (void)InnerStyle
{
    [self openScanVCWithStyle:[StyleDIY InnerStyle]];
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    ScanScene *scene = [ScanScene new];
    scene.type = typeAddfriendType;
    __weak AddFriendScene *weakSelf = self;
    scene.scanSceneFriendBlock = ^(NSString *userId) {
        [weakSelf.navigationController popViewControllerAnimated:NO];
        FriendDetailScene *scene = [[FriendDetailScene alloc] initWithNibName:@"FriendDetailScene" bundle:nil];
        scene.friendUserId = userId;
        [weakSelf.navigationController pushViewController:scene animated:NO];
    };
    scene.style = style;
    scene.isOpenInterestRect = YES;
    scene.libraryType = [Global sharedManager].libraryType;
    scene.scanCodeType = [Global sharedManager].scanCodeType;
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
}

#pragma mark - UISearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *str = searchBar.text;
    NSLog(@"%@",str);
    

    [HTTPRequestManager searchUserWithUserName:str showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        FriendDetailScene *scene = [[FriendDetailScene alloc] initWithNibName:@"FriendDetailScene" bundle:nil];
        scene.friendUserId = responseObject[@"id"];
        [self.navigationController pushViewController:scene animated:YES];
    } reLogin:^{

    } warn:^(NSString *content) {

    } error:^(NSString *content) {

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
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
