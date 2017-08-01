//
//  WYShareView.h
//  WYParking
//
//  Created by glavesoft on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , shareType) {
    shareTypeWXPYQ = 0,
    shareTypeWXHY ,
    shareTypeQQKJ ,
    shareTypeQQHY ,
    shareTypeWB
};

typedef void(^shareViewBlock)(shareType type);

@interface WYShareView : UIView

@property (copy , nonatomic) shareViewBlock shareblock;

@property (weak , nonatomic)  UIButton *btnCancel;

@end
