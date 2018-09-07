//
//  CertificationScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/20.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "CertificationScene.h"
#import "HTTPRequestManager.h"
#import "Masonry.h"

@interface CertificationScene ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *inputView;

@property(nonatomic,strong)UIView *lineView1;

@property(nonatomic,strong)UIView *lineView2;

@property(nonatomic,strong)UIView *lineView3;

@property(nonatomic,strong)UITextField *trueNameTextField;

@property(nonatomic,strong)UITextField *IDCardCodeTextField;

@property(nonatomic,strong)UILabel *warningLabel;

@property(nonatomic,strong)UIButton *confirmButton;

@end

@implementation CertificationScene

- (void)viewDidLoad {
    [super viewDidLoad];
     NSString *title = NSLocalizedStringFromTable(@"实名认证", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.warningLabel];
    [self.view addSubview:self.confirmButton];
    
    [self.inputView addSubview:self.lineView1];
    [self.inputView addSubview:self.lineView2];
    [self.inputView addSubview:self.lineView3];
    [self.inputView addSubview:self.trueNameTextField];
    [self.inputView addSubview:self.IDCardCodeTextField];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kHeight(10));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(kHeight(100));
    }];
    
    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(10);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
//        make.height.mas_equalTo(15);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kHeight(40));
        make.right.mas_equalTo(kHeight(-40));
        make.top.equalTo(self.inputView.mas_bottom).offset(kHeight(50));
        make.height.mas_equalTo(kHeight(40));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(0.6));
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(0.6));
        make.centerY.equalTo(self.inputView.mas_centerY);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kHeight(0.6));
    }];
    
    [self.trueNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(kWidth(10));
        make.top.mas_equalTo(kHeight(5));
        make.height.mas_equalTo(40);
    }];
    
    [self.IDCardCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(kWidth(10));
        make.bottom.mas_equalTo(kHeight(-5));
        make.height.mas_equalTo(40);
    }];
    
}

-(void)requestRealNameCertification{
//    if(self.trueNameTextField.text.length == 0){
//        [self presentAlertWithTitle:@"请输入姓名" message:@"" dismissAfterDelay:1.5 completion:nil];
//    }
//    else if (![GlobalMethod validateIDCardNumber:self.IDCardCodeTextField.text]){
//        [self presentAlertWithTitle:@"请输入正确的身份证号" message:@"" dismissAfterDelay:1.5 completion:nil];
//    }
//    else{
        [HTTPRequestManager realNameCertificationWithIdCode:self.IDCardCodeTextField.text realName:self.trueNameTextField.text showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            __weak CertificationScene *weakSelf = self;
            NSString *title = NSLocalizedStringFromTable(@"认证成功", @"guojihua", nil);
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
            NSString *title = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
            [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
        }];
//    }
    

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.trueNameTextField.text > 0 && [GlobalMethod validateIDCardNumber:self.IDCardCodeTextField.text]){
        self.confirmButton.backgroundColor = NAVIBAR_COLOR;
        self.confirmButton.enabled = YES;
    }else{
        self.confirmButton.backgroundColor = UNCLICK_COLOR;
        self.confirmButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(UITextField *)trueNameTextField{
    if(!_trueNameTextField){
        _trueNameTextField = [[UITextField alloc] init];
        _trueNameTextField.delegate = self;
        NSString *title = NSLocalizedStringFromTable(@"请输入真实姓名", @"guojihua", nil);
        _trueNameTextField.placeholder = title;
    }
    return _trueNameTextField;
}

-(UITextField *)IDCardCodeTextField{
    if(!_IDCardCodeTextField){
        _IDCardCodeTextField = [[UITextField alloc] init];
        _IDCardCodeTextField.delegate = self;
        NSString *title = NSLocalizedStringFromTable(@"请输入身份证号", @"guojihua", nil);
        _IDCardCodeTextField.placeholder = title;
        _IDCardCodeTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _IDCardCodeTextField;
}

-(UILabel *)warningLabel{
    if(!_warningLabel){
        _warningLabel = [[UILabel alloc] init];
        _warningLabel.font = [UIFont systemFontOfSize:12];
        _warningLabel.numberOfLines = 0;
        _warningLabel.textColor = [UIColor redColor];
        NSString *title = NSLocalizedStringFromTable(@"注：请仔细核对好自己的身份信息，一经提交，不得修改", @"guojihua", nil);
        _warningLabel.text = title;
    }
    return _warningLabel;
}

-(UIButton *)confirmButton{
    if(!_confirmButton){
        _confirmButton = [[UIButton alloc] init];
        NSString *title = NSLocalizedStringFromTable(@"确定", @"guojihua", nil);
        [_confirmButton setTitle:title forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 15;
        _confirmButton.enabled = NO;
        [_confirmButton addTarget:self action:@selector(requestRealNameCertification) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.backgroundColor = UNCLICK_COLOR;
    }
    return _confirmButton;
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
