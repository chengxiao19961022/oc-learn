//
//  wyRefuseAlertView.h
//  TheGenericVersion
//
//  Created by glavesoft on 16/9/5.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^alertViewClickBlock)(BOOL isClick,BOOL isEnsure,NSString *reason);
typedef NS_ENUM(NSInteger,contentsType){
    contentsTypeRefuse = 1,     //拒绝短语
    contentsTypeUnsubscribe,    //退订短语
    contentsTypeJudge           //评论短语
};

@interface wyRefuseAlertView : UIView

@property (copy , nonatomic) alertViewClickBlock clickBlock;

- (void)renderViewWithType:(contentsType)type;

@end
