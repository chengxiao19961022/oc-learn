//
//  WYHomeNavigationBar.m
//  WYParking
//
//  Created by glavesoft on 17/2/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYHomeNavigationBar.h"

@implementation WYHomeNavigationBar


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];;
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.centerY.equalTo(btn.superview);
    }];
}


@end
