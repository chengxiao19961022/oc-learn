//
//  wyJudgeView.h
//  TheGenericVersion
//
//  Created by glavesoft on 16/9/20.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , judgeReasonType){
    judgeReasonTypeUser  =  3,
    judgeReasonTypeRend
};

@class wyModelReason;

typedef void(^judgeViewClick)(wyModelReason *model);

@interface wyJudgeView : UIView

//必须要穿的
- (void)RenderViewWithType:(judgeReasonType )type;

@property (copy , nonatomic) judgeViewClick click;

//required
@property (assign , nonatomic) judgeReasonType type;


@end
