//
//  WYRendountTopView.h
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , type) {
    typeZhiChuMingXi = 0, //支出明细
    typeShouRUMingXi //收入明细
};

@interface WYMingXiTopView : UIView

@property (nonatomic , weak) UIButton *selectedBtn;

@property (assign , nonatomic) NSString  *type;

@end
