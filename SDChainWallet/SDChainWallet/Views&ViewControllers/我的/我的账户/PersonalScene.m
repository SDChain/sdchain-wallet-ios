//
//  PersonalScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/15.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "PersonalScene.h"
#import "PersonalCenterCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MineCodeImageScene.h"
#import "NickNameScene.h"
#import "CertificationScene.h"
#import "BindMobileScene.h"
#import "ChangeBindMobileScene.h"
#import "HTTPRequestManager.h"

@interface PersonalScene ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)NSString *nickNameStr;
@property (nonatomic,strong)NSString *realNameStr;
@property (nonatomic,strong)NSString *userNameStr;

@end

@implementation PersonalScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"我的账户", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self setupTableView];
    [self setupIconView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestPersonalInfo];
}

-(void)requestPersonalInfo{
    [HTTPRequestManager searchUserWithUserName:SYSTEM_GET_(USER_NAME) showProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if([responseObject[@"nickName"] isEqual:[NSNull null]]){
            self.nickNameStr = @"";
        }
        else{
            self.nickNameStr = responseObject[@"nickName"];
        }
        if([responseObject[@"realName"] isEqual:[NSNull null]]){
            self.realNameStr = @"";
        }
        else{
            self.realNameStr = responseObject[@"realName"];
        }
        if([responseObject[@"userName"] isEqual:[NSNull null]]){
            self.userNameStr = @"";
        }
        else{
            self.userNameStr = responseObject[@"userName"];
        }
        [self.tableView reloadData];
    } reLogin:^{
        
    } warn:^(NSString *content) {
        [self presentAlertWithTitle:content message:@"" dismissAfterDelay:1.5 completion:nil];
    } error:^(NSString *content) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)setupTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalCenterCell" bundle:nil] forCellReuseIdentifier:@"PersonalCenterCell"];
    self.tableView.separatorColor = LINE_COLOR;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)setupIconView{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"mine_iconDefaultImage"]];
    [self.view addSubview:self.iconImageView];
    [UIView animateWithDuration:0.5 animations:^{
        self.iconImageView.frame = CGRectMake(WIDTH-kWidth(90), kHeight(10), kWidth(60), kWidth(60));
    } completion:^(BOOL finished) {
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCenterCell" forIndexPath:indexPath];
    cell.detailLabel.hidden = NO;
    cell.accessoryLabel.hidden = NO;
    if(indexPath.row == 0){
        cell.detailLabel.hidden = YES;
        cell.accessoryLabel.hidden = YES;
    }
    else if(indexPath.row == 1){
        NSString *title = NSLocalizedStringFromTable(@"我的二维码", @"guojihua", nil);
        cell.titleLabel.text = title;
        cell.detailLabel.text = @"\U0000e7ad";
        cell.detailLabel.font = KICON_FONT(20);
        cell.detailLabel.textColor = [UIColor darkGrayColor];
    }
    else if(indexPath.row == 2){
        NSString *title = NSLocalizedStringFromTable(@"昵称", @"guojihua", nil);
        cell.titleLabel.text = title;
        if(self.nickNameStr.length == 0){
            NSString *detail = NSLocalizedStringFromTable(@"未设置", @"guojihua", nil);
            cell.detailLabel.text = detail;
        }
        else{
            cell.detailLabel.text = self.nickNameStr;
        }
    }
    else if(indexPath.row == 3){
        NSString *title = NSLocalizedStringFromTable(@"用户名", @"guojihua", nil);
        cell.titleLabel.text = title;
        cell.detailLabel.text = SYSTEM_GET_(USER_NAME);
        cell.accessoryLabel.hidden = YES;
    }
    else if(indexPath.row == 4){
        NSString *title = NSLocalizedStringFromTable(@"实名认证", @"guojihua", nil);
        cell.titleLabel.text = title;
        if(self.realNameStr.length == 0){
            NSString *detail = NSLocalizedStringFromTable(@"未认证", @"guojihua", nil);
            cell.detailLabel.text = detail;
        }
        else{
            cell.detailLabel.text = self.realNameStr;
        }
        
    }
    else if(indexPath.row == 5){
        NSString *title = NSLocalizedStringFromTable(@"手机号", @"guojihua", nil);
        cell.titleLabel.text = title;
        if([SYSTEM_GET_(PHONE) isEqualToString:@""]){
            NSString *detail = NSLocalizedStringFromTable(@"未绑定", @"guojihua", nil);
            cell.detailLabel.text = detail;
        }
        else{
            cell.detailLabel.text = SYSTEM_GET_(PHONE);
        }
    }
    else if(indexPath.row == 6){
        NSString *title = NSLocalizedStringFromTable(@"邮箱", @"guojihua", nil);
        cell.titleLabel.text = title;
        if([SYSTEM_GET_(EMAIL) isEqualToString:@""]){
            NSString *detail = NSLocalizedStringFromTable(@"未绑定", @"guojihua", nil);
            cell.detailLabel.text = detail;
        }
        else{
            cell.detailLabel.text = SYSTEM_GET_(EMAIL);
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){

    }
    else if(indexPath.row == 1){
        MineCodeImageScene *scene = [[MineCodeImageScene alloc] init];
        [self.navigationController pushViewController:scene animated:YES];
    }
    else if(indexPath.row == 2){
        NickNameScene *scene = [[NickNameScene alloc] init];
        if(self.nickNameStr.length == 0){
            scene.nickName = @"";
        }
        else{
            scene.nickName = self.nickNameStr;
        }
        [self.navigationController pushViewController:scene animated:YES];
    }
    else if(indexPath.row == 3){

    }
    else if(indexPath.row == 4){
        if(self.realNameStr.length == 0){
            CertificationScene *scene = [[CertificationScene alloc] init];
            [self.navigationController pushViewController:scene animated:YES];
        }else{
            NSString *detail = NSLocalizedStringFromTable(@"已认证", @"guojihua", nil);
            [self presentAlertWithTitle:detail message:@"" dismissAfterDelay:1.5 completion:nil];
        }
    }
    else if(indexPath.row == 5){
        if([SYSTEM_GET_(PHONE) isEqualToString:@""]){
            BindMobileScene *scene = [[BindMobileScene alloc] init];
            scene.bindType = typeBind;
            scene.accountType = typeMobile;
            [self.navigationController pushViewController:scene animated:YES];
        }else{
            BindMobileScene *scene = [[BindMobileScene alloc] init];
            scene.bindType = typeRemoveBind;
            scene.accountType = typeMobile;
            [self.navigationController pushViewController:scene animated:YES];
        }

        
//        ChangeBindMobileScene *scene = [[ChangeBindMobileScene alloc] init];
//        [self.navigationController pushViewController:scene animated:YES];
    }
    else if(indexPath.row == 6){
        if([SYSTEM_GET_(USER_NAME) containsString:@"@"] || ![SYSTEM_GET_(EMAIL) isEqualToString:@""]){
//            NSString *email = SYSTEM_GET_(USER_NAME);
//            SYSTEM_SET_(email, EMAIL);
            BindMobileScene *scene = [[BindMobileScene alloc] init];
            scene.bindType = typeRemoveBind;
            scene.accountType = typeEmail;
            [self.navigationController pushViewController:scene animated:YES];
        }else{
            BindMobileScene *scene = [[BindMobileScene alloc] init];
            scene.bindType = typeBind;
            scene.accountType = typeEmail;
            [self.navigationController pushViewController:scene animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return kHeight(80);
        
    }
    else{
        
        return kHeight(50);
    }
    
}


#pragma MARK - getter

-(UIImageView *)iconImageView{
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(kWidth(10), kHeight(10), kHeight(60), kHeight(60));
    }
    return _iconImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
