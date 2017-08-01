//
//  WYRendoutVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

@interface WYRendoutVC : WYViewController

@property (strong , nonatomic) NSMutableArray *cheweiDataSource;//车位队列，可添加多种车位
@property (strong , nonatomic) NSMutableArray *tingchechangDataSource;//停车场队列，可添加多个停车场***

@end
