//
//  wyAddTimeAndPriceVC.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/6.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYModelPush.h"
#import "WYViewController.h"

@interface wyAddTimeAndPriceVC : WYViewController


@property (assign , nonatomic) BOOL isNeedRefresh;//判断是否需要重新刷接口获得时间段数据

@property (assign , nonatomic) BOOL isFormParkSpotManger;

@property (assign , nonatomic) BOOL isNeedShow;

@property (strong , nonatomic) WYModelPush *push;


@end
