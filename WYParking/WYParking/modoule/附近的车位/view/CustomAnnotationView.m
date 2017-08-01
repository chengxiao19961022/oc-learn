//
//  CustomAnnotationView.m
//  TheGenericVersion
//
//  Created by lijie on 16/2/29.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "CustomAnnotationView.h"

#define kCalloutWidth   50.0
#define kCalloutHeight  30.0

@interface CustomAnnotationView ()

@end

@implementation CustomAnnotationView


#pragma mark - Handle Action



- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.qiPaoView == nil)
        {
            /* Construct custom callout. */
            self.qiPaoView = [[QiPaoView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.qiPaoView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.qiPaoView.bounds) / 2.f + self.calloutOffset.y);

//背景图
            UIImageView *BgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.qiPaoView.width, self.qiPaoView.height)];
            [BgImage setImage:[UIImage imageNamed:@"ss_xxti"]];
            [self.qiPaoView addSubview:BgImage];

//            self.bgImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.qiPaoView.width, self.qiPaoView.height)];
//            [self.qiPaoView addSubview:self.bgImgV];

//            数量
            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(4,2,kCalloutWidth-8,kCalloutHeight-8)];
            nameLabel.textColor=[UIColor whiteColor];
            nameLabel.font=[UIFont fontWithName:@"Arial" size:15.0f];
            [nameLabel setTextAlignment:NSTextAlignmentCenter];
            nameLabel.text=[NSString stringWithFormat:@"%@",self.fjModel.count];
            [self.qiPaoView addSubview:nameLabel];
            
            if (self.SelectAnnBlock) {
                self.SelectAnnBlock();
            }

            
//            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAnn)];
//            [self addGestureRecognizer:tap];

        }
        
        [self addSubview:self.qiPaoView];
    }
    else
    {
        [self.qiPaoView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];

    if (!inside && self.selected)
    {
        inside = [self.qiPaoView pointInside:[self convertPoint:point toView:self.qiPaoView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
    }
    
    return self;
}

@end
