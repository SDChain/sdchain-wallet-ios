//
//  TransferSelectScene.m
//  CulturalExchange
//
//  Created by 钱伟成 on 2018/5/28.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "TransferSelectScene.h"
#import "CurrenciesKindCell.h"
#import "HTTPRequestManager.h"


@interface TransferSelectScene ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *backView;


@end

@implementation TransferSelectScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationItem setHidesBackButton:NO];
    [self.navigationItem setHidesBackButton:NO];
    [self.navigationController.navigationBar.backItem setHidesBackButton:NO];
}

#pragma mark - setup

-(void)setupNavi{
    UIButton *naviButton = [[UIButton alloc] init];
    naviButton.titleLabel.font = KICON_FONT(20);
    [naviButton setTitleColor:[UIColor whiteColor    ] forState:UIControlStateNormal];
    [naviButton addTarget:self action:@selector(titleAction) forControlEvents:UIControlEventTouchUpInside];
    NSString *qingceshi = NSLocalizedStringFromTable(@"请选择", @"guojihua", nil);
    [naviButton setTitle:[NSString stringWithFormat:@"%@ \U0000e624",qingceshi] forState:UIControlStateNormal];
    [naviButton sizeToFit];
    self.navigationItem.titleView = naviButton;
}

-(void)setupView{
    [self.view addSubview:self.backView];
    [self.view addSubview:self.tableView];
}

-(void)titleAction{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - action



#pragma mark - UITableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrenciesKindCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"CurrenciesKindCell" forIndexPath:indexPath];
//    NSDictionary *dict = self.dataArr[indexPath.row];
    BalanceModel *model = self.dataArr[indexPath.row];
    cell.currenciesKindLabel.text = model.currency;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.transferSelectBlock){
        self.transferSelectBlock(self.dataArr[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight(55);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.dataArr.count*kHeight(55)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = LINE_COLOR;
        [_tableView registerNib:[UINib nibWithNibName:@"CurrenciesKindCell" bundle:nil] forCellReuseIdentifier:@"CurrenciesKindCell"];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
    }
    return _tableView;
}

-(UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:self.view.frame];
        _backView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
        [_backView addGestureRecognizer:gusture];
    }
    return _backView;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
