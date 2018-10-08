//
//  OrderShowView.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/24.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderShowView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

-(void)fefreshListWithExchangesBuy:(NSArray *)ExchangesBuy exchangesSell:(NSArray *)exchangesSell;


@end
