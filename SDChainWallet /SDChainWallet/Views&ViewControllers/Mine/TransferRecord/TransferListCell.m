//
//  TransferListCell.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/3.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "TransferListCell.h"

@implementation TransferListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupCellWithDict:(NSDictionary *)dict{
    NSString *timeStr = [NSString stringWithFormat:@"%@",dict[@"date"]];
                NSString *title1 = NSLocalizedStringFromTable(@"转入金额", @"guojihua", nil);
    self.amountLabel.text = [NSString stringWithFormat:@"%@：%@ %@",title1,dict[@"amount"][@"value"],dict[@"currency"]];
    self.timeLabel.text = [GlobalMethod getTimeWithdate:timeStr];
    if([dict[@"direction"] isEqualToString:@"incoming"]){
        NSString *title2 = NSLocalizedStringFromTable(@"发款方", @"guojihua", nil);
        self.senderLabel.text = [NSString stringWithFormat:@"%@：%@",title2,dict[@"source_account"]];
    }else{
        NSString *title3 = NSLocalizedStringFromTable(@"收款方", @"guojihua", nil);
        self.senderLabel.text = [NSString stringWithFormat:@"%@：%@",title3,dict[@"destination_account"]];
    }
}

-(void)setupCellWithMessage:(NSDictionary *)dict{
    NSString *timeStr = [NSString stringWithFormat:@"%@",dict[@"timestamp"]];
    NSString *title1 = NSLocalizedStringFromTable(@"转入通知", @"guojihua", nil);
    NSString *title2 = NSLocalizedStringFromTable(@"收款成功", @"guojihua", nil);
    NSString *title3 = NSLocalizedStringFromTable(@"发款方", @"guojihua", nil);
    NSString *title4 = NSLocalizedStringFromTable(@"收款方", @"guojihua", nil);
    self.amountLabel.text = [NSString stringWithFormat:@"%@：%@ SDA%@",title1,dict[@"amount"][@"value"],title2];
    self.timeLabel.text = timeStr;
    if([dict[@"direction"] isEqualToString:@"incoming"]){
        self.senderLabel.text = [NSString stringWithFormat:@"%@：%@",title3,dict[@"source_account"]];
    }else{
        self.senderLabel.text = [NSString stringWithFormat:@"%@：%@",title4,dict[@"destination_account"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
