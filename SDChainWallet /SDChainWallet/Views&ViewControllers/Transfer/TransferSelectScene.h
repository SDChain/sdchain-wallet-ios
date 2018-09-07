//
//  TransferSelectScene.h
//  CulturalExchange
//
//  Created by 钱伟成 on 2018/5/28.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceModel.h"
@interface TransferSelectScene : BaseViewController

@property(nonatomic,strong) NSArray *dataArr;

@property(nonatomic,copy)void (^transferSelectBlock)(BalanceModel *);

@end
