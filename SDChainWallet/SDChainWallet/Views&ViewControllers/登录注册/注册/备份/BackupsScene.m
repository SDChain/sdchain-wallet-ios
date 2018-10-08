//
//  BackupsScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/8/24.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "BackupsScene.h"
#import "UIImage+EasyExtend.h"

@interface BackupsScene ()
@property (weak, nonatomic) IBOutlet UILabel *publicSecretStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *privateStringLabel;
@property (weak, nonatomic) IBOutlet UIImageView *publicQRImageView;
@property (weak, nonatomic) IBOutlet UIImageView *privateQRImageView;
@property (nonatomic,assign) BOOL firstImage;
@end

@implementation BackupsScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithTitle:NSLocalizedStringFromTable(@"备份", @"guojihua", nil)];
    [self setupNavi];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage * image = [UIImage imageWithColor:NAVIBAR_COLOR];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    // 设置导航栏文字颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIImage * image = [UIImage imageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    // 设置导航栏文字颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

-(void)setupNavi{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回登录" style:UIBarButtonItemStylePlain target:self action:@selector(backLoginAction)];
    self.navigationItem.rightBarButtonItem = leftItem;
}

-(void)backLoginAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupView{
    self.firstImage = YES;
    self.publicSecretStringLabel.text = self.account;
    self.publicQRImageView.image = [GlobalMethod codeImageWithString:self.account size:WIDTH/2 centerImage:[UIImage imageNamed:@"personal_publickey"]];
    
    self.privateStringLabel.text = self.secret;
    self.privateQRImageView.image = [GlobalMethod codeImageWithString:[NSString stringWithFormat:@"privatekey:%@",self.secret] size:WIDTH/2 centerImage:[UIImage imageNamed:@"personal_privicykey"]];
    
    
    
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo

{
    
    NSString*message = @"";
    
    if(!error) {
        
        if(self.firstImage){
            self.firstImage = NO;
            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(self.privateQRImageView.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        }else{
            message = @"备份成功";
            
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertControl addAction:action];
            
            [self presentViewController:alertControl animated:YES completion:nil];
        }
        
        
        
    }else
        
    {
        
        message = [error description];
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }
    
}


//备份
- (IBAction)beifenButtonAction:(id)sender {
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        
        UIImage *img;
        
        img = self.publicQRImageView.image;
        
        // 保存图片到相册
        UIImageWriteToSavedPhotosAlbum(img,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        
    }];
    
    [alertControl addAction:cancel];
    [alertControl addAction:confirm];
    
    [self presentViewController:alertControl animated:YES completion:nil];
    
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
