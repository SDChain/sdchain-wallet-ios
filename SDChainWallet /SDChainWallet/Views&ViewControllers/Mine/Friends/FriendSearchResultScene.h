//
//  FriendSearchResultScene.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/16.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactModel.h"

typedef void(^FriendSearchChoosenBlock)(ContactModel *);

@interface FriendSearchResultScene : BaseViewController
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic, strong)FriendSearchChoosenBlock searchSelectBlock;
@end
