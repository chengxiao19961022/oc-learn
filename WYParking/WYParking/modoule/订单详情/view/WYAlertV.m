//
//  WYAlertV.m
//  WYParking
//
//  Created by glavesoft on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYAlertV.h"

@implementation WYAlertV

- (void)awakeFromNib{
    [super awakeFromNib];
   self.layer.contents = (id)[UIImage imageNamed:@"ddxq_kk"].CGImage;
}

+ (instancetype)view{
    WYAlertV *obj = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    
    return obj;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
