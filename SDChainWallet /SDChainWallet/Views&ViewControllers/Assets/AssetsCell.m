//
//  AssetsCell.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/30.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "AssetsCell.h"

@implementation AssetsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupCellWithModel:(BalanceModel *)model{
    self.titlelabel.text = model.currency;
    NSString *valueString = model.value;
    self.balanceAmount.text = [NSString stringWithFormat:@"%.6f",[valueString doubleValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
