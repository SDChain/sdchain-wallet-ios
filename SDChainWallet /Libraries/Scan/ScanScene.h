//
//  ScanScene.h
//  HuiTongTingChe
//
//  Created by 钱伟成 on 2017/10/18.
//  Copyright © 2017年 HuiTong. All rights reserved.
//

#import <LBXScanViewController.h>

typedef NS_ENUM(NSInteger,SceneType) {
    typeAssetType,
    typeAddfriendType,
    typePrivateSecret,
    typeLeadingIn
};

@interface ScanScene : LBXScanViewController

#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;
//我的二维码
@property (nonatomic, strong) UIButton *btnMyQR;

@property(nonatomic,copy)void (^scanSceneWalletBlock)(NSString *);

@property(nonatomic,copy)void (^scanSceneFriendBlock)(NSString *);

@property(nonatomic,copy)void (^scanScenePrivateBlock)(NSString *);

@property(nonatomic,assign) SceneType type;

@end
