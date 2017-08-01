//
//  Utils.m
//  LBPersonalProject
//
//  Created by Leon on 16/9/21.
//  Copyright © 2016年 Leon. All rights reserved.
//

#import "Utils.h"


@implementation Utils

+ (NSString *)toJSONString:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
        
    }else{
        return nil;
    }
}

+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

// push并添加push动画
+ (void)setNavigationControllerPushWithAnimation :(UIViewController*)current timingFunction:(KYNaviAnimationTimingFunction)timingFunction type:(KYNaviAnimationType)type subType:(KYNaviAnimationDirection)subType duration:(CFTimeInterval)duration target:(UIViewController*)target{
    
    CAAnimation*animation=[self animationWithType:type direction:subType  timingFunction:timingFunction duration:duration];
    
    [current.navigationController.view.layer addAnimation:animation forKey:@"NavigationPushAnimation"];
    
    [current.navigationController pushViewController:target animated:NO];
    
    [current.navigationController.view.layer removeAnimationForKey:@"NavigationPushAnimation"];
}

// pop到固定view并添加pop对象
+ (void)setNavigationControllerPopWithAnimation:(UIViewController *)current timingFunction:(KYNaviAnimationTimingFunction)timingFunction type:(KYNaviAnimationType)type subType:(KYNaviAnimationDirection)subType duration:(CFTimeInterval)duration target:(UIViewController *)target{
    CAAnimation*animation=[self animationWithType:type direction:subType  timingFunction:timingFunction duration:duration];
    
    [current.navigationController.view.layer addAnimation:animation forKey:@"NavigationPushAnimation"];
    
    [current.navigationController popToViewController:target animated:NO];
    
    [current.navigationController.view.layer removeAnimationForKey:@"NavigationPopAnimation"];
    
}

+ (CAAnimation *)animationWithType:(KYNaviAnimationType)animationType direction:(KYNaviAnimationDirection)direction timingFunction:(KYNaviAnimationTimingFunction)timingFunction duration:(CFTimeInterval)duration{
    
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:duration];
    
    switch (animationType) {
            
        case KYNaviAnimationTypeFade:
            
            animation.type = kCATransitionFade; //淡化
            
            break;
            
        case KYNaviAnimationTypePush:
            
            animation.type = kCATransitionPush; //推挤
            
            break;
            
        case KYNaviAnimationTypeReveal:
            
            animation.type = kCATransitionReveal; //揭开
            
            break;
            
        case KYNaviAnimationTypeMoveIn:
            
            animation.type = kCATransitionMoveIn;//覆盖
            
            break;
            
        case KYNaviAnimationTypeCube:
            
            animation.type = @"cube";   //立方体
            
            break;
            
        case KYNaviAnimationTypeSuck:
            
            animation.type = @"suckEffect"; //吸收
            
            break;
            
        case KYNaviAnimationTypeSpin:
            
            animation.type = @"oglFlip";    //旋转
            
            break;
            
        case KYNaviAnimationTypeRipple:
            
            animation.type = @"rippleEffect";   //波纹
            
            break;
            
        case KYNaviAnimationTypePageCurl:
            
            animation.type = @"pageCurl";   //翻页
            
            break;
            
        case KYNaviAnimationTypePageUnCurl:
            
            animation.type = @"pageUnCurl"; //反翻页
            
            break;
            
        case KYNaviAnimationTypeCameraOpen:
            
            animation.type = @"cameraIrisHollowOpen";   //镜头开
            
            break;
            
        case KYNaviAnimationTypeCameraClose:
            
            animation.type = @"cameraIrisHollowClose";  //镜头关
            
            break;
            
        default:
            
            animation.type = kCATransitionFade; //推挤
            
            break;
            
    }
    
    switch (direction) {
            
        case KYNaviAnimationDirectionFromLeft:
            
            animation.subtype = kCATransitionFromLeft;
            
            break;
            
        case KYNaviAnimationDirectionFromRight:
            
            animation.subtype = kCATransitionFromRight;
            
            break;
            
        case KYNaviAnimationDirectionFromTop:
            
            animation.subtype = kCATransitionFromTop;
            
            break;
            
        case KYNaviAnimationDirectionFromBottom:
            
            animation.subtype = kCATransitionFromBottom;
            
            break;
            
        default:
            
            break;
            
    }
    
    switch (timingFunction) {
            
        case KYNaviAnimationTimingFunctionLinear:
            
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            
            break;
            
        case KYNaviAnimationTimingFunctionEaseIn:
            
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            
            break;
            
        case KYNaviAnimationTimingFunctionEaseOut:
            
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
            break;
            
        case KYNaviAnimationTimingFunctionEaseInEaseOut:
            
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            
            break;
            
        default:
            
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
            
            break;
            
    }
    
    return animation;
}

//从view上截取一张UIImage
+ (UIImage *)getImage:(CGSize)size view:(UIView*)view
{
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);  //NO，YES 控制是否透明
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 生成后的image
    return image;
}


+ (CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}



+ (UIImage*)createImageWithColor: (UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


+ (void)writeRegister_id:(NSString *)str{
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"register_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getRegisterID{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSString *str = [de objectForKey:@"register_id"];
    if (str == nil || [str isEqualToString:@""]) {
        str = @"";
    }
    return str;
}

+ (CGFloat)heightForText:(NSString *)text width:(float)width fontSize:(float)fontSize
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
}

+ (BOOL)verifyPwd:(NSString *)pwd{
   
//
     BOOL result = NO;
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
     result = [predicate evaluateWithObject:pwd];
    if (!(6 <= pwd.length && pwd.length<=12) ) {
        result = NO;
    }
    return result;
}

//验证手机号
+ (BOOL)verifyPhone:(NSString *)Phone{
    BOOL result = NO;
    NSString *regex = @"^[0-9]+$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    result = [predicate evaluateWithObject:Phone];
    if (Phone.length != 11) {
        result = NO;
    }
    return result;
}

//验证昵称
+ (BOOL)verifyNick:(NSString *)Nick{
    BOOL result = NO;
    if (Nick.length == 0) {
        result = NO;
    }else{
        result = YES;
    }
    return result;
}

//验证推荐码
+ (BOOL)verifyRecommendCode:(NSString *)RecommendCode{
    BOOL result = NO;
    if (RecommendCode.length != 6) {
        result = NO;
    }else{
        result = YES;
    }
    return result;
}

//验证车牌号
+ (BOOL)verifyChePaiHao:(NSString *)chePaiHao{
    BOOL result = NO;
    if (chePaiHao.length < 5) {
        result = NO;
    }else{
        result = YES;
    }
    return result;
}



@end
