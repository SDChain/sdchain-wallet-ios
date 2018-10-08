//
//  OrderShowView.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/24.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "OrderShowView.h"
#import "OrderShowCell.h"

@interface OrderShowView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) NSArray *exchangesBuy;                   //买入挂单列表
@property (nonatomic, strong) NSArray *exchangesSell;                   //卖出挂单列表

@end

@implementation OrderShowView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self){
        self = [super initWithFrame:frame];
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)fefreshListWithExchangesBuy:(NSArray *)ExchangesBuy exchangesSell:(NSArray *)exchangesSell{

//    NSMutableArray *array = [NSMutableArray arrayWithArray:ExchangesBuy];
//    self.exchangesBuy = (NSArray *)[[array reverseObjectEnumerator] allObjects];
    self.exchangesBuy = ExchangesBuy;
    
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:exchangesSell];
    self.exchangesSell = (NSArray *)[[array1 reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.exchangesSell.count;
    }
    else{
        return self.exchangesBuy.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderShowCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict;
    if(indexPath.section == 0){
        cell.titleLabel.text = [NSString stringWithFormat:@"卖%ld",5-indexPath.row];
        dict = self.exchangesSell[indexPath.row];
        cell.priceLabel.textColor = [UIColor greenColor];
    }else{
        cell.titleLabel.text = [NSString stringWithFormat:@"买%ld",indexPath.row+1];
        dict = self.exchangesBuy[indexPath.row];
        cell.priceLabel.textColor = [UIColor redColor];
    }
    NSString *priceStr = dict[@"price"];
    NSString *amountStr = dict[@"base_amount"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",priceStr];
    cell.amountLabel.text = [NSString stringWithFormat:@"%@",amountStr];
    
    return cell;
}

-(UIView  *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if(self.exchangesBuy.count == 0 && self.exchangesSell.count == 0){
            return nil;
        }else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *priceTitle = [[UILabel alloc] initWithFrame:CGRectMake(kHeight(60), 0, (WIDTH-kHeight(60))/2, 30)];
            priceTitle.text = @"价格";
            priceTitle.textAlignment = NSTextAlignmentCenter;
            priceTitle.font = [UIFont systemFontOfSize:13];
            [view addSubview:priceTitle];
            UILabel *amountTitle = [[UILabel alloc] initWithFrame:CGRectMake(kHeight(60)+(WIDTH-kHeight(60))/2, 0, (WIDTH-kHeight(60))/2, kHeight(30))];
            amountTitle.text = @"SDX";
            amountTitle.font = [UIFont systemFontOfSize:13];
            amountTitle.textAlignment = NSTextAlignmentCenter;
            [view addSubview:amountTitle];
            return view;
        }
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kHeight(10))];
        view.backgroundColor = [UIColor whiteColor];
        if(self.exchangesBuy.count > 0){
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 4.5, WIDTH, 1)];
            lineView.backgroundColor = LINE_COLOR;
            [view addSubview:lineView];
        }
        return view;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 30;
    }else{
        return kHeight(10);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark - getter
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGRectGetHeight(self.frame)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"OrderShowCell" bundle:nil] forCellReuseIdentifier:@"OrderShowCell"];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
    }
    return _tableView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
