//
//  wyJugeVC.h
//  TheGenericVersion
//
//  Created by glavesoft on 16/10/9.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wyJudgeView.h"
#import "WYViewController.h"

typedef void (^judgeBlock)(CGPoint point);
typedef void (^judgeDoneBlock)(BOOL isDone);


@interface wyJugeVC : WYViewController

//必须要传的
@property (copy , nonatomic) NSString *order_id;

@property (assign , nonatomic) BOOL orderIsJudged;

@property (copy , nonatomic) judgeBlock contentSizeBlock;

@property (assign , nonatomic) CGPoint point;

@property (copy , nonatomic) judgeDoneBlock isDone;

@property (assign , nonatomic) judgeReasonType type;

@end
