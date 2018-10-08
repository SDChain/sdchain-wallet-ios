//
//  WalletAdditionSelectScene.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/6/8.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"

@interface WalletAdditionSelectScene : BaseViewController

@property(nonatomic,strong) void (^createWalletBlock)(NSString *account);
@property(nonatomic,strong) void (^leadinWalletBlock)(WalletModel *);

@end
