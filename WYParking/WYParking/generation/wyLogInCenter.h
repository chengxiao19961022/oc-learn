//
//  wyLogInCenter.h
//  WYParking
//
//  Created by Leon on 17/2/6.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wyModelLogin.h"

typedef NS_ENUM(NSInteger , wyLogInState) {
    wyLogInStateNotLogin = 0,
    wyLogInStateLoging,
    wyLogInStateSuccess
};

typedef void  (^isSuccessBLock)(BOOL isSuccess,NSString *errorMes);

typedef void(^loginStae)(BOOL isSuccess);

@interface wyLogInCenter : NSObject

@property (assign , nonatomic , readwrite) wyLogInState loginstate;// 用户的登录状态

@property (strong , nonatomic , readwrite) wyModelLogin *sessionInfo;// 用户的信息


+ (instancetype)shareInstance;

- (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd Result:(loginStae)result;

//注册
- (void)signUpAccount:(NSString *)account code:(NSString *)code pwd:(NSString *)pwd Result:(loginStae)result;

//修改密码
- (void)editPwdWithOld:(NSString *)oldPwd New:(NSString *)newPwd isSuccess:(isSuccessBLock)complete;
//退出登录
- (void)singOut;

//忘记密码
- (void)findPwdWithPhone:(NSString *)phone password:(NSString *)pwd code:(NSString *)code registerID:(NSString *)registerID isSuccess:(isSuccessBLock)response;

//修改资料
- (void)editUserInfoWithUserLogo:(NSString *)logo NickName:(NSString *)nickName sex:(NSString *)sex recommend_code:(NSString *)code phone:(NSString *)phone pinPai:(NSString *)pinPai ChePai:(NSString *)chePai isSuccess:(isSuccessBLock)response;

- (void)dataSave;//保存数据

- (void)upDateUserInfo;//更新用户信息

@end
