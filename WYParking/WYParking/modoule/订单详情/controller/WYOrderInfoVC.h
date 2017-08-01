//
//  WYOrderInfoVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wyModelHomeTop.h"
#import "WYModelMYOrder.h"
#import "WYViewController.h"

typedef void(^orderInfoBlock)(NSIndexPath *indexpath);

@interface WYOrderInfoVC : WYViewController


@property (strong , nonatomic) WYModelMYOrder *myorder;

@property (copy , nonatomic) orderInfoBlock orderBlock;

@property (assign , nonatomic) bool isFromJpush;

@property (strong , nonatomic) NSIndexPath *indexpath;

@property(nonatomic,copy)NSString *xitong;//是否从系统消息进入

@end
