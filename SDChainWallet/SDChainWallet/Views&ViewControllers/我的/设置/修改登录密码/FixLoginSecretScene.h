//
//  FixLoginSecretScene.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/1.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,FixLoginAccountType) {
    typeLoginMobile,
    typeLoginEmail
};

@interface FixLoginSecretScene : BaseViewController

@property(nonatomic,assign)FixLoginAccountType type;
@property(nonatomic,strong)NSString *accountStr;

@end
