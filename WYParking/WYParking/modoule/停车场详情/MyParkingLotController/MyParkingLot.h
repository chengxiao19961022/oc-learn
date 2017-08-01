//
//  MyParkingLot.h
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

@interface MyParkingLot : WYViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *labMyStaff;
@property (weak, nonatomic) IBOutlet UILabel *labRelationLot;
@property (weak, nonatomic) IBOutlet UILabel *labGoOutVoucher;
@property (weak, nonatomic) IBOutlet UIView *bottomView1;
@property (weak, nonatomic) IBOutlet UIView *bottomView2;
@property (weak, nonatomic) IBOutlet UIView *bottomView3;
@property (weak, nonatomic) IBOutlet UIView *headView;

//必须
@property (copy , nonatomic) NSString *parklot_id;


@end
