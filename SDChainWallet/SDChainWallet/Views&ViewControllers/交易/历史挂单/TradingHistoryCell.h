//
//  TradingHistoryCell.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/23.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradingHistoryCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *buyLabel;
@property(nonatomic,strong)UILabel *sellLabel;

-(void)setupCellWithDict:(NSDictionary *)dict;

@end
