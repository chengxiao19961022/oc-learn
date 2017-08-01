//
//  wyLogInCenter.m
//  WYParking
//
//  Created by Leon on 17/2/6.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "wyLogInCenter.h"

@interface wyLogInCenter ()


@end

@implementation wyLogInCenter

- (wyModelLogin *)sessionInfo{
    if (_sessionInfo == nil) {
        _sessionInfo = [[wyModelLogin alloc] init];
    }
    return _sessionInfo;
}

// 单例模式，意思是只能有一个实例对象存在，这边改变了那边的值也跟着改变
+ (instancetype)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static id _shareObject = nil;
    dispatch_once(&pred, ^{
        _shareObject = [[self alloc] init];
    });
    WYLog(@"%p",_shareObject);
    return _shareObject;
}

- (instancetype)init{
    if (self = [super init]) {
        //只有在初次登录的时候，是空的
        [self loadData];
        
        //avoid singleton dead-lock
        dispatch_async(dispatch_get_main_queue(), ^{
            [self registerAction];
        });
    }
    return self ;
}

- (void)registerAction{
    @weakify(self);
    [[RACObserve(self,loginstate) distinctUntilChanged] subscribeNext:^(NSNumber * x) {
        @strongify(self);
        NSInteger type = [x integerValue];
        if (type == wyLogInStateSuccess) {
            [self upDateUserInfo];
        }
    }];
}

- (void)upDateUserInfo{
    if (self.sessionInfo.token != nil) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/info", KSERVERADDRESS];
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        [paramsDict setObject:self.sessionInfo.token forKey:@"token"];
        
        
        
        [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
            
            if ([paramsDict[@"status"] isEqualToString:@"200"]) {
                NSLog(@"fsadfa");
                self.sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
                self.sessionInfo.isLatest = YES;
                
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
        }];
    }


}

- (void)loadData{
#define dataLoadProperty(key)\
{\
NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:NSStringFromSelector(@selector(key))];\
self.key = (id)[wyModeBase unArchiveWithData:data];\
}
    dataLoadProperty(sessionInfo);
    self.loginstate = [[NSUserDefaults standardUserDefaults] integerForKey:@"loginstate"];

}

- (void)dataSave{
#define dataSaveProperty(key)\
if (self.key) {\
[[NSUserDefaults standardUserDefaults] setObject:self.key.archiveToData2 forKey:NSStringFromSelector(@selector(key))];\
}else{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:NSStringFromSelector(@selector(key))];\
}
//    dataSaveProperty(sessionInfo);
    if (self.sessionInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:self.sessionInfo.archiveToData2 forKey:NSStringFromSelector(@selector(sessionInfo))];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSStringFromSelector(@selector(sessionInfo))];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:self.loginstate forKey:NSStringFromSelector(@selector(loginstate))];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

- (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd Result:(loginStae)result{
    if (self.loginstate == wyLogInStateSuccess && self.sessionInfo.token.length > 0) {
        result(YES);
    }else if(self.loginstate == wyLogInStateNotLogin){
        
    }
}

- (void)signUpAccount:(NSString *)account code:(NSString *)code pwd:(NSString *)pwd Result:(loginStae)result{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/account", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:account forKey:@"account"];
    [paramsDict setObject:code forKey:@"code"];
    [paramsDict setObject:pwd forKey:@"password"];
    NSString *registerStr = [Utils getRegisterID];
    if (![registerStr isEqualToString:@""]) {
        [paramsDict setObject:registerStr forKey:@"registerid"];
    }
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSLog(@"fsadfa");
            self.sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
            result(YES);
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

- (void)editPwdWithOld:(NSString *)oldPwd New:(NSString *)newPwd isSuccess:(isSuccessBLock)complete{
    
//    token	是	string	用户名
//    password	是	string	密码
//    new_password	否	string	新密码
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/revisepassword", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:self.sessionInfo.token forKey:@"token"];
    [paramsDict setObject:oldPwd forKey:@"password"];
    [paramsDict setObject:newPwd forKey:@"new_password"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.sessionInfo.pwd = newPwd;
            complete(YES,@"");
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
             complete(NO,paramsDict[@"message"]);
        }
        
    } failuer:^(NSError *error) {

        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
    }];

}

- (void)singOut{
    self.sessionInfo = nil;
    self.loginstate = wyLogInStateNotLogin;
}


/**
 设置新密码

 @param phone      <#phone description#>
 @param pwd        <#pwd description#>
 @param code       <#code description#>
 @param registerID <#registerID description#>
 */


- (void)findPwdWithPhone:(NSString *)phone password:(NSString *)pwd code:(NSString *)code registerID:(NSString *)registerID isSuccess:(isSuccessBLock)response{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/forgetpassword", KSERVERADDRESS];
//    account	是	string	手机号
//    password	是	string	密码
//    code	否	string	验证码
//    registerid
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:phone forKey:@"account"];
    [paramsDict setObject:code forKey:@"code"];
    [paramsDict setObject:pwd forKey:@"password"];
    NSString *registerStr = [Utils getRegisterID];
    if (![registerStr isEqualToString:@""]) {
        [paramsDict setObject:registerStr forKey:@"registerid"];
    }
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSLog(@"fsadfa");
            response(YES,@"");
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            response(NO,paramsDict[@"message"]);
        }
        
    } failuer:^(NSError *error) {
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
    }];

}

- (void)editUserInfoWithUserLogo:(NSString *)logo NickName:(NSString *)nickName sex:(NSString *)sex recommend_code:(NSString *)code phone:(NSString *)phone pinPai:(NSString *)pinPai ChePai:(NSString *)chePai isSuccess:(isSuccessBLock)response{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/modifyinformation", KSERVERADDRESS];
//    token	是	string	用户名凭证
//    username	是	string	用户名
//    sex	是	string	性别
//    logo	是	string	图片
//    recommend_code	否	string	推荐码
//    account	是	string	手机号
//    brand_id	是	string	汽车品牌
//    plate_nu	是	string	车牌号
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:self.sessionInfo.token forKey:@"token"];
    [paramsDict setObject:nickName forKey:@"username"];
    if ([sex isEqualToString:@"男"]) {
        [paramsDict setObject:@"1" forKey:@"sex"];
    }else{
        [paramsDict setObject:@"2" forKey:@"sex"];
    }
    
    [paramsDict setObject:logo forKey:@"logo"];
   
    [paramsDict setObject:phone forKey:@"account"];
    [paramsDict setObject:pinPai forKey:@"brand_id"];
    [paramsDict setObject:chePai forKey:@"plate_nu"];
   
    if (!([code isEqualToString:@""]||code == nil)) {
        [paramsDict setObject:code forKey:@"recommend_code"];
    }
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            [[wyLogInCenter shareInstance] upDateUserInfo];
            response(YES,@"");
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            response(NO,paramsDict[@"message"]);
        }
        
    } failuer:^(NSError *error) {
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
    }];

}



@end
