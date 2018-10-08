//
//  ShouxinActionView.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/1.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouxinActionView : UIView

@property(nonatomic,copy)void(^shouxinBlock)(NSString *,NSString*,NSString*);

-(instancetype)initWithFrame:(CGRect)frame;

-(void)showShouxinActionView;

@end
