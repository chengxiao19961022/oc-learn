//
//  MyParkingLotVM.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "MyParkingLotVM.h"
#import "MyStaffModel.h"
#import "wyModelEmpolyee.h"
#import "wyModelTCCGuanlianChewei.h"
#import "WYModelCMT.h"

@implementation MyParkingLotVM


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)sendMyStaffRequestWithsendMyStaffRequestWithparkLotId:(NSString *)parklot_id Callback:(callback)callback
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/stafflist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:parklot_id forKey:@"parklot_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSMutableArray *dataSourceArr = [NSMutableArray array];
            NSArray<wyModelEmpolyee *> *arr = [wyModelEmpolyee mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            if (arr.count == 0) {
                [keyWindow makeToast:@"暂无员工"];
            }
            [arr enumerateObjectsUsingBlock:^(wyModelEmpolyee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *sex = @"";
                if ([obj.sex isEqualToString:@"1"]) {
                    sex = @"0";
                }else{
                    sex = @"1";
                }
                 MyStaffModel *mdl = [[MyStaffModel alloc]initWithEmployeeName:obj.name imageUrl:obj.pic isInEditState:@"0" sex:sex lotUser_id:obj.lotuser_id];
                [dataSourceArr addObject:mdl];
            }];
            callback(dataSourceArr);
            
            
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [keyWindow makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];

}


- (void)sendRelationLotRequestWithParkLotid:(NSString *)parklot_id lat:(NSString *)lat lnt:(NSString *)lnt Callback:(callback)callback
{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/associatedparking", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    token	是	string	用户名凭证
//    parklot_id	是	string	停车场id
//    lat	是	string	地址维度
//    lnt	是	string	地址经度
//    page	是	int	页数	默认1
//    limit	是	int	每页限制
     [paramsDict setObject:parklot_id forKey:@"parklot_id"];
     [paramsDict setObject:lat forKey:@"lat"];
     [paramsDict setObject:lnt forKey:@"lnt"];
     [paramsDict setObject:@"1" forKey:@"page"];
    [paramsDict setObject:@"10000" forKey:@"limit"];
     [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSArray<wyModelTCCGuanlianChewei *> *arr = [wyModelTCCGuanlianChewei mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            if (arr.count == 0) {
                [keyWindow makeToast:@"暂时关联车位数据"];
            }
            
            callback(arr);
            
            
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [keyWindow makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];

    
}

- (void)sendGoOutVoucherRequestWithParkLot_id:(NSString *)parklot_id Callback:(callback)callback
{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/entrylist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
//    parklot_id	否	int	停车场id
//    plate_nu	否	string	车牌号
//    page	否	int	页数1 默认1
//    limit	否	int	限制 默认10
    if (!([[wyLogInCenter shareInstance].sessionInfo.plate_nu isEqualToString:@""]||[wyLogInCenter shareInstance].sessionInfo.plate_nu == nil)) {
         [paramsDict setObject:parklot_id forKey:@"parklot_id"];
    }
    [paramsDict setObject:@"1" forKey:@"page"];
    [paramsDict setObject:@"10000" forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSMutableArray *dataSourceArr = [NSMutableArray array];
            NSArray<WYModelCMT *> *arr = [WYModelCMT mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            if (arr.count == 0) {
                [keyWindow makeToast:@"暂无出门条数据"];
            }
            callback(arr);
            
            
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [keyWindow makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];

    
}



@end
