//
//  MyParkingLotTblDelegate.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/17.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "MyParkingLotTblDelegate.h"

@implementation MyParkingLotTblDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if ([self.type isEqualToString:@"1"]) {
        return 85;
    }else
    {
        return 236;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    
}



@end
