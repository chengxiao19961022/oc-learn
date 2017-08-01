//
//  WYSearchBtn.m
//  WYParking
//
//  Created by glavesoft on 17/2/8.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYSearchBtn.h"

@implementation WYSearchBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self ;
}

- (void)configStyle{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(19);
        make.top.left.mas_equalTo(7);
        make.bottom.mas_equalTo(-7);
    }];
    imageView.image = [UIImage imageNamed:@"tc_search"];
    
    UILabel *lab = UILabel.new;
    lab.text = @"地址";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor whiteColor];
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(4);
        make.centerY.equalTo(imageView.mas_centerY);
        make.right.mas_equalTo(-10);
    }];
    self.labAddress = lab;
    
}

@end
