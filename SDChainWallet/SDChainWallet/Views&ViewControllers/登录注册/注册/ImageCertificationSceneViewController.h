//
//  ImageCertificationSceneViewController.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/6/8.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCertificationSceneViewController : BaseViewController

@property(nonatomic,copy) void (^certifiSuccessBlock)(NSString *imageCode,NSString*machineId);

@end
