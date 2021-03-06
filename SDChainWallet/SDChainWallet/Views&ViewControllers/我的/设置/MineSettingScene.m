//
//  MineSettingScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/4/11.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "MineSettingScene.h"
#import "MineSettingCell.h"
#import "AboutUsScene.h"
#import "FixLoginSecretScene.h"
#import "NSString+validate.h"

@interface MineSettingScene ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MineSettingScene

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"设置", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineSettingCell" bundle:nil] forCellReuseIdentifier:@"MineSettingCell"];
//    self.tableView.separatorColor = LINE_COLOR;
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineSettingCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"MineSettingCell" forIndexPath:indexPath];
    if(indexPath.row == 0){
        NSString *title = NSLocalizedStringFromTable(@"修改登录密码", @"guojihua", nil);
        cell.titleLabel.text = title;
    }
    else{
        NSString *title = NSLocalizedStringFromTable(@"关于我们", @"guojihua", nil);
        cell.titleLabel.text = title;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = SYSTEM_GET_(USER_NAME);
    if(indexPath.row == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedStringFromTable(@"选择修改方式", @"guojihua", nil) preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *mobileAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"通过手机修改", @"guojihua", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([str containsString:@"@"]){
                NSString *phoneStr = [NSString stringWithFormat:@"%@",SYSTEM_GET_(PHONE)];
                if(phoneStr.length>0){
                    FixLoginSecretScene *scene = [[FixLoginSecretScene alloc] init];
                    scene.type = typeLoginMobile;
                    scene.accountStr = SYSTEM_GET_(PHONE);
                    [self.navigationController pushViewController:scene animated:YES];
                }else{
                    [self presentAlertWithTitle:NSLocalizedStringFromTable(@"请先绑定手机", @"guojihua", nil) message:@"" dismissAfterDelay:1.5 completion:nil];
                }
            }else{
                FixLoginSecretScene *scene = [[FixLoginSecretScene alloc] init];
                scene.type = typeLoginMobile;
                scene.accountStr = SYSTEM_GET_(PHONE);
                [self.navigationController pushViewController:scene animated:YES];
            }
            
        }];
        UIAlertAction *emailAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"通过邮箱修改", @"guojihua", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([str containsString:@"@"]){
                FixLoginSecretScene *scene = [[FixLoginSecretScene alloc] init];
                scene.type = typeLoginEmail;
                scene.accountStr = SYSTEM_GET_(USER_NAME);
                [self.navigationController pushViewController:scene animated:YES];
            }else{
                NSString *emailStr = [NSString stringWithFormat:@"%@",SYSTEM_GET_(EMAIL)];
                if(emailStr.length>0){
                    FixLoginSecretScene *scene = [[FixLoginSecretScene alloc] init];
                    scene.type = typeLoginEmail;
                    scene.accountStr = SYSTEM_GET_(EMAIL);
                    [self.navigationController pushViewController:scene animated:YES];
                }else{
                    [self presentAlertWithTitle:NSLocalizedStringFromTable(@"请先绑定邮箱", @"guojihua", nil) message:@"" dismissAfterDelay:1.5 completion:nil];
                }
            }
            
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"取消", @"guojihua", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancleAction];
        [alert addAction:mobileAction];
        [alert addAction:emailAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(indexPath.row == 1){
        AboutUsScene *scene = [[AboutUsScene alloc] init];
        [self.navigationController pushViewController:scene animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:@"选择修改方式" preferredStyle:UIAlertControllerStyleActionSheet];
//        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"选择修改方式"];
//        [titleStr addAttribute:NSFontAttributeName
//                      value:[UIFont systemFontOfSize:20]
//                      range:NSMakeRange(0, titleStr.length)];
//        [alert setValue:titleStr forKey:@"attributedMessage"];
//        __weak MineSettingScene *weakSelf = self;
//        UIAlertAction *mobileAction = [UIAlertAction actionWithTitle:@"手机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            FixLoginSecretScene *scene = [[FixLoginSecretScene alloc] init];
//            scene.type = typeLoginMobile;
//            [weakSelf.navigationController pushViewController:scene animated:YES];
//        }];
//        UIAlertAction *emailAction = [UIAlertAction actionWithTitle:@"邮箱" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self presentAlertWithTitle:@"请先绑定邮箱" message:@"" dismissAfterDelay:1.5 completion:nil];
//        }];
//        UIAlertAction *cancleAction= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//
//        [alert addAction:mobileAction];
//        [alert addAction:emailAction];
//        [alert addAction:cancleAction];
//        [self presentViewController:alert animated:YES completion:nil];

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
