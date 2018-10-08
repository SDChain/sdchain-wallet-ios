//
//  MessagesListScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/10.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "MessagesListScene.h"
#import "TransferListCell.h"
#import "HTTPRequestManager.h"
#import "MJRefresh.h"
#import "TransferDetailScene.h"

@interface MessagesListScene ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *messagesList;
//@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)NSString *marker;

@end

@implementation MessagesListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupData{
    self.marker = @"";
}

-(void)setupNavi{
    NSString *title = NSLocalizedStringFromTable(@"消息中心", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
}

-(void)setupView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"TransferListCell" bundle:nil] forCellReuseIdentifier:@"TransferListCell"];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
    __weak MessagesListScene *weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.marker  = @"";
        self.messagesList = [NSMutableArray array];
        [weakSelf requestMessagesList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(weakSelf.marker.length == 0){
            [weakSelf endFreshingNoMoreAction];
        }else{
            [weakSelf requestMessagesList];
        }
        
    }];
}

#pragma mark - action
-(void)endFreshingAction{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)endFreshingNoMoreAction{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - request

-(void)requestMessagesList{
    [HTTPRequestManager getPaymentsListWithUseraccountId:SYSTEM_GET_(USERACCOUNTID) page:self.marker currency:nil minDate:nil maxDate:nil showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *dataArr = responseObject[@"payments"];
        if(self.marker.length > 0){
            if(dataArr.count > 0){
                for(int i = 0; i < dataArr.count; i++){
                    NSDictionary *dict = dataArr[i];
                    [self.messagesList addObject:dict];
                }
            }
            [self.tableView reloadData];

        }else{
            self.messagesList = [NSMutableArray arrayWithArray:dataArr];
            [self.tableView reloadData];

        }
        [self endFreshingAction];
        if(responseObject[@"marker"]){
            self.marker = responseObject[@"marker"];
        }else{
            self.marker = @"";
        }

    } reLogin:^{
        [GlobalMethod loginOutAction];
        [self endFreshingAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        [self endFreshingAction];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
        [self endFreshingAction];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *title = NSLocalizedStringFromTable(@"请求错误", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        [self endFreshingAction];
    }];

}


#pragma mark - UITableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransferListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCellWithDict:self.messagesList[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.messagesList[indexPath.row];
    TransferDetailScene *scene = [[TransferDetailScene alloc] initWithNibName:@"TransferDetailScene" bundle:nil];
    scene.hidesBottomBarWhenPushed = YES;
    scene.hashStr = dict[@"hash"];
    [self.navigationController pushViewController:scene animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)messagesList{
    if(!_messagesList){
        _messagesList = [NSMutableArray array];
    }
    return _messagesList;
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
