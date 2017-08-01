//
//  wyParkAnnotation.m
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/10.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "wyParkAnnotation.h"
@interface wyParkAnnotation()


@end

@implementation wyParkAnnotation

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    if (self.selected == selected){
//        return;
//    }
    if (selected){
        if (self.callOutView == nil){
            wyParkCallOutView *calloutView = wyParkCallOutView.new;
            calloutView.frame = CGRectMake(0, -85, 190, 90);
            self.callOutView = calloutView;
            [self addSubview:calloutView];
            [calloutView renderViewWithModel:self.park_model];
        }
    } else{
        [self.callOutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}



@end
