//
//  ShouXinScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/1.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ShouXinScene.h"
#import "ShouxinCell.h"
#import "ShouxinActionView.h"
#import "HTTPRequestManager.h"
#import "TrustListModel.h"
#import "ShouxinRecordScene.h"
#import "PaymentSecretManager.h"

@interface ShouXinScene ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@end

@implementation ShouXinScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self setupNavi];
    [self setupView];
    [self requestTrustList];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.warningLabel.text = NSLocalizedStringFromTable(@"授信_注", @"guojihua", nil);
    [self.tableView registerNib:[UINib nibWithNibName:@"ShouxinCell" bundle:nil] forCellReuseIdentifier:@"ShouxinCell"];
}

-(void)setupNavi{
    [self setTitleViewWithTitle:NSLocalizedStringFromTable(@"授信", @"guojihua", nil)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"授信记录", @"guojihua", nil) style:UIBarButtonItemStylePlain target:self action:@selector(shouxinRecordAction)];
}

#pragma mark - request
-(void)requestTrustList{
    [HTTPRequestManager getTrustlinesWithAccount:SYSTEM_GET_(ACCOUNT) showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject;
        NSMutableArray *arrM = [NSMutableArray array];
        if(arr.count >  0){
            for(int i = 0; i < arr.count; i++){
                TrustListModel *model = [TrustListModel modelWithDict:arr[i]];
                [arrM addObject:model];
            }
        }
        self.dataSourceArr = arrM;
        [self.tableView reloadData];
        
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

-(void)requestShouxinWithPassword:(NSString *)password amount:(NSString *)amount currency:(NSString *)currency counterparty:(NSString *)counterparty{
    [HTTPRequestManager trustlineWithUserAccountId:SYSTEM_GET_(USERACCOUNTID) walletPassword:password limit:amount currency:currency counterparty:counterparty showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self presentAlertWithTitle:NSLocalizedStringFromTable(@"授信成功", @"guojihua", nil) message:@"" dismissAfterDelay:1.5 completion:^{
                   [self requestTrustList];
        }];

    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self presentAlertWithTitle:NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil) message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

-(void)requestCancleTrustActionWithPassword:(NSString *)password currency:(NSString *)currency counterparty:(NSString *)counterparty{
    [HTTPRequestManager cancelTrustlineWithWalletPassword:password currency:currency counterparty:counterparty showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self presentAlertWithTitle:NSLocalizedStringFromTable(@"取消成功", @"guojihua", nil) message:@"" dismissAfterDelay:1.5 completion:^{
            [self requestTrustList];
        }];
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self presentAlertWithTitle:NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil) message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

#pragma mark - action

- (void)shoudongshouxinActionWithModel:(TrustListModel *)model{
    //支付密码
    PaymentSecretManager *manager = [PaymentSecretManager shareInstance];
    __weak ShouXinScene *weakself = self;
    manager.PaymemtSecretCurrectBlock = ^(NSString *passWord) {
        [weakself requestShouxinWithPassword:passWord amount:model.limit currency:model.currency counterparty:model.counterparty];
    };
    [manager presentSecretScene];
}

-(void)cancleShouxinActionWithModel:(TrustListModel *)model{
    //支付密码
    PaymentSecretManager *manager = [PaymentSecretManager shareInstance];
    __weak ShouXinScene *weakself = self;
    manager.PaymemtSecretCurrectBlock = ^(NSString *passWord) {
        [weakself requestCancleTrustActionWithPassword:passWord currency:model.currency counterparty:model.counterparty];
    };
    [manager presentSecretScene];
}

-(void)shouxinRecordAction{
    ShouxinRecordScene *scene = [[ShouxinRecordScene alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight(65);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeight(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShouxinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShouxinCell" forIndexPath:indexPath];
    cell.iconButton.tag = indexPath.row;
    [cell.iconButton addTarget:self action:@selector(shouxinIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell setupCellWithModel:self.dataSourceArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)shouxinIconButtonAction:(UIButton *)sender{
        TrustListModel *model=self.dataSourceArr[sender.tag];
    if([model.trusted isEqualToString:@"0"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@ %@?",NSLocalizedStringFromTable(@"授信_alert", @"guojihua", nil),model.currency] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self shoudongshouxinActionWithModel:model];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:confirmAction];
        [alert addAction:cancleAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@ %@?",NSLocalizedStringFromTable(@"取消授信_alert", @"guojihua", nil),model.currency] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cancleShouxinActionWithModel:model];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:confirmAction];
        [alert addAction:cancleAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
