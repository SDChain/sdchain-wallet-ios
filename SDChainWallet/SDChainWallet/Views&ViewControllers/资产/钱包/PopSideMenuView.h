//
//  PopSideMenuView.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/19.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EstablishCompleteBlock) (NSString *text);
typedef void(^LoginOutBlock) (void);
typedef void(^SelectedBlock) (WalletModel *model);

@interface PopSideMenuView : UIView

@property(nonatomic,strong)NSArray *wallets;

@property(nonatomic,copy) EstablishCompleteBlock block;

@property(nonatomic,copy) LoginOutBlock loginoutBlock;

@property(nonatomic,copy) SelectedBlock selectedBlock;


-(instancetype)initWithFrame:(CGRect)frame;


@end
