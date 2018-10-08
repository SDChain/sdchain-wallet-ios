//
//  WalletListCell.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/20.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;

-(void)setupCellWithModel:(WalletModel *)model;

@end
