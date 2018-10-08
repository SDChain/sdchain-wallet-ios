//
//  EstablishWalletScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/20.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "EstablishWalletScene.h"

@interface EstablishWalletScene ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *cueView;
@property (weak, nonatomic) IBOutlet UILabel *publicSecretStringLabel;
@property (weak, nonatomic) IBOutlet UIButton *publicFuzhiButton;
@property (weak, nonatomic) IBOutlet UIImageView *publicQRImageView;

@property (weak, nonatomic) IBOutlet UILabel *privateStringLabel;
@property (weak, nonatomic) IBOutlet UIButton *privateFuzhiButton;
@property (weak, nonatomic) IBOutlet UIImageView *privateQRImageView;

@property (nonatomic,strong)UILongPressGestureRecognizer *gesture1;
@property (nonatomic,strong)UILongPressGestureRecognizer *gesture2;

@property (weak, nonatomic) IBOutlet UILabel *changanbaocunLabel;
@property (weak, nonatomic) IBOutlet UILabel *gongyaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *siyaoLabel;




@end

@implementation EstablishWalletScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"新钱包", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.publicSecretStringLabel.text = self.account;
    self.publicQRImageView.image = [GlobalMethod codeImageWithString:self.account size:WIDTH/2 centerImage:[UIImage imageNamed:@"personal_publickey"]];
    self.gesture1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)];
    self.gesture1.minimumPressDuration = 1.0;
    self.gesture1.delegate = self;
    self.publicQRImageView.userInteractionEnabled = YES;
    [self.publicQRImageView addGestureRecognizer:self.gesture1];
    
    self.privateStringLabel.text = self.secret;
    self.privateQRImageView.image = [GlobalMethod codeImageWithString:self.secret size:WIDTH/2 centerImage:[UIImage imageNamed:@"personal_privicykey"]];
    self.gesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)];
    self.gesture2.minimumPressDuration = 1.0;
    self.gesture2.delegate = self;
    self.privateQRImageView.userInteractionEnabled = YES;
    [self.privateQRImageView addGestureRecognizer:self.gesture2];
    
    NSString *title1 = NSLocalizedStringFromTable(@"长按保存公钥和私钥，请及时备份好自己的公钥和私钥并妥善保管", @"guojihua", nil);
    NSString *title2 = NSLocalizedStringFromTable(@"公钥", @"guojihua", nil);
    NSString *title3 = NSLocalizedStringFromTable(@"私钥", @"guojihua", nil);
        NSString *title4 = NSLocalizedStringFromTable(@"复制", @"guojihua", nil);
    
    self.changanbaocunLabel.text = title1;
    self.gongyaoLabel.text = title2;
    self.siyaoLabel.text = title3;
    [self.publicFuzhiButton setTitle:title4 forState:UIControlStateNormal];
    [self.privateFuzhiButton setTitle:title4 forState:UIControlStateNormal];
    
}

//-(void)baocunXiangceAction1{
//    [GlobalMethod loadImageFinished:self.publicQRImageView.image baocunSuccess:^{
//        [self presentAlertWithTitle:@"保存成功" message:@"" dismissAfterDelay:1.5 completion:nil];
//    }];
//}
//
//
//-(void)baocunXiangceAction2{
//    [GlobalMethod loadImageFinished:self.privateQRImageView.image baocunSuccess:^{
//        [self presentAlertWithTitle:@"保存成功" message:@"" dismissAfterDelay:1.5 completion:nil];
//    }];
//}



- (IBAction)fuzhiAction1:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.publicSecretStringLabel.text;
    NSString *title = NSLocalizedStringFromTable(@"已复制到粘贴板", @"guojihua", nil);
    [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
}
- (IBAction)fuzhiActon2:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.privateStringLabel.text;
    NSString *title = NSLocalizedStringFromTable(@"已复制到粘贴板", @"guojihua", nil);
    [self presentAlertWithTitle:title message:@"" dismissAfterDelay:1.5 completion:nil];
}

// 允许多个手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark 长按手势弹出警告视图确认
-(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture

{
    
    if(gesture.state==UIGestureRecognizerStateBegan)
        
    {
            NSString *bancuntupian = NSLocalizedStringFromTable(@"保存图片", @"guojihua", nil);
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:bancuntupian message:nil preferredStyle:UIAlertControllerStyleAlert];
        NSString *quxiao = NSLocalizedStringFromTable(@"取消", @"guojihua", nil);
        NSString *queren = NSLocalizedStringFromTable(@"确认", @"guojihua", nil);
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:quxiao style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            

        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:queren style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            

            
            UIImage *img;
            if(gesture == self.gesture1){
                img = self.publicQRImageView.image;
            }
            else if (gesture == self.gesture2){
                img = self.privateQRImageView.image;
            }
            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(img,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
            

            
        }];
        
        [alertControl addAction:cancel];
        [alertControl addAction:confirm];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }
    
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo

{
    
    NSString*message = @"";
    
    NSString *baocunchenggong = NSLocalizedStringFromTable(@"保存成功", @"guojihua", nil);
    
    if(!error) {
        
        message = baocunchenggong;
        
        NSString *tishi = NSLocalizedStringFromTable(@"提示", @"guojihua", nil);
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:tishi message:message preferredStyle:UIAlertControllerStyleAlert];
        NSString *queding = NSLocalizedStringFromTable(@"确定", @"guojihua", nil);
        UIAlertAction *action = [UIAlertAction actionWithTitle:queding style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else
        
    {
        
        message = [error description];
        
        NSString *tishi = NSLocalizedStringFromTable(@"提示", @"guojihua", nil);
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:tishi message:message preferredStyle:UIAlertControllerStyleAlert];
        NSString *queding = NSLocalizedStringFromTable(@"确定", @"guojihua", nil);
        UIAlertAction *action = [UIAlertAction actionWithTitle:queding style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
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
