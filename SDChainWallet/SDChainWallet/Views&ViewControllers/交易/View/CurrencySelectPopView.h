//
//  CurrencySelectPopView.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/23.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradingCurrencyModel.h"

@interface CurrencySelectPopView : UIView

@property(nonatomic,copy) void(^currencyBlock)(TradingCurrencyModel *);

-(instancetype)initWithFrame:(CGRect)frame withArr:(NSArray *)arr xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition;

-(void)showCurrencyListPopView;

@end
