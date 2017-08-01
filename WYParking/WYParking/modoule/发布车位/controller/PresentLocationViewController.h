//
//  PresentLocationViewController.h
//  TheGenericVersion
//
//  Created by Glavesoft on 16/1/6.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "WYViewController.h"



@interface PresentLocationViewController : WYViewController<MAMapViewDelegate, AMapSearchDelegate>


@property (weak, nonatomic) IBOutlet UIView *mapBottomView;


@property (nonatomic, strong) AMapSearchAPI *search;
@property (weak, nonatomic) IBOutlet UITextField *searchText;


@property (copy,nonatomic) NSString *selectedLatitude;
@property (copy,nonatomic) NSString *selectedLongitude;
@property (copy,nonatomic) NSString *selectedAddress;

@property (nonatomic, copy)void(^selectAddressCompleteBlock)(void);



@end
