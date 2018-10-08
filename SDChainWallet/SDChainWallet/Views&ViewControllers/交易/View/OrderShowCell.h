//
//  OrderShowCell.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/24.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderShowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *amountLabel;


@end
