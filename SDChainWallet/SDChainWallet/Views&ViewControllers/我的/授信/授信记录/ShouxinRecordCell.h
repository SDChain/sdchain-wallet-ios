//
//  ShouxinRecordCell.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/29.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouxinRecordModel.h"

@interface ShouxinRecordCell : UITableViewCell

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *accountLabel;

-(void)setupCellWithModel:(ShouxinRecordModel *)model;

@end
