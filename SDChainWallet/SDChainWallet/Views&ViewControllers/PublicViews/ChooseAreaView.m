//
//  ChooseAreaView.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/9/10.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "ChooseAreaView.h"
#import "ChooseAreaViewCell.h"
@interface ChooseAreaView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *backGroudView;
@property(nonatomic,strong)UIView *headview;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSDictionary *selectData;

@end

@implementation ChooseAreaView

-(void)showAction{
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication  sharedApplication].keyWindow addSubview:self];
        self.backGroudView.alpha = 0.5;
        self.tableView.frame =CGRectMake(0, HEIGHT-kHeight(230), WIDTH, kHeight(230));
        self.headview.frame = CGRectMake(0, HEIGHT-kHeight(275), WIDTH, 45);
    }];
}

-(void)confirmAction{
    if(self.selectData){
        SYSTEM_SET_(self.selectData, CURRENTAREA);
        if(self.ConfirmBlock){
            self.ConfirmBlock();
        }
        [self hideAction];
    }else{
        [self hideAction];
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self){
        self = [super initWithFrame:frame];
        // 获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"arealist" ofType:@"json"];
        // 将文件数据化
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        // 对数据进行JSON格式化并返回字典形式
        self.dataArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [self addSubview:self.backGroudView];
        [self addSubview:self.tableView];
        [self addSubview:self.headview];
    }
    return self;
}

-(void)hideAction{
    [self removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseAreaViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseAreaViewCell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.label1.text = [NSString stringWithFormat:@"+%@",dict[@"code"]];
    if([[GlobalMethod getCurrentLanguage] isEqualToString:@"tc"]){
        cell.label2.text = dict[@"tw"];
    }else if ([[GlobalMethod getCurrentLanguage] isEqualToString:@"en"]){
        cell.label2.text = dict[@"en"];
    }else{
        cell.label2.text = dict[@"zh"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.row];
    self.selectData = dict;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight(35);
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ChooseAreaViewCell" bundle:nil] forCellReuseIdentifier:@"ChooseAreaViewCell"];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
    }
    return _tableView;
}

-(UIView *)headview{
    if(!_headview){
        _headview = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-45, WIDTH, 45)];
        _headview.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, WIDTH, 0.8)];
        lineView.backgroundColor = BACKGROUNDCOLOR;
        [_headview addSubview:lineView];
        UIButton *confrimButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-kWidth(80), 0, kWidth(80), 45)];
        [confrimButton  addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [confrimButton setTitle:@"确定" forState:UIControlStateNormal];
        [confrimButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [_headview addSubview:confrimButton];
        UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidth(80), 45)];
        [cancleButton  addTarget:self action:@selector(hideAction) forControlEvents:UIControlEventTouchUpInside];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [_headview addSubview:cancleButton];
    }
    return _headview;
}

-(UIView *)backGroudView{
    if(!_backGroudView){
        _backGroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _backGroudView.backgroundColor = [UIColor darkGrayColor];
        _backGroudView.alpha = 0;
        UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction)];
        [_backGroudView addGestureRecognizer:gusture];
    }
    return _backGroudView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
