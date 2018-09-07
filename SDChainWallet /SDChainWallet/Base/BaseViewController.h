//
//  BaseViewController.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/15.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setTitleViewWithBlackTitle:(NSString * _Nonnull)title;
- (void)setTitleViewWithTitle:(NSString * _Nonnull)title;


- (void)presentAlertWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message dismissAfterDelay:(NSTimeInterval)delay completion:(void(^ _Nullable)(void))completion;

@end
