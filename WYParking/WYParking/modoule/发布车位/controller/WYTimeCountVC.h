//
//  WYTimeCountVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/20.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYModelPush.h"
#import "WYViewController.h"

@interface WYTimeCountVC : WYViewController

@property (strong , nonatomic) WYModelPush *push;


/**
 编辑时调用
 public
 @param isedit yes 修改，no 是发布车位添加新的，默认为NO
 @param index  所在row
 */
- (void)isEdit:(BOOL)isedit withIndexPathRow:(NSInteger)index;


@end
