//
//  wyPayShareView.m
//  WYParking
//
//  Created by glavesoft on 17/3/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "wyPayShareView.h"

@implementation wyPayShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)view{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:0].lastObject;
}

@end
