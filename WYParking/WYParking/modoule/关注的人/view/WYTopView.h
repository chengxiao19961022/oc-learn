//
//  WYRendountTopView.h
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , type) {
    typeWoGuanZhuDe = 0, //车位
    typeGuanZhuWoDe  //停车场
};

@interface WYTopView : UIView

@property (nonatomic , weak) UIButton *selectedBtn;

@property (assign , nonatomic) NSString  *type;

@end
