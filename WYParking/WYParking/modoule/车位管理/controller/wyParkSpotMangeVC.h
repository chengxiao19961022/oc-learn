//
//  wyParkSpotMangeVC.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/9.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"
typedef void (^block)(BOOL isNeedRefresh);

@interface wyParkSpotMangeVC : WYViewController

@property (copy , nonatomic) NSString *park_id;//required

@property (copy , nonatomic) block refreshBlock;//上一个页面是否需要刷新

@property (assign , nonatomic) BOOL isNeedFresh;

@end
