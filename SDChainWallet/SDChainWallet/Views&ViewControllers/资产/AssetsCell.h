//
//  AssetsCell.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/30.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceModel.h"

@interface AssetsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceAmount;

-(void)setupCellWithModel:(BalanceModel *)model;

@end
