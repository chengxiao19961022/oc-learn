//
//  UIImage+ImageEffects.h
//  blur
//
//  Created by 刘强 on 16/1/19.
//  Copyright © 2016年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
