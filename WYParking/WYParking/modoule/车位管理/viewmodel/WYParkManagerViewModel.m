//
//  WYParkManagerViewModel.m
//  WYParking
//
//  Created by glavesoft on 17/3/11.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYParkManagerViewModel.h"

@implementation WYParkManagerViewModel

- (void)releaseParkWithToken:(NSString *)token pic:(NSString *)pic park_title:(NSString *)park_title address:(NSString *)address lat:(NSString *)lat lnt:(NSString *)lnt addr_note:(NSString *)addr_note parklot_id:(NSString *)parklot_id park_type:(NSString *)park_type json_saletimes:(NSString *)json_saletimes park_id:(NSString *)park_id success:(complete)successBlock{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot3/releaseparking", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:token forKey:@"token"];
    [paramsDict setObject:pic forKey:@"pic"];
    [paramsDict setObject:park_title forKey:@"park_title"];
    [paramsDict setObject:lat forKey:@"lat"];
    [paramsDict setObject:lnt forKey:@"lnt"];
    [paramsDict setObject:addr_note forKey:@"addr_note"];
    [paramsDict setObject:parklot_id forKey:@"parklot_id"];
    [paramsDict setObject:park_type forKey:@"park_type"];
    [paramsDict setObject:json_saletimes forKey:@"json_saletimes"];
    [paramsDict setObject:address forKey:@"address"];
    [paramsDict setObject:park_id forKey:@"park_id"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            successBlock(YES,@"");
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
