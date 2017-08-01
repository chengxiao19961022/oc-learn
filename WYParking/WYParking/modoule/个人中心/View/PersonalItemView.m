//
//  PersonalItemView.m
//  WYParking
//
//  Created by admin on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "PersonalItemView.h"

@implementation PersonalItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    [[NSBundle mainBundle]loadNibNamed:@"PersonalItemView"owner:self options:nil];
    [self addSubview:self.personalitemview];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.personalitemview.frame = rect;
}


@end
