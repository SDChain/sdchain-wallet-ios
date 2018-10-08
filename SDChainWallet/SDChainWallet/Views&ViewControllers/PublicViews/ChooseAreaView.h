//
//  ChooseAreaView.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/9/10.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAreaView : UIView

@property(nonatomic,copy) void(^ConfirmBlock)();

-(instancetype)initWithFrame:(CGRect)frame;

-(void)showAction;

@end
