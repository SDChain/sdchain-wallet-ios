//
//  TransferListCell.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/3.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;

-(void)setupCellWithDict:(NSDictionary *)dict;

-(void)setupCellWithMessage:(NSDictionary *)dict;

@end
