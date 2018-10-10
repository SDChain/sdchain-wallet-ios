//
//  ShouxinRecordScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/29.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "ShouxinRecordScene.h"
#import "ShouxinRecordCell.h"
#import "Masonry.h"
#import "HTTPRequestManager.h"
#import "MJRefresh.h"
#import "ShouxinRecordModel.h"

@interface ShouxinRecordScene ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSString *marker;
@property(nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ShouxinRecordScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setTitleViewWithTitle:NSLocalizedStringFromTable(@"授信记录", @"guojihua", nil)];
    self.marker = @"";
    self.dataArr = [NSMutableArray array];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

-(void)endRefreshAction{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)requestInfo{
    [HTTPRequestManager getHisTrustlinesWithAccount:SYSTEM_GET_(ACCOUNT) marker:self.marker showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *data = responseObject[@"data"];
        if(self.marker || self.marker.length > 0){
            for(int i = 1; i < data.count; i++){
                ShouxinRecordModel *model = [ShouxinRecordModel modelWithDict:data[i]];
                [self.dataArr addObject:model];
            }
        }
        else{
            self.dataArr = [NSMutableArray arrayWithArray:data];
        }
        [self.tableView reloadData];
        if(responseObject[@"marker"]){
            self.marker = responseObject[@"marker"];
        }else{
            self.marker = @"";
        }
        [self endRefreshAction];
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self endRefreshAction];
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self endRefreshAction];
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefreshAction];
        [self presentAlertWithTitle:NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil) message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeight(10);
}

-(CGFloat)tableView:(UITableView *)tableView HeightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShouxinRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShouxinRecordCell" forIndexPath:indexPath];
    [cell setupCellWithModel:self.dataArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight(55);
}

#pragma mark - getter
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ShouxinRecordCell" bundle:nil] forCellReuseIdentifier:@"ShouxinRecordCell"];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
        __weak ShouxinRecordScene *weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.marker  = @"";
            self.dataArr = [NSMutableArray array];
            [weakSelf requestInfo];
        }];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if(weakSelf.marker.length == 0){
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf requestInfo];
            }
            
        }];
        
    }
    return _tableView;
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
