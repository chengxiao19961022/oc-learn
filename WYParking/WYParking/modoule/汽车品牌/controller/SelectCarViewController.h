//
//  SelectCarViewController.h
//  TheGenericVersion
//
//  Created by Glavesoft on 16/1/11.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

@interface SelectCarViewController : WYViewController


@property (nonatomic, copy)void(^selectCarCompleteBlock)(void);

@property (copy,nonatomic) NSString *brand_id;
@property (copy,nonatomic) NSString *brand_name;


@end
