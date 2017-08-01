//
//  wyParkCallOutView.m
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/10.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "wyParkCallOutView.h"
#import "wyModelPark_map.h"
#define kArrorHeight    10

@interface wyParkCallOutView ()

@property (weak , nonatomic) UILabel *labParkTitle;



@end

@implementation wyParkCallOutView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpStyle];
    }
    return self;
}

- (void)setUpStyle{
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = RGBACOLOR(65, 213, 250, 1).CGColor;
    self.layer.borderWidth = 2.0;
    self.backgroundColor = [UIColor whiteColor];
    UILabel *labParkTitle = UILabel.new;
    labParkTitle.numberOfLines = 0;
    labParkTitle.preferredMaxLayoutWidth = 160;
    labParkTitle.text = @"停车场名称";
    [self addSubview:labParkTitle];
    labParkTitle.font = [UIFont systemFontOfSize:13];
    labParkTitle.frame = CGRectMake(10, 10, 170, 25);
    self.labParkTitle = labParkTitle;
    
    UILabel *labAddress = UILabel.new;
    labAddress.text = @"某某大街";
    labAddress.preferredMaxLayoutWidth = 160;
    labAddress.numberOfLines = 0;
    labAddress.font = [UIFont systemFontOfSize:13];
    [self addSubview:labAddress];
    self.labAddress = labAddress;
    labAddress.frame = CGRectMake(10, labParkTitle.bottom + 10, labParkTitle.width, labParkTitle.height);
    self.labAddress = labAddress;
}



- (void)renderViewWithModel:(wyModelPark_map *)model{
    self.labAddress.text = model.address;
    
    self.labParkTitle.text = model.building;
    self.labAddress.height = [Utils heightForText:model.address width:self.labParkTitle.width fontSize:13];
    self.labAddress.height = [Utils heightForText:model.address width:self.labAddress.width fontSize:13]+10;
    self.height = self.labAddress.bottom + 10;
}

@end
