//
//  TabBarButton.m
//  ZhaoQiPei
//
//  Created by 找汽配 on 16/5/19.
//  Copyright © 2016年 祥运. All rights reserved.
//

#import "TabBarButton.h"

@implementation TabBarButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake((CGRectGetWidth(self.imageView.superview.frame) - CGRectGetWidth(self.imageView.frame)) * 0.5,
                                      0,
                                      CGRectGetWidth(self.imageView.frame),
                                      CGRectGetHeight(self.imageView.frame));
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((CGRectGetWidth(self.titleLabel.superview.frame) - CGRectGetWidth(self.titleLabel.frame)) * 0.5,
                                       CGRectGetHeight(self.titleLabel.superview.frame) - CGRectGetHeight(self.titleLabel.frame),
                                       CGRectGetWidth(self.titleLabel.frame),
                                       CGRectGetHeight(self.titleLabel.frame));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
