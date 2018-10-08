//
//  InputAmountView.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/7/23.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "InputAmountView.h"

@interface InputAmountView ()
@property(nonatomic,strong)UIButton *reduceButton;
@property(nonatomic,strong)UIButton *addButton;
@end

@implementation InputAmountView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self){
        self = [super initWithFrame:frame];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = (kHeight(35)-10)/2;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = NAVIBAR_COLOR.CGColor;
        
        [self addSubview:self.reduceButton];
        [self addSubview:self.addButton];
        [self addSubview:self.textField];

    }
    return self;
}

-(void)reduceAction{
    CGFloat textAmount = [self.textField.text doubleValue];
    if(textAmount < 1){
        textAmount = 0;
    }
    else{
        textAmount = textAmount -1;
    }
    self.textField.text = [NSString stringWithFormat:@"%@",@(textAmount)];
    if(self.textAmountChangeBlock){
        self.textAmountChangeBlock();
    }
}

-(void)addAction{
    CGFloat textAmount = [self.textField.text doubleValue];
    textAmount = textAmount + 1.0;
    self.textField.text = [NSString stringWithFormat:@"%@",@(textAmount)];
    if(self.textAmountChangeBlock){
        self.textAmountChangeBlock();
    }
}

-(UIButton *)reduceButton{
    if(!_reduceButton){
        _reduceButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        [_reduceButton setImage:[UIImage imageNamed:@"amount_reduce"] forState:UIControlStateNormal];
        [_reduceButton addTarget:self action:@selector(reduceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceButton;
}

-(UIButton *)addButton{
    if(!_addButton){
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-CGRectGetHeight(self.frame)-5, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        [_addButton setImage:[UIImage imageNamed:@"amount_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _addButton;
}


-(UITextField *)textField
{
    if(!_textField){
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetHeight(self.frame)+5, 0, CGRectGetWidth(self.frame)-CGRectGetHeight(self.frame)*2-10, CGRectGetHeight(self.frame))];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _textField;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
