//
//  WYRendountTopView.h
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , renoutVcType) {
    renoutVcTypeCarSpot = 0, //车位
    renoutVcTypeSpot  //停车场
};

@interface WYRendountTopView : UIView

@property (nonatomic , weak) UIButton *selectedBtn;

@property (assign , nonatomic) NSString  *type;

@end
