//
//  CALayer+LayerColor.m
//  kdxyhd
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 zjw. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
