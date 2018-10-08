//
//  TradingHistoryCell.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/23.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "TradingHistoryCell.h"
#import "Masonry.h"

@interface TradingHistoryCell ()

@end

@implementation TradingHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.text = @"挂单";
    self.priceLabel.text = @"123456.8901";
    self.buyLabel.text = @"500k SDX";
    self.sellLabel.text = @"3300K";
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.buyLabel];
    [self.contentView addSubview:self.sellLabel];
    
    // Initialization code
}

-(void)setupCellWithDict:(NSDictionary *)dict{
    

}

-(void)layoutSubviews{
    
    CGFloat amountWidth = (WIDTH-kWidth(50))/3;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kWidth(50));
        make.height.mas_equalTo(kHeight(30));
        make.left.mas_equalTo(kWidth(15));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(amountWidth);
        make.height.mas_equalTo(kHeight(30));
        make.left.mas_equalTo(kWidth(65));
    }];
    
    [self.buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(amountWidth);
        make.height.mas_equalTo(kHeight(30));
        make.left.mas_equalTo(kWidth(65)+amountWidth);
    }];

    [self.sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(amountWidth);
        make.height.mas_equalTo(kHeight(30));
        make.left.mas_equalTo(kWidth(65)+amountWidth*2);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = NAVIBAR_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

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
        _buyLabel.textColor = TEXT_COLOR_LIGHT;
        _buyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _buyLabel;
}

-(UILabel *)sellLabel{
    if(!_sellLabel){
        _sellLabel = [[UILabel alloc] init];
        _sellLabel.textAlignment = NSTextAlignmentCenter;
        _sellLabel.textColor = TEXT_COLOR_LIGHT;
        _sellLabel.font = [UIFont systemFontOfSize:13];
    }
    return _sellLabel;
}

@end
