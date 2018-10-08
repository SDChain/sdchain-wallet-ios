//
//  CurrencySelectPopView.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/23.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "CurrencySelectPopView.h"
#import "CurrencySelectPopViewCell.h"


@interface CurrencySelectPopView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,copy) NSArray *dataArr;
@property(nonatomic,assign) CGFloat xPosition;
@property(nonatomic,assign) CGFloat yPosition;

@end

@implementation CurrencySelectPopView

-(instancetype)initWithFrame:(CGRect)frame withArr:(NSArray *)arr xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition{
    if(self){
        self = [super initWithFrame:frame];
        self.dataArr = arr;
        self.xPosition = xPosition;
        self.yPosition = yPosition;
        [self addSubview:self.backView];
        [self addSubview:self.tableView];

    }
    return self;
}

-(void)showCurrencyListPopView{
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [[UIApplication  sharedApplication].keyWindow addSubview:self];
        self.tableView.frame = CGRectMake(self.xPosition, self.yPosition, kWidth(100), kHeight(25)*self.dataArr.count);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideCurrencyListPopView{
    [self removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencySelectPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencySelectPopViewCell" forIndexPath:indexPath];
    TradingCurrencyModel *model = self.dataArr[indexPath.row];
    cell.label.text = model.currency;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight(25);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TradingCurrencyModel *model = self.dataArr[indexPath.row];
    if(self.currencyBlock){
        self.currencyBlock(model);
        [self hideCurrencyListPopView];
    }
}

#pragma mark - getter
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.xPosition, self.yPosition, kWidth(100), 0.001) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"CurrencySelectPopViewCell" bundle:nil] forCellReuseIdentifier:@"CurrencySelectPopViewCell"];
    }
    return _tableView;
}

-(UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCurrencyListPopView)];
        [_backView addGestureRecognizer:gusture];
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
