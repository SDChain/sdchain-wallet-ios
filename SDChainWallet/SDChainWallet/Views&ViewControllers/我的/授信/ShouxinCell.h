//
//  ShouxinCell.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/1.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrustListModel.h"

@interface ShouxinCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iocnImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

-(void)setupCellWithModel:(TrustListModel *)model;

@end
