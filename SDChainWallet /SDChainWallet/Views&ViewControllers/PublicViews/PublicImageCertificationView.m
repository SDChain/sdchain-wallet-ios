//
//  PublicImageCertificationView.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/6/8.
//  Copyright © 2018年 六域联盟. All rights reserved.
//

#import "PublicImageCertificationView.h"
@interface PublicImageCertificationView ()
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *refreshButton;
@end


@implementation PublicImageCertificationView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self){
        self = [super initWithFrame:frame];
    }
    return self;
}

-(void)showPaymentSecretInputView{
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication  sharedApplication].keyWindow addSubview:self];
        self.backGroundView.alpha = 0.5;
    }];
}

-(void)hidePaymentSecretInputView{
    [self  removeFromSuperview];
    
}

#pragma mark - getter

-(UIView *)backGroundView{
    if(!_backGroundView){
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backGroundView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePaymentSecretInputView)];
        [_backGroundView addGestureRecognizer:gesture];
        _backGroundView.alpha = 0;
    }
    return _backGroundView;
}

-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-kWidth(50), kHeight(160))];
    }
    return _imageView;
}

-(UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(kWidth(25), kHeight(160), WIDTH-kWidth(50), kHeight(210))];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 2;
    }
    return _contentView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
