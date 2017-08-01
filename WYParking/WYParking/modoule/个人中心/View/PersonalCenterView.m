//
//  PersonalCenterView.m
//  WYParking
//
//  Created by admin on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "PersonalCenterView.h"

@implementation PersonalCenterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.view3.line.hidden = YES;
    self.view6.line.hidden = YES;
    
//    self.view2.IconImg.image = [UIImage imageNamed:@"grzx_yhq"];
//    self.view3.IconImg.image = [UIImage imageNamed:@"grzx_gz"];
//    self.view4.IconImg.image = [UIImage imageNamed:@"grzx_dd"];
//    self.view5.IconImg.image = [UIImage imageNamed:@"grzx_cmt"];
//    self.view6.IconImg.image = [UIImage imageNamed:@"grzx_tjdr"];

    self.view2.IconImg.image = [UIImage imageNamed:@"grzx_zj"];
    self.view3.IconImg.image = [UIImage imageNamed:@"grzx_yhq"];
    self.view4.IconImg.image = [UIImage imageNamed:@"grzx_gz"];
    self.view5.IconImg.image = [UIImage imageNamed:@"grzx_cmt"];
    self.view6.IconImg.image = [UIImage imageNamed:@"grzx_tjdr"];
    
//    self.view2.lab2.text = @"优惠券";
//    self.view3.lab2.text = @"关注";
//    self.view4.lab2.text = @"订单";
//    self.view5.lab2.text = @"出门条";
//    self.view6.lab2.text = @"推荐的人";
    
    self.view2.lab2.text = @"资金";
    self.view3.lab2.text = @"优惠券";
    self.view4.lab2.text = @"关注";
    self.view5.lab2.text = @"出门条";
    self.view6.lab2.text = @"推荐的人";
    
    self.view4.IconY_Layout.constant = -20;
    self.view5.IconY_Layout.constant = -20;
    self.view6.IconY_Layout.constant = -20;
    self.view4.LineY_Layout.constant = 5;
    self.view5.LineY_Layout.constant = 5;
    self.view6.LineY_Layout.constant = 5;
    
    self.TouxiangImg.layer.cornerRadius = self.TouxiangImg.height/2.f;
    self.TouxiangImg.layer.masksToBounds = YES;

    self.SexIcon.clipsToBounds = YES;
    
    
    
    
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTap1:)];
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTap2:)];
    UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTap3:)];
    UITapGestureRecognizer* tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTap4:)];
    UITapGestureRecognizer* tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTap5:)];
    UITapGestureRecognizer* tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTap6:)];

    [self.view1 addGestureRecognizer:tap1];
    [self.view2 addGestureRecognizer:tap2];
    [self.view3 addGestureRecognizer:tap3];
    [self.view4 addGestureRecognizer:tap4];
    [self.view5 addGestureRecognizer:tap5];
    [self.view6 addGestureRecognizer:tap6];
    
}


- (void)handTap1:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(clickview1)])
    {
        [self.delegate clickview1];
    }
}

- (void)handTap2:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(clickview2)])
    {
        [self.delegate clickview2];
    }
}

- (void)handTap3:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(clickview3)])
    {
        [self.delegate clickview3];
    }
}

- (void)handTap4:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(clickview4)])
    {
        [self.delegate clickview4];
    }
}

- (void)handTap5:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(clickview5)])
    {
        [self.delegate clickview5];
    }
}

- (void)handTap6:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(clickview6)])
    {
        [self.delegate clickview6];
    }
}

@end
