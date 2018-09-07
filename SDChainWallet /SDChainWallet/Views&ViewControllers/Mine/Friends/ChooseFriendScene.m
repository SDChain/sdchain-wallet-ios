//
//  ChooseFriendScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/12.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ChooseFriendScene.h"
#import "FriendListCell.h"
#import "AddFriendScene.h"

#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import "HTTPRequestManager.h"

#import "FriendDetailScene.h"
#import "FriendSearchResultScene.h"

@interface ChooseFriendScene ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *dataSource;/**<The entire data source before sorting*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<Sorted entire data source*/
@property (strong, nonatomic) NSMutableArray *indexDataSource;/**<Index data source*/

@end

@implementation ChooseFriendScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestFriendList];
}

-(void)setupNavi{
    if(self.type == ListTypeCheck){
        NSString *title = NSLocalizedStringFromTable(@"好友", @"guojihua", nil);
        [self setTitleViewWithTitle:title];
    }
    if(self.type == ListTypeSelect){
                NSString *title = NSLocalizedStringFromTable(@"选择好友", @"guojihua", nil);
        [self setTitleViewWithTitle:title];
    }
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"friend_add"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)requestFriendList{
    [HTTPRequestManager getFriendsListWithUserId:SYSTEM_GET_(USER_ID) showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *dataSourceArr = responseObject[@"users"];
        self.dataSource = [NSMutableArray array];
        [dataSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ContactModel *model = [ContactModel modelWithDict:obj];
            [self.dataSource addObject:model];
        }];
        [self dealWithArrwithdataArr:[NSArray arrayWithArray:self.dataSource]];
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        NSString *title = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

-(void)addFriend{
    
    AddFriendScene  *scene = [[AddFriendScene alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
}

-(void)setupView{
    NSString *title = NSLocalizedStringFromTable(@"搜索好友", @"guojihua", nil);
    self.searchBar.placeholder = title;
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCell"];
    
}

-(void)dealWithArrwithdataArr:(NSArray *)arr{
    self.allDataSource = [HCSortString sortAndGroupForArray:arr PropertyName:@"contactName"];
    self.indexDataSource = [HCSortString sortForStringAry:[self.allDataSource allKeys]];
    NSLog(@"%@"    @"%@",self.allDataSource,self.indexDataSource);
    [self.tableView reloadData];
}

#pragma mark - UITabelView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.allDataSource objectForKey:self.indexDataSource[section]] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *value = [self.allDataSource objectForKey:self.indexDataSource[indexPath.section]];
    ContactModel *model = value[indexPath.row];
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell" forIndexPath:indexPath];
    if(model.nickName){
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.userName];
    }
    else{
    cell.titleLabel.text = [NSString stringWithFormat:@"%@  (%@)",model.nickName,model.userName];
    }
    return cell;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.indexDataSource[section];
}

- (CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat ) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//Right index list
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    return self.indexDataSource;
}

//Index click event
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *value = [self.allDataSource objectForKey:self.indexDataSource[indexPath.section]];
    ContactModel *model = value[indexPath.row];
    if(self.type == ListTypeCheck){
        FriendDetailScene *scene = [[FriendDetailScene alloc] init];
        scene.friendUserId = model.userId;
        [self.navigationController pushViewController:scene animated:YES];
    }else if (self.type == ListTypeSelect){
        if(self.tapBlock){
            self.tapBlock(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UISearchBar Delegate

// The text change will call this method (including clear text)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        [self dealWithArrwithdataArr:[NSArray arrayWithArray:self.dataSource]];
    }else{
        NSMutableArray *searchArr = [NSMutableArray array];
        for(int i = 0; i < self.dataSource.count; i++){
            ContactModel *model = self.dataSource[i];
            if([model.userName containsString:searchText]){
                [searchArr addObject:model];
            }
        }
        [self dealWithArrwithdataArr:[NSArray arrayWithArray:searchArr]];
    }
    
    
    
    
}

// Call this method when ending editing text
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self dealWithArrwithdataArr:[NSArray arrayWithArray:self.dataSource]];
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
