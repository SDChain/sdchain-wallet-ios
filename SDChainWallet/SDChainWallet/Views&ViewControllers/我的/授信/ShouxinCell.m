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
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",model.limit,model.currency];
    self.accountLabel.text = [NSString stringWithFormat:@"%@",model.counterparty];
    UIImage *statusImage = [model.trusted isEqualToString:@"1"] ? [UIImage imageNamed:@"shouxin_trusted"]:[UIImage imageNamed:@"shouxin_untrust"];
    self.statusImageView.image = statusImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kWidth(25));
        make.centerY.equalTo(self.mas_centerY);
        make.right.mas_equalTo(kWidth(15));
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
