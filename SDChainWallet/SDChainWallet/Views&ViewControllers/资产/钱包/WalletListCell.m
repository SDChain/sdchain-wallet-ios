//
//  WalletListCell.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/20.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "WalletListCell.h"

@implementation WalletListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupCellWithModel:(WalletModel *)model{
    if([model.isDefault isEqualToString:@"1"]){
        self.headIconImageView.image = [UIImage imageNamed:@"zichan_qianbao_default"];
    }else{
        self.headIconImageView.image = [UIImage imageNamed:@"zichan_qianbao"];
    }
    self.walletNameLabel.text = model.name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
