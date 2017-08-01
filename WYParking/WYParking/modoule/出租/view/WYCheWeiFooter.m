//
//  WYCheWeiFooter.m
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYCheWeiFooter.h"

@implementation WYCheWeiFooter

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *labTitle = UILabel.new;
    [self addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(labTitle.superview);
    }];
    labTitle.textColor = RGBACOLOR(83, 132, 213, 1);
    labTitle.font = [UIFont systemFontOfSize:14];
    labTitle.text = @"发布车位";
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"tjsj_jg"];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-20);
    }];
    
    UIView *line = UIView.new;
    line.backgroundColor = RGBACOLOR(234, 234, 234, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

@end
