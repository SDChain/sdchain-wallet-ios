//
//  ImageCertificationSceneViewController.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/6/8.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "ImageCertificationSceneViewController.h"
#import "HTTPRequestManager.h"
#import "Masonry.h"
#import "UIDevice+COD.h"

@interface ImageCertificationSceneViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *textBackView;
@property (weak, nonatomic) IBOutlet UITextField *certificationTextField;
@property (weak, nonatomic) IBOutlet UILabel *psLabel;


@property(nonatomic,strong) NSString *machineId;

@end

@implementation ImageCertificationSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

//    self.machineId = [[UIDevice currentDevice] cod_uuid];
    [self request];
    
    NSString *title1 = NSLocalizedStringFromTable(@"提示：区分大小写", @"guojihua", nil);
    NSString *title2 = NSLocalizedStringFromTable(@"刷新", @"guojihua", nil);
    NSString *title3 = NSLocalizedStringFromTable(@"验证码", @"guojihua", nil);
    self.psLabel.text = title1;
    [self.refreshButton setTitle:title2 forState:UIControlStateNormal];
    self.certificationTextField.placeholder = title3;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)request{
    [HTTPRequestManager getRandomCodePicWithMachineId:self.machineId showProgress:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.imageView.image = [GlobalMethod getImageWithBase64StringWithString:responseObject[@"imagestr"]];
        self.machineId = responseObject[@"machineId"];
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *title = NSLocalizedStringFromTable(@"请求失败", @"guojihua", nil);
    [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
    }];

}

- (IBAction)refreshAction:(id)sender {
    self.certificationTextField.text = @"";
    self.imageView.image = [UIImage imageNamed:@""];
    [self request];
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.certificationTextField.text.length == 6){
        if(self.certifiSuccessBlock){
            self.certifiSuccessBlock(self.certificationTextField.text,self.machineId);
        }
        [self.navigationController popViewControllerAnimated:YES];
//        self.confirmButton.backgroundColor = NAVIBAR_COLOR;
//        self.confirmButton.enabled = YES;
    }else{
//        self.confirmButton.backgroundColor = UNCLICK_COLOR;
//        self.confirmButton.enabled = NO;
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
