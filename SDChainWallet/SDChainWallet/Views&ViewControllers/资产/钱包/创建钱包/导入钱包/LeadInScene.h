//
//  LeadInScene.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/6/8.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "BaseViewController.h"
#import "WalletModel.h"

@interface LeadInScene : BaseViewController

@property(nonatomic,strong)NSString *password;

@property(nonatomic,strong) void (^leadingSuccessBlock)(WalletModel *model);

@end
