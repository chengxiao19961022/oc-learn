//
//  CarBrandsViewController.h
//  WYParking
//
//  Created by glavesoft on 17/3/11.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarBrandsViewControllerDelegate <NSObject>

-(void)chooseCarBrandsId:(NSString *)brandId brandName:(NSString *)name;

@end

@interface CarBrandsViewController : UIViewController

@property(nonatomic,weak)id<CarBrandsViewControllerDelegate>delegate;

@end
