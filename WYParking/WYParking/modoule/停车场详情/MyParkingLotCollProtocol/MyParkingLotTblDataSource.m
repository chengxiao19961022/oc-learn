//
//  MyParkingLotTblDataSource.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/17.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "MyParkingLotTblDataSource.h"
#import "GoOutVoucherCell.h"
#import "RelationLotCell.h"
#import "wyModelTCCGuanlianChewei.h"

@implementation MyParkingLotTblDataSource
//835673070

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([self.type isEqualToString:@"1"]) {
        static NSString *identifer=@"cell";
        RelationLotCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell= (RelationLotCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"RelationLotCell" owner:self options:nil]  lastObject];
          
        }
        wyModelTCCGuanlianChewei *m = [self.array objectAtIndex:indexPath.row];
        cell.labBuilding.text = m.park_title;
        cell.labDistance.text = m.distance;
        [cell.imageViewPic setImageWithURL:[NSURL URLWithString:m.pic] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable kimage, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            ;
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }else
    {
        static NSString *identifer=@"cell";
        GoOutVoucherCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell= (GoOutVoucherCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"GoOutVoucherCell" owner:self options:nil]  lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell renderViewWithModel:[self.array objectAtIndex:indexPath.row]];
        
        
        return cell;
    }
    
    



}


@end
