//
//  PersonalCenterView.h
//  WYParking
//
//  Created by admin on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalItemView.h"

@protocol PersonalCenterViewDelegate <NSObject>

- (void)clickview1;
- (void)clickview2;
- (void)clickview3;
- (void)clickview4;
- (void)clickview5;
- (void)clickview6;


@end



@interface PersonalCenterView : UIView
@property (weak, nonatomic) IBOutlet PersonalItemView *view1;
@property (weak, nonatomic) IBOutlet PersonalItemView *view2;
@property (weak, nonatomic) IBOutlet PersonalItemView *view3;
@property (weak, nonatomic) IBOutlet PersonalItemView *view4;
@property (weak, nonatomic) IBOutlet PersonalItemView *view5;
@property (weak, nonatomic) IBOutlet PersonalItemView *view6;

@property (weak, nonatomic) IBOutlet UIImageView *TouxiangImg;
@property (weak, nonatomic) IBOutlet UILabel *NameLab;
@property (weak, nonatomic) IBOutlet UIImageView *SexIcon;
@property (weak, nonatomic) IBOutlet UILabel *TuijianmaLab;
@property (weak, nonatomic) IBOutlet UIImageView *BgImgView;

@property (nonatomic, weak) id<PersonalCenterViewDelegate> delegate;

@end
