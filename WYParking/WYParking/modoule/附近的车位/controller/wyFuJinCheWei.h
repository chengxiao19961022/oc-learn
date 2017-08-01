//
//  wyFuJinCheWei.h
//  WYParking
//
//  Created by glavesoft on 17/2/28.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@class wyModelHistory;

@interface wyFuJinCheWei : WYViewController

@property (strong , nonatomic) AMapTip *tip;

@property (strong , nonatomic) wyModelHistory *history;

- (void)RenderWithIsSearch:(BOOL)isSearch withAddress:(NSString *)address;//如果是点击搜索 或者点击上个页面调用的高德api的数据源

//@property (assign , nonatomic) CLLocationCoordinate2D coordinate2d;

@end
