//
//  MyParkingLotTblDataSource.h
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/17.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyParkingLotTblDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,strong) NSArray *array;
@property (nonatomic,copy) NSString *type;

@end
