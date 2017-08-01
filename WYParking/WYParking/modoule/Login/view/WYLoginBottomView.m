//
//  WYLoginBottomView.m
//  WYParking
//
//  Created by glavesoft on 17/2/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYLoginBottomView.h"

@implementation WYLoginBottomView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    UILabel *labelD = UILabel.new;
    [self addSubview:labelD];
    [labelD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    labelD.text = @"创建帐号(登录)前，请认真阅读";
    labelD.textColor = [UIColor whiteColor];
    labelD.textAlignment = NSTextAlignmentCenter;
    labelD.font = [UIFont systemFontOfSize:14];
    
    UIButton *btn = UIButton.new;
    btn.enabled = NO;
    [btn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [btn setTitleColor:RGBACOLOR(227, 176, 90, 1) forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelD.mas_right);
        make.centerY.equalTo(labelD);
        make.right.mas_equalTo(0);
    }];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btn = btn;
 
}

@end
