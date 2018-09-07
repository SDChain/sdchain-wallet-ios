//
//  BindMobileScene.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/21.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,BindType) {
    typeBind,
    typeRemoveBind
};

typedef NS_ENUM(NSInteger,AccountType) {
    typeMobile,
    typeEmail
};

@interface BindMobileScene : BaseViewController

@property(nonatomic,assign) BindType bindType;

@property(nonatomic,assign) AccountType accountType;

@end
