//
//  TradingCurrentCell.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/24.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradingCurrentCell : UITableViewCell

@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *buyLabel;
@property(nonatomic,strong)UILabel *sellLabel;
@property(nonatomic,strong)UIButton *cancleOrderButtton;

@end
