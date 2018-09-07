//
//  TransferListScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/3.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "TransferListScene.h"
#import "TransferListCell.h"
#import "HTTPRequestManager.h"
#import "ValuePickerView.h"
#import "MJRefresh.h"
#import "TransferDetailScene.h"

@interface TransferListScene ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSString *minDate;
@property(nonatomic,strong)NSString *maxDate;
@property (weak, nonatomic) IBOutlet UIButton *pickButton;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSString *marker;
@property(nonatomic,strong)NSString *currentMonthStr;
@property(nonatomic,strong)NSString *defaultSelectStr;

@property (weak, nonatomic) IBOutlet UILabel *chooseTimeLabel;


@end

@implementation TransferListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];
    [self setupData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setupData{
    self.marker = @"";
    NSString *title = NSLocalizedStringFromTable(@"本月", @"guojihua", nil);
    self.currentMonthStr = title;
    self.dataArr = [NSMutableArray array];
    self.minDate = @"";
    self.maxDate = @"";
    NSString *currentTime = [GlobalMethod getCurrentTimes];
    NSString *yearStr = [currentTime substringToIndex:4];
    NSString *monthStr = [currentTime substringWithRange:NSMakeRange(5, 2)];
    self.defaultSelectStr = [NSString stringWithFormat:@"%@,%@",yearStr,monthStr];
    NSInteger maxDayth = [GlobalMethod getNumberOfDaysInMonthWithYear:[yearStr intValue] month:[monthStr intValue]];
    NSArray *dayArr = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    self.minDate = [NSString stringWithFormat:@"%@-%@-01",yearStr,monthStr];
    self.maxDate = [NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayArr[maxDayth - 1]];
    [self requestInfo];
}

-(void)setupNavi{
    NSString *title = NSLocalizedStringFromTable(@"转账记录", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
}

-(void)setupView{
    NSString *title = NSLocalizedStringFromTable(@"选择时间", @"guojihua", nil);
    self.chooseTimeLabel.text = title;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TransferListCell" bundle:nil] forCellReuseIdentifier:@"TransferListCell"];
    self.tableView.separatorColor = LINE_COLOR;
    __weak TransferListScene *weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(![weakSelf.minDate isEqualToString:@""]){
            weakSelf.marker = @"";
            [weakSelf requestInfo];
        }
        else{
            [weakSelf chooseDateAction];
            [weakSelf endFreshingAction];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(![weakSelf.minDate isEqualToString:@""]){
            if(weakSelf.marker.length == 0){
                [weakSelf endFreshingNoMoreAction];
            }else{
                [weakSelf requestInfo];
            }
        }
        else{
            [weakSelf chooseDateAction];
            [weakSelf endFreshingAction];
        }
    }];
}

-(void)endFreshingAction{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)endFreshingNoMoreAction{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - action
-(void)requestInfo{
    [HTTPRequestManager getPaymentsListWithUseraccountId:SYSTEM_GET_(USERACCOUNTID) page:self.marker currency:self.currency minDate:self.minDate maxDate:self.maxDate showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *data = responseObject[@"payments"];
        if(self.marker.length > 0){
            for(int i = 1; i < data.count; i++){
                [self.dataArr addObject:data[i]];
            }
        }
        else{
            self.dataArr = [NSMutableArray arrayWithArray:data];
    
        }
        [self.tableView reloadData];
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
        NSString *title = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        [self endFreshingAction];
    }];
}




//Select date
- (IBAction)pickButtonAction:(id)sender {
    [self chooseDateAction];
}

-(void)chooseDateAction{
    __weak TransferListScene *weakSelf = self;
    ValuePickerView *pickerView = [[ValuePickerView alloc]init];
    NSArray *yearArr = @[@"2017",@"2018",@"2019"];
    NSArray *monthArr = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    NSArray *dayArr = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    pickerView.dataSource = [NSArray arrayWithObjects:yearArr,monthArr, nil];
    NSString *title = NSLocalizedStringFromTable(@"请选择月份", @"guojihua", nil);
    pickerView.pickerTitle = title;
    NSString *yearStr = [self.defaultSelectStr substringToIndex:4];
    NSString *monthStr = [self.defaultSelectStr substringFromIndex:5];
    NSString *string1 = [self findIndexWithArr:yearArr string:yearStr];
    NSString *string2 = [self findIndexWithArr:monthArr string:monthStr];
    pickerView.defaultStr = [NSString stringWithFormat:@"%@,%@",string1,string2];


    pickerView.valueDidSelect = ^(NSArray * value){
        if ([value[0]  isEqual: @""] || [value[1]  isEqual: @""]) {
            
            NSLog(@"可能会错");
        } else {
            int year = [value[0] intValue];
            int month = [value[1] intValue];
            NSString *yeartitle = NSLocalizedStringFromTable(@"年", @"guojihua", nil);
            NSString *monthtitle = NSLocalizedStringFromTable(@"月", @"guojihua", nil);
            self.currentMonthStr = [NSString stringWithFormat:@"%d%@%d%@",year,yeartitle,month,monthtitle];
            NSInteger maxDayth = [GlobalMethod getNumberOfDaysInMonthWithYear:year month:month];

            weakSelf.minDate = [NSString stringWithFormat:@"%d-%@-01",year,monthArr[month-1]];
            weakSelf.maxDate = [NSString stringWithFormat:@"%d-%@-%@",year,monthArr[month-1],dayArr[maxDayth - 1]];
            self.marker = @"";
            [weakSelf requestInfo];
        }
    };
    
    [pickerView show];
}

-(NSString *)findIndexWithArr:(NSArray *)arr string:(NSString *)string{
    NSString *indexStr;
    for (int i = 0; i < arr.count; i++){
        if([string isEqualToString:arr[i]]){
            indexStr = [NSString stringWithFormat:@"%d",i+1];
        }
    }
    return indexStr;
}

    
#pragma mark - UITableView Delagate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransferListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCellWithDict:self.dataArr[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.currentMonthStr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.row];
    TransferDetailScene *scene = [[TransferDetailScene alloc] initWithNibName:@"TransferDetailScene" bundle:nil];
    scene.hidesBottomBarWhenPushed = YES;
    scene.hashStr = dict[@"hash"];
    [self.navigationController pushViewController:scene animated:YES];
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
