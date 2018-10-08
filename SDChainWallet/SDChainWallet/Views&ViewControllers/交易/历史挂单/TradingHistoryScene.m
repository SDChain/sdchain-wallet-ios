//
//  TradingHistoryScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/6.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "TradingHistoryScene.h"
#import "TradingHistoryCell.h"
#import "Masonry.h"
#import "HTTPRequestManager.h"
#import "MJRefresh.h"

@interface TradingHistoryScene ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *buyLabel;
@property(nonatomic,strong)UILabel *sellLabel;
@property(nonatomic,assign)NSInteger courrentPage;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation TradingHistoryScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self.tableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    self.courrentPage = 1;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - request

-(void)requestData{
    [HTTPRequestManager getHisExchangeListsWithUserAccountId:SYSTEM_GET_(USERACCOUNTID) page:@(self.courrentPage) showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *response = responseObject;
        if(self.courrentPage > 1){
            if(response.count > 0){
                for(int i = 0; i < response.count; i++){
                    [self.dataArr addObject:response[i]];
                }
                [self endRefresh];
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else{
            self.dataArr = [NSMutableArray arrayWithArray:response];
            [self endRefresh];
            [self.tableview reloadData];
        }
        
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self endRefresh];
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self endRefresh];
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefresh];
        [self presentAlertWithTitle:@"请求失败" message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

#pragma mark - action
-(void)endRefresh{
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
}

#pragma mark - UITabelVie Delegate && DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TradingHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradingHistoryCell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.row];
    if([dict[@"type"] isEqualToString:@"OfferCreate"]){
        cell.titleLabel.text = @"挂单";
    }
    else{
        cell.titleLabel.text = @"撤单";
    }
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",dict[@"proportion"]];
    cell.buyLabel.text = [NSString stringWithFormat:@"%@ %@",dict[@"takerGetsValue"],dict[@"takerGetsCurrency"]];
    cell.sellLabel.text = [NSString stringWithFormat:@"%@ %@",dict[@"takerPaysValue"],dict[@"takerPaysCurrency"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight(40);
}

#pragma mark - getter
-(UITableView *)tableview{
    if(!_tableview){
        _tableview = [[UITableView alloc] init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorColor = LINE_COLOR;
        [_tableview registerNib:[UINib nibWithNibName:@"TradingHistoryCell" bundle:nil] forCellReuseIdentifier:@"TradingHistoryCell"];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kHeight(40))];
        [headView addSubview:self.titleLabel];
        [headView addSubview:self.priceLabel];
        [headView addSubview:self.buyLabel];
        [headView addSubview:self.sellLabel];
        _tableview.tableHeaderView = headView;
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        __weak TradingHistoryScene *weakSelf = self;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.courrentPage = 1;
            self.dataArr = [NSMutableArray array];
            [weakSelf requestData];
        }];
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.courrentPage = weakSelf.courrentPage + 1;
            [weakSelf requestData];
        }];
    }
    return _tableview;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(15), kHeight(10), kWidth(50), kHeight(20))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.text = @"类型";
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

-(UILabel *)priceLabel{
    if(!_priceLabel){
        CGFloat amountWidth = (WIDTH-kWidth(50))/3;
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(65), kHeight(10), amountWidth, kHeight(20))];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = TEXT_COLOR;
        _priceLabel.text = @"价格";
        _priceLabel.font = [UIFont systemFontOfSize:13];
    }
    return _priceLabel;
}

-(UILabel *)buyLabel{
    if(!_buyLabel){
        CGFloat amountWidth = (WIDTH-kWidth(50))/3;
        _buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(65)+amountWidth, kHeight(10), amountWidth, kHeight(20))];
        _buyLabel.textAlignment = NSTextAlignmentCenter;
        _buyLabel.textColor = TEXT_COLOR;
        _buyLabel.text = @"买入";
        _buyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _buyLabel;
}

-(UILabel *)sellLabel{
    if(!_sellLabel){
        CGFloat amountWidth = (WIDTH-kWidth(50))/3;
        _sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(65)+amountWidth*2, kHeight(10), amountWidth, kHeight(20))];
        _sellLabel.textAlignment = NSTextAlignmentCenter;
        _sellLabel.textColor = TEXT_COLOR;
        _sellLabel.text = @"卖出";
        _sellLabel.font = [UIFont systemFontOfSize:13];
    }
    return _sellLabel;
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
