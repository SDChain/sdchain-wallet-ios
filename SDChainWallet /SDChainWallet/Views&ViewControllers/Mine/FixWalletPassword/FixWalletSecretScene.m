//
//  FixWalletSecretScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/21.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "FixWalletSecretScene.h"
#import "Masonry.h"
#import "HTTPRequestManager.h"
#import "FixWalletForgetSecretScene.h"

@interface FixWalletSecretScene ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *inputView;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIView *lineView3;
@property(nonatomic,strong)UIView *lineView4;
@property(nonatomic,strong)UITextField *textField1;
@property(nonatomic,strong)UITextField *textField2;
@property(nonatomic,strong)UITextField *textField3;
@property(nonatomic,strong)UIButton *confirmButton;

@end

@implementation FixWalletSecretScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    NSString *title = NSLocalizedStringFromTable(@"修改钱包密码1", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    NSString *title1 = NSLocalizedStringFromTable(@"忘记密码", @"guojihua", nil);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title1 style:UIBarButtonItemStylePlain target:self action:@selector(forgetSecretAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.confirmButton];
    [self.inputView addSubview:self.lineView1];
    [self.inputView addSubview:self.lineView2];
    [self.inputView addSubview:self.lineView3];
    [self.inputView addSubview:self.lineView4];
    [self.inputView addSubview:self.textField1];
    [self.inputView addSubview:self.textField2];
    [self.inputView addSubview:self.textField3];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(10));
        make.height.mas_equalTo(kHeight(150));
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(40));
        make.right.mas_equalTo(kWidth(-40));
        make.height.mas_equalTo(kHeight(40));
        make.top.mas_equalTo(kHeight(200));
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(1));
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(kWidth(10));
        make.height.mas_equalTo(kHeight(1));
        make.top.mas_equalTo(kHeight(49.5));
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(kWidth(10));
        make.height.mas_equalTo(kHeight(1));
        make.top.mas_equalTo(kHeight(99.5));
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(1));
        make.bottom.mas_equalTo(0);
    }];
    
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(10));
        make.top.mas_equalTo(kHeight(5));
        make.height.mas_equalTo(kHeight(40));
        make.right.mas_equalTo(-30);
    }];
    
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(10));
        make.top.mas_equalTo(kHeight(55));
        make.height.mas_equalTo(kHeight(40));
        make.right.mas_equalTo(-30);
    }];
    
    [self.textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(10));
        make.top.mas_equalTo(kHeight(105));
        make.height.mas_equalTo(kHeight(40));
        make.right.mas_equalTo(-30);
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:gesture];

}

#pragma mark - action
-(void)forgetSecretAction{
    FixWalletForgetSecretScene *scene = [[FixWalletForgetSecretScene alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
}

-(void)confirmAction{
    [self requestFixWalletSecret];
}

-(void)hideKeyBoard{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textField3 resignFirstResponder];
}

-(void)requestFixWalletSecret{
    if(![self.textField2.text isEqualToString:self.textField3.text]){
        NSString *title = NSLocalizedStringFromTable(@"两次密码输入不一致", @"guojihua", nil);
        [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }else{
        [HTTPRequestManager fixWalletSecretWithId:SYSTEM_GET_(USER_ID) userAccountId:SYSTEM_GET_(USERACCOUNTID) apptoken:SYSTEM_GET_(APPTOKEN) walletPassword:self.textField1.text newWalletPassword:self.textField2.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *title = NSLocalizedStringFromTable(@"修改成功", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
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
    

    
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;


}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    if(self.textField1.text.length == 6 && self.textField2.text.length == 6 && self.textField3.text.length == 6){
        self.confirmButton.backgroundColor = NAVIBAR_COLOR;
        self.confirmButton.enabled = YES;
    }
    else{
        self.confirmButton.backgroundColor = UNCLICK_COLOR;
        self.confirmButton.enabled = NO;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
            return NO;
        }
    return YES;
}

#pragma mark - getter
-(UIView *)inputView{
    if(!_inputView){
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = [UIColor whiteColor];
    }
    return _inputView;
}

-(UIView *)lineView1{
    if(!_lineView1){
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = LINE_COLOR;
    }
    return _lineView1;
}

-(UIView *)lineView2{
    if(!_lineView2){
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = LINE_COLOR;
    }
    return _lineView2;
}

-(UIView *)lineView3{
    if(!_lineView3){
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = LINE_COLOR;
    }
    return _lineView3;
}

-(UIView *)lineView4{
    if(!_lineView4){
        _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = LINE_COLOR;
    }
    return _lineView4;
}

-(UITextField *)textField1{
    if(!_textField1){
        _textField1 = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"原密码", @"guojihua", nil);
        _textField1.placeholder = title;
        _textField1.font = [UIFont systemFontOfSize:15];
        _textField1.keyboardType  = UIKeyboardTypeNumberPad;
        _textField1.tag = 1001;
        _textField1.secureTextEntry = YES;
        _textField1.delegate = self;
    }
    return _textField1;
}

-(UITextField *)textField2{
    if(!_textField2){
        _textField2 = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"新密码", @"guojihua", nil);
        _textField2.placeholder = title;
        _textField2.font = [UIFont systemFontOfSize:15];
        _textField2.keyboardType  = UIKeyboardTypeNumberPad;
        _textField2.tag = 1002;
        _textField2.secureTextEntry = YES;
        _textField2.delegate = self;
    }
    return _textField2;
}

-(UITextField *)textField3{
    if(!_textField3){
        _textField3 = [[UITextField alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"确认密码", @"guojihua", nil);
        _textField3.placeholder = title;
        _textField3.font = [UIFont systemFontOfSize:15];
        _textField3.keyboardType  = UIKeyboardTypeNumberPad;
        _textField3.tag = 1003;
        _textField3.secureTextEntry = YES;
        _textField3.delegate = self;
    }
    return _textField3;
}

-(UIButton *)confirmButton{
    if(!_confirmButton){
       _confirmButton = [[UIButton alloc] init];
        _confirmButton.backgroundColor = UNCLICK_COLOR;
        NSString *title = NSLocalizedStringFromTable(@"确定", @"guojihua", nil);
        [_confirmButton setTitle:title forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = kHeight(15);
        [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
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
