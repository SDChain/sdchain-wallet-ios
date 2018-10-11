//
//  TransferDetailScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/3.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "TransferDetailScene.h"
#import "TransferDetailCell.h"
#import "HTTPRequestManager.h"


@interface TransferDetailScene ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *currency;
@property(nonatomic,strong)NSString *string1;
@property(nonatomic,strong)NSString *string2;
@property(nonatomic,strong)NSString *string3;
@property(nonatomic,strong)NSString *string4;
@property(nonatomic,strong)NSString *string5;
@property(nonatomic,strong)NSString *string6;
@property(nonatomic,strong)NSString *string7;
@property(nonatomic,strong)NSString *string8;
@property(nonatomic,strong)NSString *string9;
@property(nonatomic,strong)NSString *string10;


@end

@implementation TransferDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"交易详情", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self.tableView registerNib:[UINib nibWithNibName:@"TransferDetailCell" bundle:nil] forCellReuseIdentifier:@"TransferDetailCell"];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];

    [self requestDetailInfo];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 自定义后退按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

//轮询状态
-(void)requestStateInfo{
    [HTTPRequestManager getPaymentsListWithUseraccountId:SYSTEM_GET_(USERACCOUNTID) hash:self.hashStr showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *paymentDict = responseObject[@"payment"];
        self.string9 = paymentDict[@"state"];
        if([self.string9 isEqualToString:@"validated"]){
            self.string5 = [NSString stringWithFormat:@"%@",paymentDict[@"date"]];
            self.string5 = [GlobalMethod timeWithSecondStr:self.string5];
            [self.tableView reloadData];
        }else{
            [self requestStateInfo];
        }
        
        
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *title = NSLocalizedStringFromTable(@"请求错误", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

-(void)requestDetailInfo{
    [HTTPRequestManager getPaymentsListWithUseraccountId:SYSTEM_GET_(USERACCOUNTID) hash:self.hashStr showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *paymentDict = responseObject[@"payment"];
        self.string1 = paymentDict[@"source_account"];
        self.string2 = paymentDict[@"destination_account"];
        self.string3 = paymentDict[@"amount"][@"value"];
        self.string4 = paymentDict[@"fee"];
//        self.string5 = [GlobalMethod getTimeWithdate:paymentDict[@"date"]];
        self.string6 = paymentDict[@"hash"];
        self.string7 = paymentDict[@"ledger"];
        self.string8 = paymentDict[@"direction"];
        self.string9 = paymentDict[@"state"];
        self.currency = paymentDict[@"amount"][@"currency"];

        if(paymentDict[@"memos"]){
            self.string10 = paymentDict[@"memos"][0][@"MemoData"];
        }else{
            self.string10 = @"";
        }
        
        [self.tableView reloadData];
        [self requestStateInfo];
        
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *title = NSLocalizedStringFromTable(@"请求错误", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransferDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0){
        NSString *title = NSLocalizedStringFromTable(@"发款方", @"guojihua", nil);
        cell.titleLabel.text = title;
        cell.detailLabel.font = [UIFont systemFontOfSize:12];
        cell.detailLabel.text = self.string1;
    }else if (indexPath.row == 1){
        cell.detailLabel.font = [UIFont systemFontOfSize:12];
        NSString *title = NSLocalizedStringFromTable(@"收款方", @"guojihua", nil);
        cell.titleLabel.text = title;
        cell.detailLabel.text = self.string2;
    }else if (indexPath.row == 2){
        NSString *title = NSLocalizedStringFromTable(@"金额", @"guojihua", nil);
        cell.titleLabel.text = title;
        if(self.string3 && self.currency){
            cell.detailLabel.text = [NSString stringWithFormat:@"%@ %@",self.string3,self.currency];
        }
        else{
            cell.detailLabel.text = @"";
        }
    }else if (indexPath.row == 3){
        if(self.string4){
            cell.detailLabel.text = [NSString stringWithFormat:@"%@ SDA",self.string4];
        }else{
            cell.detailLabel.text = @"";
        }
        NSString *title = NSLocalizedStringFromTable(@"手续费", @"guojihua", nil);
        cell.titleLabel.text = title;

    }else if (indexPath.row == 4){
        NSString *title = NSLocalizedStringFromTable(@"交易时间", @"guojihua", nil);
        cell.titleLabel.text = title;
//        if([self.string5 isEqualToString:@""]){
//            cell.detailLabel.text = [GlobalMethod getCurrentTimes];
//        }else{
//            cell.detailLabel.text = [GlobalMethod htcTimeToLocationStr:self.string5];
//        }
        cell.detailLabel.text = self.string5;
    }else if (indexPath.row == 5){
        cell.detailLabel.font = [UIFont systemFontOfSize:12];
        NSString *title = NSLocalizedStringFromTable(@"交易hash", @"guojihua", nil);
        cell.titleLabel.text = title;
        cell.detailLabel.text = self.string6;
    }else if (indexPath.row == 6){
        NSString *title = NSLocalizedStringFromTable(@"区块", @"guojihua", nil);
        cell.titleLabel.text = title;
        cell.detailLabel.text = self.string7;
    }else if (indexPath.row == 7){
        NSString *title = NSLocalizedStringFromTable(@"交易类型", @"guojihua", nil);
        cell.titleLabel.text = title;
        if([self.string8 isEqualToString:@"incoming"]){
            NSString *detail = NSLocalizedStringFromTable(@"转入", @"guojihua", nil);
            cell.detailLabel.text = detail;
        }else if([self.string8 isEqualToString:@"outgoing"]){
            NSString *detail = NSLocalizedStringFromTable(@"转出", @"guojihua", nil);
            cell.detailLabel.text = detail;
        }
    }else if (indexPath.row == 8){
        NSString *title = NSLocalizedStringFromTable(@"状态", @"guojihua", nil);
        cell.titleLabel.text = title;
        cell.detailLabel.text = self.string9;

    }else if (indexPath.row == 9){
        NSString *title = NSLocalizedStringFromTable(@"备注", @"guojihua", nil);
        cell.titleLabel.text = title;
        cell.detailLabel.text = self.string10;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
