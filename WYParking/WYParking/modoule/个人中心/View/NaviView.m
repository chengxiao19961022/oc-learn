//
//  NaviView.m
//  WYParking
//
//  Created by admin on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "NaviView.h"

@implementation NaviView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    
    self.bgView = [[UIView alloc]initWithFrame:frame];
    [self.bgView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.bgView];
    
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 44, 44)];
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-5-44, 20, 44, 44)];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-150/2, 20, 150, 44)];
    self.titleLab.font = [UIFont systemFontOfSize:20.0f];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLab];
    
    return self;
}

@end
