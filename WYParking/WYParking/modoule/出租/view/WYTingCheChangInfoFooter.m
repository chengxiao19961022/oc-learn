//
//  WYTingCheChangInfoFooter.m
//  WYParking
//
//  Created by glavesoft on 17/2/23.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYTingCheChangInfoFooter.h"

@interface WYTingCheChangInfoFooter ()


@end

@implementation WYTingCheChangInfoFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)view{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

@end


#pragma mark - 接收停车场数据
/*
- (void)oldfetchTingCheChangInfo{
    __block NSString *status_name = @"";
    //UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    //hud.mode = MBProgressHUDModeIndeterminate;
    //NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/parklotlist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        if (paramsDict == nil) {
            self.isTingCheChang = NO;
            if (self.isTingCheChang) {
                WYTingCheChangInfoFooter *footerView = [WYTingCheChangInfoFooter view];
                
                footerView.labStatus.hidden = NO;
                if ([status_name isEqualToString:@"审核中"]) {
                    footerView.labStatus.backgroundColor = [UIColor orangeColor];
                }else if([status_name isEqualToString:@"审核失败"]){
                    footerView.labStatus.backgroundColor = [UIColor redColor];
                }else{
                    footerView.labStatus.hidden = YES;
                }
                
                footerView.labStatus.text = status_name;
                footerView.labParkTitle.text =  self.park_info.building;
                footerView.height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                [footerView bk_whenTapped:^{
                    MyParkingLot *vc = MyParkingLot.new;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                self.tbView.tableFooterView = footerView;
            }else{
                if (self.tingCheChangFooter == nil) {
                    WYBecomeTingCheChang *tingCheChangFooter = WYBecomeTingCheChang.new;
                    CGSize s = [tingCheChangFooter systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                    tingCheChangFooter.height = s.height;
                    self.tbView.tableFooterView = tingCheChangFooter;
                    self.tingCheChangFooter = tingCheChangFooter;
                    @weakify(self);
                    [tingCheChangFooter bk_whenTapped:^{
                        @strongify(self);
                        WYChuangJianTingCheChangVC *vc = WYChuangJianTingCheChangVC.new;
                        vc.refreshBlock = ^(BOOL needRefresh){
                            if (needRefresh) {
                                [self configTingCheChang];
                            }
                        };
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                }else{
                    self.tbView.tableFooterView = self.tingCheChangFooter;
                }
            }
        }else{
            if ([paramsDict[@"status"] isEqualToString:@"200"]) {
                self.park_info = [WYModelPark_info mj_objectWithKeyValues:paramsDict[@"data"]];
                if ([self.park_info.status isEqualToString:@""]) {
                    self.isTingCheChang = NO;//未申请
                }else if ([self.park_info.status isEqualToString:@"1"]){
                    //审核中
                    status_name = @"审核中";
                    self.isTingCheChang = YES;
                }else if ([self.park_info.status isEqualToString:@"2"]){
                    //审核成功
                    status_name = @"审核成功";
                    self.isTingCheChang = YES;
                }else if ([self.park_info.status isEqualToString:@"3"]){
                    //审核失败
                    status_name = @"";
                    self.isTingCheChang = YES;
                }
                
                if (self.isTingCheChang) {
                    WYTingCheChangInfoFooter *footerView = [WYTingCheChangInfoFooter view];
                    footerView.labStatus.hidden = NO;
                    if ([status_name isEqualToString:@"审核中"]) {
                        footerView.labStatus.backgroundColor = [UIColor orangeColor];
                    }else if([status_name isEqualToString:@"审核失败"]){
                        footerView.labStatus.backgroundColor = [UIColor redColor];
                    }else{
                        footerView.labStatus.hidden = YES;
                    }
                    
                    footerView.labStatus.text = status_name;
                    footerView.labParkTitle.text =  self.park_info.building;
                    footerView.height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                    [footerView bk_whenTapped:^{
                        if ([status_name isEqualToString:@"审核中"]) {
                            [self.view makeToast:@"停车场审核中"];
                            return ;
                        }
                        if ([self.park_info.is_employe isEqualToString:@"1"]) {
                            //是停车场员工
                            WYParkingIsEmployee *vc = WYParkingIsEmployee.new;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if ([self.park_info.is_employe isEqualToString:@"2"]){
                            //不是停车场员工
                            if ([footerView.labStatus.text isEqualToString:@"审核失败"]) {
                                WYChuangJianTingCheChangVC *vc = WYChuangJianTingCheChangVC.new;
                                @weakify(self);
                                vc.refreshBlock = ^(BOOL needRefresh){
                                    if (needRefresh) {
                                        @strongify(self);
                                        [self configTingCheChang];
                                    }
                                };
                                [vc renderWithType:vctypeEdit model:_park_info];
                                [self.navigationController pushViewController:vc animated:YES];
                            }else{
                                MyParkingLot *vc = MyParkingLot.new;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                            
                        }
                        
                    }];
                    self.tbView.tableFooterView = footerView;
                }else{
                    if (self.tingCheChangFooter == nil) {
                        WYBecomeTingCheChang *tingCheChangFooter = WYBecomeTingCheChang.new;
                        CGSize s = [tingCheChangFooter systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                        tingCheChangFooter.height = s.height;
                        self.tbView.tableFooterView = tingCheChangFooter;
                        self.tingCheChangFooter = tingCheChangFooter;
                        @weakify(self);
                        [tingCheChangFooter bk_whenTapped:^{
                            @strongify(self);
                            WYChuangJianTingCheChangVC *vc = WYChuangJianTingCheChangVC.new;
                            vc.refreshBlock = ^(BOOL needRefresh){
                                if (needRefresh) {
                                    [self configTingCheChang];
                                }
                            };
                            [self.navigationController pushViewController:vc animated:YES];
                        }];
                    }else{
                        self.tbView.tableFooterView = self.tingCheChangFooter;
                    }
                }
            }
            else if([paramsDict[@"status"] isEqualToString:@"104"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
            }
            else
            {
                [keyWindow makeToast:paramsDict[@"message"]];
            }
            
        }
        
        
    } failuer:^(NSError *error) {
        [self.tbView.mj_header endRefreshing];
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];
    
}
*/
