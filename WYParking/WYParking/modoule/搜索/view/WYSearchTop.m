//
//  WYSearchTop.m
//  WYParking
//
//  Created by glavesoft on 17/2/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYSearchTop.h"

@implementation WYSearchTop

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"tc_search"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1);
        make.centerY.equalTo(imageView.superview);
        make.width.height.mas_equalTo(19);
    }];
    
    UITextField *tfAddress = [[UITextField alloc] init];
    tfAddress.placeholder = @"地址：";
    [tfAddress setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:tfAddress];
    [tfAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(0);
        make.centerY.equalTo(imageView.mas_centerY);
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
    }];
    tfAddress.borderStyle = UITextBorderStyleNone;
    tfAddress.textColor = [UIColor whiteColor];
    tfAddress.font = [UIFont systemFontOfSize:15];
    self.TFAddress = tfAddress;
    
}


@end
