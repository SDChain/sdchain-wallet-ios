//
//  NickNameScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/20.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "NickNameScene.h"
#import "Masonry.h"
#import "HTTPRequestManager.h"

@interface NickNameScene ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *nickNameTextfield;
@property(nonatomic,strong) UIButton *referButton;

@end

@implementation NickNameScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"设置昵称", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGusture];
    UIView *inputView = [[UIView alloc] init];
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(10));
        make.height.mas_equalTo(kHeight(50));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = NAVIBAR_COLOR;
    [inputView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
    
    [inputView addSubview:self.nickNameTextfield];
    [self.nickNameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(10);
        make.top.mas_equalTo(kHeight(5));
        make.height.mas_equalTo(kHeight(40));
    }];
    
    [self.view addSubview:self.referButton];
    [self.referButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(kHeight(40));
    }];
}

-(void)referAtion{
    [HTTPRequestManager updateNickNameWithNickName:self.nickNameTextfield.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        __weak NickNameScene *weakSelf = self;
            NSString *title = NSLocalizedStringFromTable(@"修改成功", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
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

-(void)hideKeyBoard{
    [self.nickNameTextfield resignFirstResponder];

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.nickNameTextfield.text.length > 0){
        self.referButton.backgroundColor = NAVIBAR_COLOR;
        self.referButton.enabled = YES;
    }else{
        self.referButton.backgroundColor = LINE_COLOR;
        self.referButton.enabled = NO;
    }
}

-(UITextField *)nickNameTextfield{
    if(!_nickNameTextfield){
        _nickNameTextfield = [[UITextField alloc] init];
        _nickNameTextfield.placeholder = self.nickName;
        _nickNameTextfield.delegate = self;
    }
    return _nickNameTextfield;
}

-(UIButton *)referButton{
    if(!_referButton){
        _referButton = [[UIButton alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"确定", @"guojihua", nil);
        [_referButton setTitle:title forState:UIControlStateNormal];
        [_referButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _referButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _referButton.layer.cornerRadius = 20.0;
        _referButton.layer.masksToBounds = YES;
        _referButton.backgroundColor = UNCLICK_COLOR;
        _referButton.enabled = NO;
        [_referButton addTarget:self action:@selector(referAtion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _referButton;
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
