//
//  MyParkingLotCollDataSource.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "MyParkingLotCollDataSource.h"
#import "MyStaffCell.h"
#import "MyStaffModel.h"

//static NSString * cellId=@"myStaffCellID";

@implementation MyParkingLotCollDataSource



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_array.count == 0) {
        return 1;
    }else
    {
        return _array.count + 1;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = [NSString stringWithFormat:@"cellID%ld",indexPath.item];
    UINib * nib=[UINib nibWithNibName:@"MyStaffCell" bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    MyStaffCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    if (indexPath.item < _array.count)
    {
         cell.nameLab.hidden=NO;
        MyStaffModel *mdl = _array[indexPath.item];
        cell.nameLab.text = mdl.employeeName;
        cell.sexImg.hidden = NO;
        if ([mdl.sex isEqualToString:@"1"]) {
            //女
            cell.sexImg.image = [UIImage imageNamed:@"myparkinglot_woman"];
        }else{
            cell.sexImg.image = [UIImage imageNamed:@"myparkinglot_man"];
        }
        
        if ([mdl.isInEditState isEqualToString:@"1"]) {
            cell.deleteImg.hidden = NO;
        }else if ([mdl.isInEditState isEqualToString:@"0"])
        {
            cell.deleteImg.hidden = YES;
        }
        [cell.logoImg setImageWithURL:[NSURL URLWithString:mdl.imageUrl] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            ;
        }];
        
    }else if (indexPath.item == _array.count) {
        cell.logoImg.image = [UIImage imageNamed:@"myparkinglot_tc_jh"];
        cell.deleteImg.hidden = YES;
        cell.nameLab.hidden=YES;
        cell.sexImg.hidden=YES;
    }
    
    return cell;
}


@end
