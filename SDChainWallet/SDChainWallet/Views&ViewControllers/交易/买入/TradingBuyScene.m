//
//  TradingBuyScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/6.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "TradingBuyScene.h"
#import "InputAmountView.h"
#import "Masonry.h"
#import "OrderShowView.h"
#import "HTTPRequestManager.h"
#import "TradingCurrencyModel.h"
#import "CurrencySelectPopView.h"
#import "BalanceModel.h"
#import "PaymentSecretManager.h"

@interface TradingBuyScene ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *headContentView;
@property(nonatomic,strong) UIView *bodyContentView;

@property(nonatomic,strong) UILabel *title1;
@property(nonatomic,strong) UILabel *titleImageLabel1;
@property(nonatomic,strong) UIButton *titleButton1;
@property(nonatomic,strong) UILabel *account1;
@property(nonatomic,strong) InputAmountView *amountTextView;
@property(nonatomic,strong) UITextField *amountTextField;
@property(nonatomic,strong) UILabel *xLabel;
@property(nonatomic,strong) InputAmountView *priceTextField;
@property(nonatomic,strong) UIButton *equalButton;
@property(nonatomic,strong) UILabel *countLabel;
@property(nonatomic,strong) UILabel *title2;
@property(nonatomic,strong) UILabel *titleImageLabel2;
@property(nonatomic,strong) UIButton *titleButton2;
@property(nonatomic,strong) UILabel *account2;
@property(nonatomic,strong) UILabel *restAmountTitle;
@property(nonatomic,strong) UILabel *freezeTitle;
@property(nonatomic,strong) UILabel *restAmountLabel;
@property(nonatomic,strong) UILabel *freezeLabel;
@property(nonatomic,strong) UIButton *buyButton;

@property(nonatomic,strong) OrderShowView *orderListView;

@property(nonatomic,copy) NSArray *currencyListArr;                  //弹出币种列表数组

@property (nonatomic, assign) double freezeAmount;                   //资产冻结金额
@property (nonatomic, assign) double currentRest;                    //当前余额
@property (nonatomic, strong) NSArray *balanceArr;                   //资产数组

@property (nonatomic,assign) double amount;                          //数量
@property (nonatomic,assign) double price;                           //价格
@property (nonatomic,assign) double totalCount;                      //换算

@property (nonatomic,strong) NSString *getCurrencyName;
@property (nonatomic,strong) NSString *payCurrencyName;

@property (nonatomic, strong) NSArray *exchangesBuy;                   //买入挂单列表
@property (nonatomic, strong) NSArray *exchangesSell;                   //卖出挂单列表

@end

@implementation TradingBuyScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupData];
}

-(void)setupView{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.headContentView];
    [self.view addSubview:self.bodyContentView];

    [self.headContentView addSubview:self.title1];
    [self.headContentView addSubview:self.titleImageLabel1];
    [self.headContentView addSubview:self.titleButton1];
    [self.headContentView addSubview:self.account1];
    [self.headContentView addSubview:self.title1];
    [self.headContentView addSubview:self.amountTextView];
    [self.headContentView addSubview:self.xLabel];
    [self.headContentView addSubview:self.priceTextField];
    [self.headContentView addSubview:self.equalButton];
    [self.headContentView addSubview:self.countLabel];

    [self.headContentView addSubview:self.title2];
    [self.headContentView addSubview:self.titleImageLabel2];
    [self.headContentView addSubview:self.titleButton2];
    [self.headContentView addSubview:self.account2];
    [self.headContentView addSubview:self.restAmountTitle];
    [self.headContentView addSubview:self.freezeTitle];
    [self.headContentView addSubview:self.restAmountLabel];
    [self.headContentView addSubview:self.freezeLabel];
    [self.headContentView  addSubview:self.buyButton];
    
    [self.bodyContentView addSubview:self.orderListView];
}

-(void)setupData{

    self.getCurrencyName = @"SDA";
    self.payCurrencyName = @"CNY";
    self.title1.text = @"买入SDA";
    self.account1.text = @"";
    self.title2.text = @"支出CNY";
    self.account2.text = @"";
    self.amountTextView.textField.text = @"";
    self.priceTextField.textField.text = @"";
    
    [self payQueryCounterpartyWithCurrency:@"CNY" isFirst:YES];
    
    NSString *am = @"0";
    NSString *currency = @"CNY";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",am,currency]];

    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:TEXT_COLOR
                    range:NSMakeRange(0, am.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:NAVIBAR_COLOR
                    range:NSMakeRange(am.length, currency.length+1)];
    self.countLabel.attributedText = attrStr;
    
    
    //请求全部币种
    self.currencyListArr = @[];
    [self requestCurrencyList];
}

-(void)refreshData{
    
}

#pragma mark - action
//根据资产列表查询买入币种对应
-(void)getQueryCounterpartyWithCurrency:(NSString *)currency{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *responseArr = SYSTEM_GET_(BALANCES);
    [responseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BalanceModel *model = [BalanceModel modelWithDict:obj];
        [arr addObject:model];
    }];
    self.balanceArr = arr;
    
    NSString *counterpartyStr = @"";
    for(int i = 0; i < self.balanceArr.count; i++){
        BalanceModel *model  = self.balanceArr[i];
        if([model.currency isEqualToString:currency]){
            counterpartyStr = model.counterparty;
        }
    }
//    //刷新地址
//    self.account1.text = counterpartyStr;
    [self getExchangeListsAction];
}

//根据资产列表查询支出币种对应
-(void)payQueryCounterpartyWithCurrency:(NSString *)currency isFirst:(BOOL)first{
    self.freezeAmount = [SYSTEM_GET_(FREEZE) doubleValue];
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *responseArr = SYSTEM_GET_(BALANCES);
    [responseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BalanceModel *model = [BalanceModel modelWithDict:obj];
        [arr addObject:model];
    }];
    self.balanceArr = arr;
    
    NSString *counterpartyStr = @"";
    NSString *restStr = @"0";
    for(int i = 0; i < self.balanceArr.count; i++){
        BalanceModel *model  = self.balanceArr[i];
        if([model.currency isEqualToString:currency]){
            counterpartyStr = model.counterparty;
            restStr = model.value;
        }
    }
    
    //刷新地址
//    self.account2.text = counterpartyStr;
    
    //刷新余额
    self.currentRest = [restStr doubleValue];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",restStr,self.payCurrencyName]];
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:TEXT_COLOR
                    range:NSMakeRange(0, restStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:NAVIBAR_COLOR
                    range:NSMakeRange(restStr.length, self.payCurrencyName.length+1)];
    self.restAmountLabel.attributedText = attrStr;
    
    //刷新冻结
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",[GlobalMethod formatDouble:self.freezeAmount],self.payCurrencyName]];
    
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                    value:TEXT_COLOR
                    range:NSMakeRange(0, [GlobalMethod formatDouble:self.freezeAmount].length)];
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                    value:NAVIBAR_COLOR
                    range:NSMakeRange([GlobalMethod formatDouble:self.freezeAmount].length, self.payCurrencyName.length+1)];
    self.freezeLabel.attributedText = attrStr1;
    [self countLabelCountAction];
    if(!first){
    [self getExchangeListsAction];
    }
}

-(void)countLabelCountAction{
    self.amount = [self.amountTextView.textField.text doubleValue];
    self.price = [self.priceTextField.textField.text doubleValue];
    self.totalCount = self.amount*self.price;
    NSString *countStr = [GlobalMethod formatDouble:self.totalCount];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",countStr,self.payCurrencyName]];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:TEXT_COLOR
                    range:NSMakeRange(0, countStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:NAVIBAR_COLOR
                    range:NSMakeRange(countStr.length, self.payCurrencyName.length+1)];
    self.countLabel.attributedText = attrStr;
}

-(void)buyButtonAction{
    if([self.payCurrencyName isEqualToString:self.getCurrencyName]){
        [self presentAlertWithTitle:@"相同币种不能转账" message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if(self.currentRest<=self.freezeAmount){
        [self presentAlertWithTitle:@"余额不足" message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if (self.totalCount>(self.currentRest-self.freezeAmount)){
        [self presentAlertWithTitle:@"余额不足" message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if (self.amountTextView.textField.text.length == 0){
        [self presentAlertWithTitle:@"买入单价不能为空" message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if (self.amountTextView.textField.text.length == 0){
        [self presentAlertWithTitle:@"买入数量不能为空" message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if (self.amount == 0){
        [self presentAlertWithTitle:@"买入数量不能为0" message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if (self.price == 0){
        [self presentAlertWithTitle:@"买入数量不能为0" message:@"" dismissAfterDelay:1.5 completion:nil];
    }else if (fmodf(self.totalCount*1000000, 1)!=0){
        [self presentAlertWithTitle:@"支出金额最多精确到小数点后6位" message:@"" dismissAfterDelay:1.5 completion:nil];
    }else{
        //支付密码
        PaymentSecretManager *manager = [PaymentSecretManager shareInstance];
        __weak TradingBuyScene *weakSelf = self;
        manager.PaymemtSecretCurrectBlock = ^(NSString *passWord) {
            [weakSelf requestBuyActionWithPassword:passWord];
        };
        [manager presentSecretScene];
    }
    
}

#pragma mark - request
-(void)requestCurrencyList{
    [HTTPRequestManager getAllCurrencyListsShowProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *data = responseObject;
        NSMutableArray *mArr = [NSMutableArray array];
        if(data.count > 0){
            for(int i = 0; i < data.count; i++){
                TradingCurrencyModel *model = [TradingCurrencyModel modelWithDict:data[i]];
                [mArr addObject:model];
                if([model.currency isEqualToString:@"CNY"]){
                    self.account2.text = model.counterparty;
                    [self getExchangeListsAction];
                }
            }
            self.currencyListArr = (NSArray *)mArr;
        }

    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        self.currencyListArr = @[];
    } error:^(NSString *content) {
        self.currencyListArr = @[];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.currencyListArr = @[];
    }];
}

-(void)requestBuyActionWithPassword:(NSString *)password{
    
    [HTTPRequestManager submitOrderWithWalletPassword:password paysCurrency:self.payCurrencyName paysCounterparty:self.account2.text paysValue:self.amountTextView.textField.text getsCurrency:self.getCurrencyName getCounterparty:self.account1.text getsValue:[GlobalMethod formatDouble:self.totalCount] type:@"buy" showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self presentAlertWithTitle:@"买入成功" message:@"" dismissAfterDelay:1.5 completion:nil];
        if(self.TradingBuySuccessBlock){
            self.TradingBuySuccessBlock();
        }
    } reLogin:^{
        [GlobalMethod loginOutAction];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self presentAlertWithTitle:@"请求错误" message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}

-(void)getExchangeListsAction{
    [HTTPRequestManager getExchangeListsWithBaseCurrency:self.getCurrencyName baseCounterparty:self.account1.text counterCurrency:self.payCurrencyName counterCounterparty:self.account2.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.exchangesBuy = responseObject[@"exchangesBuy"];
        self.exchangesSell = responseObject[@"exchangesSell"];
        [self.orderListView fefreshListWithExchangesBuy:self.exchangesBuy exchangesSell:self.exchangesSell];
    } reLogin:^{
        
    } warn:^(NSString *content) {
//        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self presentAlertWithTitle:@"请求失败" message:@"" dismissAfterDelay:1.5 completion:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    NSLog(@"%@",self.amountTextView.textField.text);
    NSLog(@"%@",self.priceTextField.textField.text);
    
    [self countLabelCountAction];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 当前输入的字符是'.'
    if ([string isEqualToString:@"."]) {
        
        // 已输入的字符串中已经包含了'.'或者""
        if ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""]) {
            
            return NO;
        } else {
            
            return YES;
        }
    } else {// 当前输入的不是'.'
        
        // 第一个字符是0时, 第二个不能再输入0
        if (textField.text.length == 1) {
            
            unichar str = [textField.text characterAtIndex:0];
            if (str == '0' && [string isEqualToString:@"0"]) {
                
                return NO;
            }
            
            if (str != '0' && str != '1') {// 1xx或0xx
                
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
        // 已输入的字符串中包含'.'
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

-(UIView *)headContentView{
    if(!_headContentView){
        _headContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kHeight(235))];
        _headContentView.backgroundColor = [UIColor whiteColor];
    }
    return _headContentView;
}

-(UIView *)bodyContentView{
    if(!_bodyContentView){
        _bodyContentView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight(245), WIDTH, CGRectGetHeight(self.view.frame)-kHeight(245))];
        _bodyContentView.backgroundColor = [UIColor whiteColor];
    }
    return _bodyContentView;
}

-(UILabel *)title1{
    if(!_title1){
        _title1 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(15), kHeight(20), kWidth(70), kHeight(20))];
        _title1.textColor = NAVIBAR_COLOR;
        _title1.font = [UIFont systemFontOfSize:16];
        _title1.textAlignment = NSTextAlignmentLeft;
    }
    return _title1;
}

-(UILabel *)titleImageLabel1{
    if(!_titleImageLabel1){
        _titleImageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(90), kHeight(20), kHeight(20), kHeight(20))];
        _titleImageLabel1.text = @"\U0000e654";
        _titleImageLabel1.font = KICON_FONT(24);
        _titleImageLabel1.textColor = TEXT_COLOR_LIGHT;
    }
    return _titleImageLabel1;
}

-(UIButton *)titleButton1{
    if(!_titleButton1){
        _titleButton1 = [[UIButton alloc] initWithFrame:CGRectMake(kWidth(15), kHeight(20), kWidth(70+kHeight(20)), kHeight(20))];
        [_titleButton1 addTarget:self action:@selector(titleButtin1Action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton1;
}

//选择买入币种
-(void)titleButtin1Action{
    CurrencySelectPopView *popView = [[CurrencySelectPopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) withArr:self.currencyListArr xPosition:kWidth(15) yPosition:self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height+kHeight(45)];
    __weak TradingBuyScene *weakSelf = self;
    popView.currencyBlock = ^(TradingCurrencyModel *model) {
        weakSelf.title1.text = [NSString stringWithFormat:@"买入%@",model.currency];
        weakSelf.account1.text = [model.currency isEqualToString:@"SDA"] ? @"" : model.counterparty;
        weakSelf.getCurrencyName = model.currency;
        [weakSelf getQueryCounterpartyWithCurrency:model.currency];
    };
    [popView showCurrencyListPopView];
}

-(UILabel *)account1{
    if(!_account1){
        _account1 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(15), kHeight(45), WIDTH/2-kWidth(30), kHeight(15))];
        _account1.textColor = TEXT_COLOR;
        _account1.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _account1.font = [UIFont systemFontOfSize:13];
        _account1.textAlignment = NSTextAlignmentLeft;
    }
    return _account1;
}

-(InputAmountView *)amountTextView{
    if(!_amountTextView){
        _amountTextView = [[InputAmountView alloc] initWithFrame:CGRectMake(kWidth(15), kHeight(75), WIDTH/2-kWidth(30), kHeight(35))];
        _amountTextView.textField.placeholder = @"数量";
        _amountTextView.textField.delegate = self;
        __weak TradingBuyScene *weakSelf = self;
        _amountTextView.textAmountChangeBlock = ^{
            [weakSelf countLabelCountAction];
        };
    }
    return _amountTextView;
}

-(UILabel *)xLabel{
    if(!_xLabel){
        _xLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(15), kHeight(105), WIDTH/2-kWidth(30), kHeight(30))];
        _xLabel.textColor = NAVIBAR_COLOR;
        _xLabel.text = @"×";
        _xLabel.font = [UIFont systemFontOfSize:15];
        _xLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xLabel;
}

-(InputAmountView *)priceTextField{
    if(!_priceTextField){
        _priceTextField = [[InputAmountView alloc] initWithFrame:CGRectMake(kWidth(15), kHeight(135), WIDTH/2-kWidth(30), kHeight(35))];
        _priceTextField.textField.placeholder = @"单价";
        _priceTextField.textField.delegate = self;
        __weak TradingBuyScene *weakSelf = self;
        _priceTextField.textAmountChangeBlock = ^{
            [weakSelf countLabelCountAction];
        };
    }
    return _priceTextField;
}

-(UIButton *)equalButton{
    if(!_equalButton){
        _equalButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth(15)+5, kHeight(185), kHeight(35), kHeight(30))];
        [_equalButton setImage:[UIImage imageNamed:@"count_equal"] forState:UIControlStateNormal];
    }
    return _equalButton;
}

-(UILabel *)countLabel{
    if(!_countLabel){
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(55), kHeight(185), WIDTH-kWidth(80), kHeight(30))];
        _countLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _countLabel;
}

-(UILabel *)title2{
    if(!_title2){
        _title2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2+kWidth(15), kHeight(20), kWidth(70), kHeight(20))];
        _title2.textColor = NAVIBAR_COLOR;
        _title2.font = [UIFont systemFontOfSize:16];
        _title2.textAlignment = NSTextAlignmentLeft;
    }
    return _title2;
}

-(UILabel *)titleImageLabel2{
    if(!_titleImageLabel2){
        _titleImageLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2+kWidth(90), kHeight(20), kHeight(20), kHeight(20))];
        _titleImageLabel2.text = @"\U0000e654";
        _titleImageLabel2.font = KICON_FONT(24);
        _titleImageLabel2.textColor = TEXT_COLOR_LIGHT;
    }
    return _titleImageLabel2;
}

-(UIButton *)titleButton2{
    if(!_titleButton2){
        _titleButton2 = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2+kWidth(15), kHeight(20), kWidth(70+kHeight(20)), kHeight(20))];
        [_titleButton2 addTarget:self action:@selector(titleButtin2Action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton2;
}

//选择卖出币种
-(void)titleButtin2Action{
    CurrencySelectPopView *popView = [[CurrencySelectPopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) withArr:self.currencyListArr xPosition:kWidth(15)+WIDTH/2 yPosition:self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height+kHeight(45)];
    __weak TradingBuyScene *weakSelf = self;
    popView.currencyBlock = ^(TradingCurrencyModel *model) {
        weakSelf.title2.text = [NSString stringWithFormat:@"卖出%@",model.currency];
        weakSelf.account2.text = [model.currency isEqualToString:@"SDA"] ? @"" : model.counterparty;
        weakSelf.payCurrencyName =  model.currency;
        [weakSelf payQueryCounterpartyWithCurrency:model.currency isFirst:NO];
    };
    [popView showCurrencyListPopView];

}

-(UILabel *)account2{
    if(!_account2){
        _account2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2+kWidth(15), kHeight(45), WIDTH/2-kWidth(30), kHeight(15))];
        _account2.textColor = TEXT_COLOR;
        _account2.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _account2.font = [UIFont systemFontOfSize:13];
        _account2.textAlignment = NSTextAlignmentLeft;
    }
    return _account2;
}

-(UILabel *)restAmountTitle{
    if(!_restAmountTitle){
        _restAmountTitle = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2+kWidth(15), kHeight(75), kWidth(45), kHeight(17.5))];
        _restAmountTitle.text = @"余额：";
        _restAmountTitle.font = [UIFont systemFontOfSize:14];
        _restAmountTitle.textAlignment = NSTextAlignmentLeft;
        _restAmountTitle.textColor = NAVIBAR_COLOR;
    }
    return _restAmountTitle;
}

-(UILabel *)freezeTitle{
    if(!_freezeTitle){
        _freezeTitle = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2+kWidth(15), kHeight(92.5), kWidth(45), kHeight(17.5))];
        _freezeTitle.text = @"冻结：";
        _freezeTitle.font = [UIFont systemFontOfSize:14];
        _freezeTitle.textAlignment = NSTextAlignmentLeft;
        _freezeTitle.textColor = NAVIBAR_COLOR;
    }
    return _freezeTitle;
}

-(UILabel *)restAmountLabel{
    if(!_restAmountLabel){
        _restAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2+kWidth(60), kHeight(75), WIDTH/2-kWidth(75), kHeight(17.5))];
        _restAmountLabel.font = [UIFont systemFontOfSize:14];
        _restAmountLabel.textAlignment = NSTextAlignmentRight;
        _restAmountLabel.textColor = NAVIBAR_COLOR;
    }
    return _restAmountLabel;
}

-(UILabel *)freezeLabel{
    if(!_freezeLabel){
        _freezeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2+kWidth(60), kHeight(92.5), WIDTH/2-kWidth(75), kHeight(17.5))];
        _freezeLabel.font = [UIFont systemFontOfSize:14];
        _freezeLabel.textAlignment = NSTextAlignmentRight;
        _freezeLabel.textColor = NAVIBAR_COLOR;
    }
    return _freezeLabel;
}

-(UIButton *)buyButton{
    if(!_buyButton){
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2+kWidth(15), kHeight(135), WIDTH/2-kWidth(30), kHeight(35))];
        [_buyButton setTitle:@"买入" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _buyButton.backgroundColor = NAVIBAR_COLOR;
        _buyButton.layer.cornerRadius = (kHeight(35)-10)/2;
        _buyButton.layer.masksToBounds = YES;
        [_buyButton addTarget:self action:@selector(buyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}

-(OrderShowView *)orderListView{
    if(!_orderListView){
        _orderListView = [[OrderShowView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGRectGetHeight(self.bodyContentView.frame))];
        _orderListView.backgroundColor = [UIColor whiteColor];
    }
    return _orderListView;
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
