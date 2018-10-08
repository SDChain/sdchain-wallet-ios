//
//  OrderShowCell.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/24.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "OrderShowCell.h"

@interface OrderShowCell ()


@end

@implementation OrderShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.amountLabel];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)priceLabel{
    if(!_priceLabel){
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(60), 0, (WIDTH-kWidth(60))/2, kHeight(25))];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:13];
    }
    return _priceLabel;
}

-(UILabel *)amountLabel{
    if(!_amountLabel){
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH-kWidth(60))/2+kWidth(60), 0, (WIDTH-kWidth(60))/2, kHeight(25))];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.font = [UIFont systemFontOfSize:13];
    }
    return _amountLabel;
}

@end
