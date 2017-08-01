//
//  Utils.h
//  LBPersonalProject
//
//  Created by Leon on 16/9/21.
//  Copyright © 2016年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    KYNaviAnimationTypeFade          = 0,//淡化
    KYNaviAnimationTypePush          = 1,//推挤
    KYNaviAnimationTypeReveal        = 2,//揭开
    KYNaviAnimationTypeMoveIn        = 3,//覆盖
    KYNaviAnimationTypeCube          = 4,//立方体
    KYNaviAnimationTypeSuck          = 5,//吸收
    KYNaviAnimationTypeSpin          = 6,//旋转
    KYNaviAnimationTypeRipple        = 7,//波纹
    KYNaviAnimationTypePageCurl      = 8,//翻页
    KYNaviAnimationTypePageUnCurl    = 9,//反翻页
    KYNaviAnimationTypeCameraOpen    = 10,//镜头开
    KYNaviAnimationTypeCameraClose   = 11,//镜头关
    KYNaviAnimationTypeCameraDefault = 12,//默认淡化
} KYNaviAnimationType;

typedef enum : NSUInteger {
    
    KYNaviAnimationDirectionFromLeft   = 0,
    KYNaviAnimationDirectionFromRight  = 1,
    KYNaviAnimationDirectionFromTop    = 2,
    KYNaviAnimationDirectionFromBottom = 3,
    KYNaviAnimationDirectionDefault    = 4,
} KYNaviAnimationDirection;

typedef enum : NSUInteger {
    
    KYNaviAnimationTimingFunctionLinear        = 0,
    KYNaviAnimationTimingFunctionEaseIn        = 1,
    KYNaviAnimationTimingFunctionEaseOut       = 2,
    KYNaviAnimationTimingFunctionEaseInEaseOut = 3,
    KYNaviAnimationTimingFunctionDefault       = 4,
} KYNaviAnimationTimingFunction;


@interface Utils : NSObject

//转json
+ (NSString *)toJSONString:(id)theData;

//date转string
+ (NSString*)stringFromDate:(NSDate *)date;

//string转NSDate
+ (NSDate*)dateFromString:(NSString *)string;

//截图
+ (UIImage *)getImage:(CGSize)size view:(UIView*)view;

//vc动画 － by core Animation
+ (void)setNavigationControllerPushWithAnimation :(UIViewController*)current timingFunction:(KYNaviAnimationTimingFunction)timingFunction type:(KYNaviAnimationType)type subType:(KYNaviAnimationDirection)subType duration:(CFTimeInterval)duration target:(UIViewController*)target;

+ (void)setNavigationControllerPopWithAnimation :(UIViewController*)current timingFunction:(KYNaviAnimationTimingFunction)timingFunction type:(KYNaviAnimationType)type subType:(KYNaviAnimationDirection)subType duration:(CFTimeInterval)duration target:(UIViewController*)target;

//计算一段文字的size
+ (CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font maxSize:(CGSize)maxSize;


//颜色转图片
+ (UIImage*)createImageWithColor: (UIColor*)color;

+ (NSString *)getRegisterID;

+ (void)writeRegister_id:(NSString *)str;

+ (CGFloat)heightForText:(NSString *)text width:(float)width fontSize:(float)fontSize;

//验证密码格式
+ (BOOL)verifyPwd:(NSString *)pwd;

//验证手机号
+ (BOOL)verifyPhone:(NSString *)Phone;

//验证昵称
+ (BOOL)verifyNick:(NSString *)Nick;

//验证推荐码
+ (BOOL)verifyRecommendCode:(NSString *)RecommendCode;

//验证推荐码
+ (BOOL)verifyChePaiHao:(NSString *)chePaiHao;

@end
