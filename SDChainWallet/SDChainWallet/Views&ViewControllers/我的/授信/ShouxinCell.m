//
//  ShouxinCell.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/1.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "ShouxinCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"


@implementation ShouxinCell

-(void)setupCellWithModel:(TrustListModel *)model{
    [self.iocnImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"assets_icon"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.currency];
    self.accountLabel.text = [NSString stringWithFormat:@"%@",model.counterparty];
    UIColor *statusColor = [model.trusted isEqualToString:@"1"] ? RGB(255, 93, 67):NAVIBAR_COLOR;
    self.statusLabel.backgroundColor = statusColor;
    self.statusLabel.text = [model.trusted isEqualToString:@"1"] ? @"取消授信":@"授信";
    self.statusLabel.layer.cornerRadius = 5;
    self.statusLabel.layer.masksToBounds = YES;
}


- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
