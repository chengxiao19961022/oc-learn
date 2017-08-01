//
//  MyParkingLotCollDelegate.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "MyParkingLotCollDelegate.h"
#import "MyStaffCell.h"

@implementation MyParkingLotCollDelegate


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    if (_valueBlock) {
        _valueBlock(indexPath);
    }
    
}



@end
