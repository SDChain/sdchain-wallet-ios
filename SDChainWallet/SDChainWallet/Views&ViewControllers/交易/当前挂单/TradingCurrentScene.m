//
//  TradingCurrentScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/6.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "TradingCurrentScene.h"
#import "TradingCurrentCell.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HTTPRequestManager.h"
#import "PaymentSecretManager.h"

@interface TradingCurrentScene ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *buyLabel;
@property(nonatomic,strong)UILabel *sellLabel;
@property(nonatomic,assign)NSInteger courrentPage;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation TradingCurrentScene

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

#pragma mark - action
-(void)endRefresh{
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
}

-(void)cancleOrderButtonAction:(UIButton *)sender{
    UIButton *button = sender;
    NSDictionary *dict = self.dataArr[button.tag];
    NSString *sequence = dict[@"sequence"];
    //支付密码
    PaymentSecretManager *manager = [PaymentSecretManager shareInstance];
    __weak TradingCurrentScene *weakSelf = self;
    manager.PaymemtSecretCurrectBlock = ^(NSString *passWord) {
        [weakSelf requestCancleWithwalletPassword:passWord sequence:sequence];
    };
    [manager presentSecretScene];
    
}

#pragma mark - request

-(void)requestData{
    [HTTPRequestManager getCurrentOrdersListsWithUserAccountId:SYSTEM_GET_(USERACCOUNTID) page:@(self.courrentPage) showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *response = responseObject[@"ordersLists"];
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
        [self presentAlertWithTitle:@"请求失败" message:@"" dismissAfterDelay:1.5 completion:nil];    }];
}

-(void)requestCancleWithwalletPassword:(NSString *)walletPassword sequence:(NSString *)sequence{
    [HTTPRequestManager cancelOrderWithUserAccountId:SYSTEM_GET_(USERACCOUNTID) WalletPassword:walletPassword sequence:sequence showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self presentAlertWithTitle:@"撤单成功" message:@"" dismissAfterDelay:1.5 completion:nil];
        [self.tableview.mj_header beginRefreshing];
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self presentAlertWithTitle:@"请求失败" message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

#pragma mark - UITabelVie Delegate && DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TradingCurrentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradingCurrentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",dict[@"proportion"]];
    cell.buyLabel.text = [NSString stringWithFormat:@"%@ %@",dict[@"getsValue"],dict[@"getsCurrency"]];
    cell.sellLabel.text = [NSString stringWithFormat:@"%@ %@",dict[@"paysValue"],dict[@"paysCurrency"]];
    cell.cancleOrderButtton.tag = indexPath.row;
    [cell.cancleOrderButtton addTarget:self action:@selector(cancleOrderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
        
        [_tableview registerNib:[UINib nibWithNibName:@"TradingCurrentCell" bundle:nil] forCellReuseIdentifier:@"TradingCurrentCell"];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kHeight(40))];
        [headView addSubview:self.priceLabel];
        [headView addSubview:self.buyLabel];
        [headView addSubview:self.sellLabel];
        _tableview.tableHeaderView = headView;
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        __weak TradingCurrentScene *weakSelf = self;
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

-(UILabel *)priceLabel{
    if(!_priceLabel){
       CGFloat amountWidth = (WIDTH-kWidth(105))/3;
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(15), kHeight(10), amountWidth, kHeight(20))];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = TEXT_COLOR;
        _priceLabel.text = @"价格";
        _priceLabel.font = [UIFont systemFontOfSize:13];
    }
    return _priceLabel;
}

-(UILabel *)buyLabel{
    if(!_buyLabel){
        CGFloat amountWidth = (WIDTH-kWidth(105))/3;
        _buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(15)+amountWidth, kHeight(10), amountWidth, kHeight(20))];
        _buyLabel.textAlignment = NSTextAlignmentCenter;
        _buyLabel.textColor = TEXT_COLOR;
        _buyLabel.text = @"买入";
        _buyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _buyLabel;
}

-(UILabel *)sellLabel{
    if(!_sellLabel){
        CGFloat amountWidth = (WIDTH-kWidth(105))/3;
        _sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(15)+amountWidth*2, kHeight(10), amountWidth, kHeight(20))];
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
