//
//  MyParkingLotCollDelegate.h
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^valueBlock)(NSIndexPath *indexPath);  //接上接口后这边返回值为对应实体

@interface MyParkingLotCollDelegate : NSObject<UICollectionViewDelegate>


@property (nonatomic,strong) NSArray *array;

@property(nonatomic,copy)valueBlock valueBlock;


@end
