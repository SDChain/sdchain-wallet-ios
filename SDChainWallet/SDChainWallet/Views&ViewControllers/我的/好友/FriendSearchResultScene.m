//
//  FriendSearchResultScene.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/5/16.
//  Copyright © 2018年 LiuYuLianMeng. All rights reserved.
//

#import "FriendSearchResultScene.h"
#import "FriendListCell.h"
#import "ContactModel.h"

@interface FriendSearchResultScene ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation FriendSearchResultScene

- (void)viewDidLoad {
    [super viewDidLoad];
        NSString *title = NSLocalizedStringFromTable(@"搜索好友", @"guojihua", nil);
    [self setTitleViewWithTitle:title];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCell"];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell" forIndexPath:indexPath];
    ContactModel *model = self.dataArray[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@  (%@)",model.nickName,model.userName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactModel *model = self.dataArray[indexPath.row];
     [self.navigationController popViewControllerAnimated:NO];
    if(self.searchSelectBlock){
        self.searchSelectBlock(model);
    }
   
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
