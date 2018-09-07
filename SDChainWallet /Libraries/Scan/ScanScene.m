//
//  ScanScene.m
//  HuiTongTingChe
//
//  Created by 钱伟成 on 2017/10/18.
//  Copyright © 2017年 HuiTong. All rights reserved.
//

#import "ScanScene.h"
#import "LBXAlertAction.h"
#import "ScanResultViewController.h"
#import "LBXScanVideoZoomView.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "CreateBarCodeViewController.h"


@interface ScanScene ()

@end

@implementation ScanScene

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarController.tabBar.hidden = YES;
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 49);
    NSString *title1 = NSLocalizedStringFromTable(@"相机启动中", @"guojihua", nil);
    NSString *title2 = NSLocalizedStringFromTable(@"扫一扫", @"guojihua", nil);
    self.cameraInvokeMsg = title1;
    self.title = title2;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self drawBottomItems];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//self.tabBarController.tabBar.hidden = NO;
//}

//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//     self.tabBarController.tabBar.hidden = NO;
//}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{

    
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以ZXing同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
//    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
 
    if([strResult containsString:@"account:"] ){
        if(self.type == typeAssetType){
            if(self.scanSceneWalletBlock){
                self.scanSceneWalletBlock([strResult substringFromIndex:8]);
            }
        }else if (self.type == typeAddfriendType){
            [self showNextVCWithScanResult:scanResult];
        }else if (self.type == typePrivateSecret){
            [self showNextVCWithScanResult:scanResult];
        }else if (self.type == typeLeadingIn){
            [self.navigationController popViewControllerAnimated:YES];
            if(self.scanSceneWalletBlock){
                self.scanSceneWalletBlock([strResult substringFromIndex:8]);
            }
        }
    }else if ([strResult containsString:@"privatekey:"]){
        if(self.type == typeAssetType){
            [self showNextVCWithScanResult:scanResult];
        }else if (self.type == typeAddfriendType){
            [self showNextVCWithScanResult:scanResult];
        }else if (self.type == typePrivateSecret){
            [self.navigationController popViewControllerAnimated:YES];
            if(self.scanScenePrivateBlock){
                self.scanScenePrivateBlock([strResult substringFromIndex:11]);
            }
        }else if(self.type == typeLeadingIn){
            [self.navigationController popViewControllerAnimated:YES];
            if(self.scanScenePrivateBlock){
                self.scanScenePrivateBlock([strResult substringFromIndex:11]);
            }
        }
        else{
            [self showNextVCWithScanResult:scanResult];
        }

    }else if ([strResult containsString:@"userId:"]){
        if(self.type == typeAssetType){
            if(self.scanSceneFriendBlock){
                self.scanSceneFriendBlock([strResult substringFromIndex:7]);
            }
        }else if (self.type == typeAddfriendType){
//            [self.navigationController popViewControllerAnimated:YES];
            if(self.scanSceneFriendBlock){
                self.scanSceneFriendBlock([strResult substringFromIndex:7]);
            }
        }else{
            [self showNextVCWithScanResult:scanResult];
        }
    }else{
        [self showNextVCWithScanResult:scanResult];
    }
    
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...
    
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult buttonsStatement:@[@"知道了"] chooseBlock:^(NSInteger buttonIdx) {
        
        [weakSelf reStartDevice];
    }];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    ScanResultViewController *vc = [ScanResultViewController new];
    vc.imgScan = strResult.imgScanned;
    
    vc.strScan = strResult.strScanned;
    
    vc.strCodeType = strResult.strBarCodeType;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)- kHeight(164),
                                                                   CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)*2/3, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnFlash setImage:[UIImage imageNamed:@"saoyisao_shanguangdeng"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/3, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"saoyisao_xiangce"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"saoyisao_xiangce"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnMyQR = [[UIButton alloc]init];
    _btnMyQR.bounds = _btnFlash.bounds;
    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    //    [_bottomItemsView addSubview:_btnMyQR];
    
}

//打开相册
- (void)openPhoto
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"saoyisao_guandeng"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"saoyisao_shanguangdeng"] forState:UIControlStateNormal];
}



- (void)myQRCode
{
    CreateBarCodeViewController *vc = [CreateBarCodeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
