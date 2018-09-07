//
//  ChooseFriendScene.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/12.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactModel.h"
typedef NS_ENUM(NSInteger,FriendListType) {
    ListTypeSelect,
    ListTypeCheck
};

typedef void(^FriendChoosenBlock)(ContactModel *);

@interface ChooseFriendScene : BaseViewController

@property(nonatomic,assign)FriendListType type;

@property (nonatomic, strong)FriendChoosenBlock tapBlock;

@end
