//
//  wyAddTimeAndPriceBtn.m
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/9.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "wyAddTimeAndPriceBtn.h"


@implementation wyAddTimeAndPriceBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpStyle];
    }
    return self;
}

- (void)setUpStyle{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"tjsj_jg"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *label1 = UILabel.new;
    label1.text = @"点击添加时间价格";
    label1.font = [UIFont systemFontOfSize:15];
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(label1.superview.mas_centerY);
    }];
}

@end
