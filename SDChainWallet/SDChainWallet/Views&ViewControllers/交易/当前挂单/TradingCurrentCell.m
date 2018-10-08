//
//  TradingCurrentCell.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/24.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "TradingCurrentCell.h"
#import "Masonry.h"

@implementation TradingCurrentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceLabel.text = @"123456.8901";
    self.buyLabel.text = @"500k SDX";
    self.sellLabel.text = @"3300K";
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.buyLabel];
    [self.contentView addSubview:self.sellLabel];
    [self.contentView addSubview:self.cancleOrderButtton];
    // Initialization code
}

-(void)layoutSubviews{
    CGFloat amountWidth = (WIDTH-kWidth(105))/3;
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(amountWidth);
        make.height.mas_equalTo(kHeight(30));
        make.left.mas_equalTo(kWidth(15));
    }];
    
    [self.buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(amountWidth);
        make.height.mas_equalTo(kHeight(30));
        make.left.mas_equalTo(kWidth(15)+amountWidth);
    }];
    
    [self.sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(amountWidth);
        make.height.mas_equalTo(kHeight(30));
        make.left.mas_equalTo(kWidth(15)+amountWidth*2);
    }];
    
    [self.cancleOrderButtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kWidth(60));
        make.height.mas_equalTo(kHeight(30));
        make.right.mas_equalTo(kWidth(-15));
    }];
}

#pragma mark - getter
-(UILabel *)priceLabel{
    if(!_priceLabel){
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:13];
    }
    return _priceLabel;
}

-(UILabel *)buyLabel{
    if(!_buyLabel){
        _buyLabel = [[UILabel alloc] init];
        _buyLabel.textAlignment = NSTextAlignmentCenter;
        _buyLabel.textColor = TEXT_COLOR;
        _buyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _buyLabel;
}

-(UILabel *)sellLabel{
    if(!_sellLabel){
        _sellLabel = [[UILabel alloc] init];
        _sellLabel.textAlignment = NSTextAlignmentCenter;
        _sellLabel.textColor = TEXT_COLOR;
        _sellLabel.font = [UIFont systemFontOfSize:13];
    }
    return _sellLabel;
}

-(UIButton *)cancleOrderButtton{
    if(!_cancleOrderButtton){
        _cancleOrderButtton = [[UIButton alloc] init];
        _cancleOrderButtton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _cancleOrderButtton.layer.masksToBounds = YES;
        _cancleOrderButtton.layer.cornerRadius = 5;
        [_cancleOrderButtton setTitle:@"撤单" forState:UIControlStateNormal];
        [_cancleOrderButtton setTitleColor:NAVIBAR_COLOR forState:UIControlStateNormal];
        _cancleOrderButtton.titleLabel.font = [UIFont systemFontOfSize:14];

    }
    return _cancleOrderButtton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
