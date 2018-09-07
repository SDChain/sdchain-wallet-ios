//
//  TransferAccountsScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/15.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "TransferAccountsScene.h"
#import "ChooseFriendScene.h"
#import "PaymentSecretManager.h"
#import "HTTPRequestManager.h"
#import "TransferDetailScene.h"
#import "TransferListScene.h"
#import "MineScene.h"
#import "AppDelegate.h"
#import "TransferSelectScene.h"


@interface TransferAccountsScene ()<UITextFieldDelegate,UITabBarControllerDelegate>

@property (nonatomic,strong) UIButton *naviButton;

@property (weak, nonatomic) IBOutlet UILabel *tianjiashoukuairenLabel;
@property (weak, nonatomic) IBOutlet UIButton *suoyouyueButton;

@property (weak, nonatomic) IBOutlet UILabel *tianjiabeizhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *suoyouyueLabel;


@property (weak, nonatomic) IBOutlet UITextField *receiverAddressTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *receiveAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *additionButton;
@property (weak, nonatomic) IBOutlet UILabel *lowBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputWarnLabel;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;


@property (nonatomic, assign) BOOL isSendDot;

@property (nonatomic, strong) ContactModel *model;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, assign) double balanceRest;
@property (nonatomic, assign) double freezeAmount;
@property (nonatomic, strong) NSArray *balanceArr;
@property (nonatomic, strong) BalanceModel *currentModel;

@end

@implementation TransferAccountsScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    NSString *title = NSLocalizedStringFromTable(@"转账", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    self.navigationItem.titleView = self.naviButton;
    [self setupView];
    [self setupData];
    if(self.accountStr != nil){
        self.receiverAddressTextFiled.text = self.accountStr;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:)name:@"xuanze" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearTransAccountAction)name:@"qingkong" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)tongzhi:(NSNotification *)text{
    self.receiverAddressTextFiled.text = text.userInfo[@"textOne"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshSceneWithModel:self.currentModel];
}

-(void)clearTransAccountAction{
    self.receiverAddressTextFiled.text = @"";
    self.amountTextField.text = @"";
    self.remarkTextField.text = @"";
    [self requestBalanceWithPresentAlert:NO];
}

-(void)naviSelectAction{
    if(self.balanceArr.count > 0){
        TransferSelectScene *scene = [[TransferSelectScene alloc] init];
        scene.dataArr = self.balanceArr;
        __weak TransferAccountsScene *weakSelf = self;
        scene.transferSelectBlock = ^(BalanceModel *model) {
            weakSelf.currentModel = model;
            if([model.currency isEqualToString:@"SDA"]){
                self.freezeAmount = [SYSTEM_GET_(FREEZE) doubleValue];
            }else{
                self.freezeAmount = 0;
            }
            [weakSelf refreshSceneWithModel:model];
            [weakSelf checkRestAmount];
        };
        scene.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scene animated:NO];
    }
    
}

-(void)refreshSceneWithModel:(BalanceModel *)model{
    NSString *keyong = NSLocalizedStringFromTable(@"可用", @"guojihua", nil);
    NSString *dongjie = NSLocalizedStringFromTable(@"冻结", @"guojihua", nil);
    NSString *qingxuanze = NSLocalizedStringFromTable(@"请选择", @"guojihua", nil);
    if(self.currentModel == nil){
        [self.naviButton setTitle:@"SDA \U0000e68B" forState:UIControlStateNormal];
        self.inputWarnLabel.text = [NSString stringWithFormat:@"%@：0.000000，%@：0.000000",keyong,dongjie];
    }else{
        [self.naviButton setTitle:[NSString stringWithFormat:@"%@ \U0000e68B",self.currentModel.currency] forState:UIControlStateNormal];
        if([self.currentModel.value doubleValue] >= self.freezeAmount){
            self.inputWarnLabel.text = [NSString stringWithFormat:@"%@：%.6f，%@：%.6f",keyong,[self.currentModel.value doubleValue] - self.freezeAmount,dongjie,self.freezeAmount];
        }else{
            self.inputWarnLabel.text = [NSString stringWithFormat:@"%@：0.000000，%@：%.6f",keyong,dongjie,[self.currentModel.value doubleValue]];
        }
    }
}

-(void)setupView{
    self.tabBarController.delegate = self;
    self.nextStepButton.layer.masksToBounds = YES;
    self.nextStepButton.layer.cornerRadius = 22.5;
    self.nextStepButton.enabled = NO;
    self.nextStepButton.backgroundColor = UNCLICK_COLOR;
    
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGusture];
    [self internationalAction];
}


-(void)internationalAction{
    NSString *tianjiashoukuanrendizhi = NSLocalizedStringFromTable(@"添加收款人地址", @"guojihua", nil);
    NSString *suoyouyue = NSLocalizedStringFromTable(@"所有余额", @"guojihua", nil);
    NSString *yuebuzu = NSLocalizedStringFromTable(@"余额不足", @"guojihua", nil);
    NSString *tianjiabeizhu = NSLocalizedStringFromTable(@"添加备注", @"guojihua", nil);
    NSString *xiayibu = NSLocalizedStringFromTable(@"转账1", @"guojihua", nil);
    
    self.tianjiashoukuairenLabel.text = tianjiashoukuanrendizhi;
    self.suoyouyueLabel.text = suoyouyue;
    self.lowBalanceLabel.text = yuebuzu;
    self.tianjiabeizhuLabel.text = tianjiabeizhu;
    [self.nextStepButton setTitle:xiayibu forState:UIControlStateNormal];
}

-(void)setupData{
    [self refreshSceneWithDict:SYSTEM_GET_(BALANCES)];
    [self refreshSceneWithModel:self.currentModel];
    [self requestBalanceWithPresentAlert:YES];
}

-(void)refreshSceneWithDict:(NSArray *)responseArr{
    self.freezeAmount = [SYSTEM_GET_(FREEZE) doubleValue];
    NSMutableArray *arr = [NSMutableArray array];
    [responseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BalanceModel *model = [BalanceModel modelWithDict:obj];
        [arr addObject:model];
        if([model.currency isEqualToString:@"SDA"]){
            self.currentModel = model;
        }
    }];
    self.balanceArr = arr;
}

-(void)requestBalanceWithPresentAlert:(BOOL)alert{
    NSString *keyong = NSLocalizedStringFromTable(@"可用", @"guojihua", nil);
    NSString *dongjie = NSLocalizedStringFromTable(@"冻结", @"guojihua", nil);
    
    [HTTPRequestManager getBalanceWithAccount:SYSTEM_GET_(ACCOUNT) userId:SYSTEM_GET_(USER_ID) appToken:SYSTEM_GET_(APPTOKEN) showProgress:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = responseObject[@"balances"];
        self.freezeAmount = [responseObject[@"reserveBase"] doubleValue];
        SYSTEM_SET_(responseArr, BALANCES);
        SYSTEM_SET_(responseObject[@"reserveBase"], FREEZE);
        [self refreshSceneWithDict:SYSTEM_GET_(BALANCES)];
        [self refreshSceneWithModel:self.currentModel];
        
        
    } reLogin:^(void){
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        self.balanceArr = @[];
        self.currentModel = [BalanceModel modelWithDict:@{@"counterparty":@"",
                                                          @"currency":@"SDA",
                                                          @"value":@"0",
                                                          @"pic":@"",
                                                          }];
        self.inputWarnLabel.text = [NSString stringWithFormat:@"%@：0.000000，%@：0.000000",keyong,dongjie];
    } error:^(NSString *content) {
        
        self.balanceArr = @[];
        self.currentModel = [BalanceModel modelWithDict:@{@"counterparty":@"",
                                                          @"currency":@"SDA",
                                                          @"value":@"0",
                                                          @"pic":@"",
                                                          }];
        self.inputWarnLabel.text = [NSString stringWithFormat:@"%@：0.000000，%@：0.000000",keyong,dongjie];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        self.balanceArr = @[];
        self.currentModel = [BalanceModel modelWithDict:@{@"counterparty":@"",
                                                          @"currency":@"SDA",
                                                          @"value":@"0",
                                                          @"pic":@"",
                                                          }];
        self.inputWarnLabel.text = [NSString stringWithFormat:@"%@：0.000000，%@：0.000000",keyong,dongjie];
    }];
}

-(void)hideKeyBoard{
    [self.amountTextField resignFirstResponder];
    [self.remarkTextField resignFirstResponder];
}
 
-(void)amountTransitionAction{

    double amount = [self.amountTextField.text doubleValue];
    NSString *amountStr = [NSString stringWithFormat:@"%.6f",amount];


    [HTTPRequestManager paymentissueCurrencyWithDestinationAccount:self.receiverAddressTextFiled.text value:amountStr currency:self.currentModel.currency memo:self.remarkTextField.text walletPassword:self.passWord userId:SYSTEM_GET_(USER_ID) apptoken:SYSTEM_GET_(APPTOKEN) userAccountId:SYSTEM_GET_(USERACCOUNTID) showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tab = (UITabBarController *)app.window.rootViewController;
        MineScene *scene1 = [[MineScene alloc] init];
        TransferListScene *scene2 = [[TransferListScene alloc] initWithNibName:@"TransferListScene" bundle:nil];
        scene2.hidesBottomBarWhenPushed = YES;
        TransferDetailScene *scene3 = [[TransferDetailScene alloc] initWithNibName:@"TransferDetailScene" bundle:nil];
        scene3.hidesBottomBarWhenPushed = YES;
        scene3.hashStr = responseObject[@"hash"];
        scene3.statusUrlStr = responseObject[@"status_url"];
        scene3.successStr = responseObject[@"success"];
        BaseNavigationController *naviScene = [[BaseNavigationController alloc] initWithRootViewController:scene1];
        [naviScene setViewControllers:@[scene1,scene2,scene3]];
        NSArray *arr = tab.viewControllers;
        NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr];
        arr1[2] = naviScene;
        [tab setViewControllers:arr1];
        naviScene.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:NAVIBAR_COLOR};
        [naviScene.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        [naviScene.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
        NSString *title = NSLocalizedStringFromTable(@"个人中心", @"guojihua", nil);
        naviScene.tabBarItem.title = title;
        naviScene.tabBarItem.image = [[UIImage imageNamed:@"personal_barIcon_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        naviScene.tabBarItem.selectedImage = [[UIImage imageNamed:@"personal_barIcon_delected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        tab.selectedIndex = 2;

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

- (IBAction)allRestAmountAction:(id)sender {
    if(self.balanceRest < 0.6){
        self.amountTextField.text = @"0";
    }else{
        self.amountTextField.text = [NSString stringWithFormat:@"%.6f",self.balanceRest-0.6];
    }
    if([self.amountTextField.text doubleValue] > 0 && self.receiverAddressTextFiled.text.length > 0 && self.balanceRest > 0.6){
        [self transActionEnableWithBool:YES];
    }
    else{
        [self transActionEnableWithBool:NO];
    }
}


- (IBAction)nextStepAction:(id)sender {
    if([self.receiverAddressTextFiled.text isEqualToString:SYSTEM_GET_(ACCOUNT)]){
         NSString *title = NSLocalizedStringFromTable(@"无法给本人转账", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }else{
        PaymentSecretManager *manager = [PaymentSecretManager shareInstance];
        __weak TransferAccountsScene *weakSelf = self;
        manager.PaymemtSecretCurrectBlock = ^(NSString *passWord) {
            weakSelf.passWord = passWord;
            [weakSelf amountTransitionAction];
        };
        [manager presentSecretScene];
    }


}

- (IBAction)chooseFriendAction:(id)sender {
    ChooseFriendScene *scene = [[ChooseFriendScene alloc] init];
    scene.hidesBottomBarWhenPushed = YES;
    scene.type = ListTypeSelect;
    __weak TransferAccountsScene *weakSelf = self;
    scene.tapBlock = ^(ContactModel *model) {
        weakSelf.model = model;
        weakSelf.receiverAddressTextFiled.text = model.account;
    };
    [self.navigationController pushViewController:scene animated:YES];
}

-(void)checkRestAmount{
    double amount = [self.amountTextField.text doubleValue];
    NSString *amountStr = [NSString stringWithFormat:@"%.6f",amount];
    if([amountStr doubleValue] > [self.currentModel.value doubleValue] - self.freezeAmount){
        self.lowBalanceLabel.hidden = NO;
        [self transActionEnableWithBool:YES];
    }else{
        self.lowBalanceLabel.hidden = YES;
        [self transActionEnableWithBool:NO];
    }
    if([self.amountTextField.text doubleValue] > 0 && self.receiverAddressTextFiled.text.length > 0 && [self.currentModel.value doubleValue] - self.freezeAmount > [self.amountTextField.text doubleValue]){
        [self transActionEnableWithBool:YES];
    }
    else{
        [self transActionEnableWithBool:NO];
    }

}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text = @"";
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkRestAmount];
}

-(void)transActionEnableWithBool:(BOOL)amount{
    if(amount){
        self.nextStepButton.enabled = YES;
        self.nextStepButton.backgroundColor = NAVIBAR_COLOR;
    }else{
        self.nextStepButton.enabled = NO;
        self.nextStepButton.backgroundColor = UNCLICK_COLOR;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"."]) {

        if ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""]) {
            
            return NO;
        } else {
            
            return YES;
        }
    } else {
        if (textField.text.length == 1) {
            
            unichar str = [textField.text characterAtIndex:0];
            if (str == '0' && [string isEqualToString:@"0"]) {
                
                return NO;
            }
            
            if (str != '0' && str != '1') {
                
                return YES;
            } else {
                
                if (str == '1') {
                    
                    return YES;
                } else {
                    
                    if ([string isEqualToString:@""]) {
                        
                        return YES;
                    } else {
                        
                        return NO;
                    }
                }
                
                
            }
        }
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            
            NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
            [str insertString:string atIndex:range.location];
            
            if (str.length >= [str rangeOfString:@"."].location + 8) {
                
                return NO;
            }
            NSLog(@"str.length = %ld, str = %@, string.location = %ld", str.length, string, range.location);
        } else {
            if (textField.text.length > 5) {
                return range.location < 6;
            }
        }
    }
    return YES;
}

#pragma mark - getter
-(UIButton *)naviButton{
    if(!_naviButton){
        _naviButton = [[UIButton alloc] init];
        _naviButton.titleLabel.font = KICON_FONT(20);
        [_naviButton setTitle:@"  SDA \U0000e68B" forState:UIControlStateNormal];
        [_naviButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _naviButton.enabled = YES;
        [_naviButton addTarget:self action:@selector(naviSelectAction) forControlEvents:UIControlEventTouchUpInside];
        [_naviButton sizeToFit];
    }
    return _naviButton;
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
