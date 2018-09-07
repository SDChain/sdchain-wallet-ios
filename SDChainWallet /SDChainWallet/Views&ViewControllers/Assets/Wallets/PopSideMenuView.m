//
//  PopSideMenuView.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/19.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "PopSideMenuView.h"
#import "WalletListCell.h"
#import "WalletListActionCell.h"
#import "EstablishWalletScene.h"
#import "HTTPRequestManager.h"

@interface PopSideMenuView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UITableView *tabkeView;
@end

@implementation PopSideMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self){
        self = [super initWithFrame:frame];
        [self addSubview:self.backView];
        [self addSubview:self.tabkeView];
        [self showAction];
    }
    return self;
}

-(void)showAction{
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.alpha = 0.5;
        self.tabkeView.frame = CGRectMake(WIDTH/2, 0, WIDTH/2, HEIGHT);
    }];
    
}

-(void)dismissAction{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0;
        self.tabkeView.frame = CGRectMake(WIDTH, 0, 0, HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - action

//Modify the default wallet
-(void)changeDefaultWalletActionWithAccount:(WalletModel *)model{
    [HTTPRequestManager paymentchangeDefaultWalletWithId:SYSTEM_GET_(USER_ID) account:model.account showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[JKDBHelper shareInstance] changeDBWithDirectoryName:WALLETSTABLE];
        NSArray *currentList = [WalletModel findByCriteria:[NSString stringWithFormat:@" WHERE isDefault = '%@' ",@"1"]];
        WalletModel *defaultModel = currentList[0];
        defaultModel.isDefault = @"0";
        [defaultModel update];
        WalletModel *mod = model;
        mod.isDefault = @"1";
        [mod update];
        SYSTEM_SET_(mod.account, ACCOUNT);
        SYSTEM_SET_(mod.userAccountId, USERACCOUNTID);

        NSNotification *notification = [NSNotification notificationWithName:@"qingkong" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    
        [self removeFromSuperview];
    } reLogin:^{
        
    } warn:^(NSString *content) {
        
    } error:^(NSString *content) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}



#pragma mark - UITableView Delegate && DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.wallets.count;
    }
    else if (section == 1){
        return 2;
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==  0){
        WalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletListCell" forIndexPath:indexPath];
        [cell setupCellWithModel:self.wallets[indexPath.row]];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = NAVIBAR_COLOR;
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lpGR:)];
        
        //Set the minimum long press time. Press this time not enough to respond to the gesture.
        
        longPressGR.minimumPressDuration = 0.7;
        
        [cell addGestureRecognizer:longPressGR];
        return cell;
    }
    else{
        
        WalletListActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletListActionCell" forIndexPath:indexPath];
        if(indexPath.row == 0){
            cell.iconImageView.image = [UIImage imageNamed:@"zichan_createWallet"];
            NSString *title = NSLocalizedStringFromTable(@"创建钱包", @"guojihua", nil);
            cell.titleLabel.text = title;
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH/2, 0.8)];
            lineview.backgroundColor = LINE_COLOR;
            [cell addSubview:lineview];
        }
        else if(indexPath.row == 1){
            cell.iconImageView.image = [UIImage imageNamed:@"zichan_loginout"];
            NSString *title = NSLocalizedStringFromTable(@"退出登录", @"guojihua", nil);
            cell.titleLabel.text = title;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(self.selectedBlock){
            self.selectedBlock(self.wallets[indexPath.row]);
        }
        [self removeFromSuperview];
    }
    else if (indexPath.section == 1){
        if(indexPath.row == 0){
            [self dismissAction];
            if(self.block){
            self.block(@"");
            }
        }
        else if (indexPath.row == 1){
            if(self.loginoutBlock){
                self.loginoutBlock();
            }
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 50;
    }else{
        return 44;
    }
}

//Implement the function corresponding to the gesture

-(void)lpGR:(UILongPressGestureRecognizer *)lpGR

{
    
    if (lpGR.state == UIGestureRecognizerStateBegan) {//Gesture start
        

        
    }
    
    if (lpGR.state == UIGestureRecognizerStateEnded)//End of gesture
        
    {
        
    //set as Default
        CGPoint p = [lpGR locationInView:self.tabkeView];
        
        NSIndexPath *indexPath = [self.tabkeView indexPathForRowAtPoint:p];//Get the long press index of the response
        if (indexPath == nil)
            NSLog(@"long press on table view but not on a row");
        else
            NSLog(@"long press on table view at row %ld", indexPath.row);
        
        WalletModel *model = self.wallets[indexPath.row];
        [self changeDefaultWalletActionWithAccount:model];
    }
    
}


#pragma mark - getter
-(UITableView *)tabkeView{
    if(!_tabkeView){
        _tabkeView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, 0, HEIGHT)];
        _tabkeView.delegate = self;
        _tabkeView.dataSource = self;
        _tabkeView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tabkeView registerNib:[UINib nibWithNibName:@"WalletListActionCell" bundle:nil] forCellReuseIdentifier:@"WalletListActionCell"];
        [_tabkeView registerNib:[UINib nibWithNibName:@"WalletListCell" bundle:nil] forCellReuseIdentifier:@"WalletListCell"];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        _tabkeView.tableHeaderView = headView;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        _tabkeView.tableFooterView = footView;
    }
    return _tabkeView;
}

-(UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0;
        UITapGestureRecognizer *dismissGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
        [_backView addGestureRecognizer:dismissGusture];
        
    }
    return _backView;
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
