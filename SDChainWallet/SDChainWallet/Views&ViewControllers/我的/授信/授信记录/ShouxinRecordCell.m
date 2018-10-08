//
//  ShouxinRecordCell.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/29.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "ShouxinRecordCell.h"
#import "UIImageView+WebCache.h"

@implementation ShouxinRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.accountLabel];
    // Initialization code
}

-(void)setupCellWithModel:(ShouxinRecordModel *)model{
    NSLog(@"%@",model.pic);
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",model.value,model.code];
    self.timeLabel.text = [GlobalMethod htcTimeToLocationStr:model.date];
    self.timeLabel.text = model.date;
    self.accountLabel.text = model.issuer;
}

#pragma mark - getter
-(UIImageView *)iconImageView{
    if(!_iconImageView){
        _iconImageView =[[UIImageView alloc] initWithFrame:CGRectMake(kWidth(15), kHeight(10), kHeight(35), kHeight(35))];
    }
    return _iconImageView;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.iconImageView.frame)+kWidth(30), kHeight(3), WIDTH-CGRectGetWidth(self.iconImageView.frame)-kWidth(130), kHeight(18))];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-kWidth(100), CGRectGetMidY(self.titleLabel.frame), kWidth(90), kHeight(18))];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

-(UILabel *)accountLabel{
    if(!_accountLabel){
        _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.iconImageView.frame)+kWidth(30), kHeight(25), WIDTH-CGRectGetWidth(self.iconImageView.frame)-kWidth(30), 20)];
        _accountLabel.numberOfLines = 0;
        _accountLabel.textAlignment = NSTextAlignmentLeft;
        _accountLabel.font = [UIFont systemFontOfSize:13];
    }
    return _accountLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
