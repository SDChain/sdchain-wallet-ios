//
//  MineScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/11.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "MineScene.h"
#import "PersonalIconCell.h"
#import "PersonalSettingCell.h"
#import "Masonry.h"
#import "PersonalScene.h"

#import "MineSettingScene.h"
#import "ChooseFriendScene.h"
#import "MineWalletAddressScene.h"
#import "FixWalletSecretScene.h"
#import "TransferListScene.h"
#import "MessagesListScene.h"

@interface MineScene ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MineScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"我的", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView.superview);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate && DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    else if (section == 1){
        return 2;
    }
    else if (section == 2){
        return 4;
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        PersonalIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalIconCell" forIndexPath:indexPath];
        cell.mobileLabel.text = SYSTEM_GET_(USER_NAME);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        PersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalSettingCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                cell.iconImageView.image = [UIImage imageNamed:@"mine_qianbaodizhi"];
                NSString *title = NSLocalizedStringFromTable(@"钱包地址", @"guojihua", nil);
                cell.titleLabel.text = title;
            }
            else if (indexPath.row == 1){
                cell.iconImageView.image = [UIImage imageNamed:@"mine_xiugaiqianbaomima"];
                NSString *title = NSLocalizedStringFromTable(@"修改钱包密码", @"guojihua", nil);
                cell.titleLabel.text = title;
            }
        }
        else if (indexPath.section == 2){
            if(indexPath.row == 0){
                cell.iconImageView.image = [UIImage imageNamed:@"mine_zhuanzhangjilu"];
                NSString *title = NSLocalizedStringFromTable(@"转账记录", @"guojihua", nil);
                cell.titleLabel.text = title;
            }
            else if (indexPath.row == 1){
                cell.iconImageView.image = [UIImage imageNamed:@"mine_xiaoxi"];
                NSString *title = NSLocalizedStringFromTable(@"消息", @"guojihua", nil);
                cell.titleLabel.text = title;
            }
            else if (indexPath.row == 2){
                cell.iconImageView.image = [UIImage imageNamed:@"mine_haoyou"];
                NSString *title = NSLocalizedStringFromTable(@"好友", @"guojihua", nil);
                cell.titleLabel.text = title;
            }
            else if (indexPath.row == 3){
                cell.iconImageView.image = [UIImage imageNamed:@"mine_shezhi"];
                NSString *title = NSLocalizedStringFromTable(@"设置", @"guojihua", nil);
                cell.titleLabel.text = title;
            }
            
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 80;
    }
    else{
        return 50;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, WIDTH, 10);
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView  *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        PersonalScene *scene = [[PersonalScene alloc] initWithNibName:@"PersonalScene" bundle:nil];
        scene.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scene animated:YES];
        
    }
    else if (indexPath.section == 1){
        if(indexPath.row == 0){
            MineWalletAddressScene *scene = [[MineWalletAddressScene alloc] init];
            scene.account = SYSTEM_GET_(ACCOUNT);
            scene.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scene animated:YES];
        }
        else if (indexPath.row == 1){
            FixWalletSecretScene *scene = [[FixWalletSecretScene alloc] init];
            scene.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scene animated:YES];
        }
        
    }
    else if (indexPath.section == 2){
        if(indexPath.row == 0){
            TransferListScene *scene = [[TransferListScene alloc] initWithNibName:@"TransferListScene" bundle:nil];
            scene.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scene animated:YES];
        }
        else if (indexPath.row == 1){
            MessagesListScene *scene = [[MessagesListScene alloc] initWithNibName:@"MessagesListScene" bundle:nil];
            scene.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scene animated:YES];
        }
        else if (indexPath.row == 2){
            ChooseFriendScene *scene = [[ChooseFriendScene alloc] initWithNibName:@"ChooseFriendScene" bundle:nil];
            scene.hidesBottomBarWhenPushed = YES;
            scene.type = ListTypeCheck;
            [self.navigationController pushViewController:scene animated:YES];
        }
        else if (indexPath.row == 3){
            MineSettingScene *scene = [[MineSettingScene alloc] initWithNibName:@"MineSettingScene" bundle:nil];
            scene.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scene animated:YES];
        }
        
    }

    
}


#pragma mark - tableView

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = LINE_COLOR;
        [_tableView registerNib:[UINib nibWithNibName:@"PersonalIconCell" bundle:nil] forCellReuseIdentifier:@"PersonalIconCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PersonalSettingCell" bundle:nil] forCellReuseIdentifier:@"PersonalSettingCell"];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
