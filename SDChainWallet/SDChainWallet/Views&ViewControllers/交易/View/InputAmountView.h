//
//  InputAmountView.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/23.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputAmountView : UIView

@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,copy)void (^textAmountChangeBlock)(void);

-(instancetype)initWithFrame:(CGRect)frame;

@end
