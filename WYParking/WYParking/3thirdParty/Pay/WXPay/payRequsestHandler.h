

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
/*
 // 签名实例
 // 更新时间：2015年3月3日
 // 负责人：李启波（marcyli）
 // 该Demo用于ios sdk 1.4
 
 //微信支付服务器签名支付请求请求类
 //============================================================================
 //api说明：
 //初始化商户参数，默认给一些参数赋值，如cmdno,date等。
 -(BOOL) init:(NSString *)app_id (NSString *)mch_id;
 
 //设置商户API密钥
 -(void) setKey:(NSString *)key;
 
 //生成签名
 -(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
 
 //获取XML格式的数据
 -(NSString *) genPackage:(NSMutableDictionary*)packageParams;
 
 //提交预支付交易，获取预支付交易会话标识
 -(NSString *) sendPrepay:(NSMutableDictionary *);
 
 //签名实例测试
 - ( NSMutableDictionary *)sendPay_demo;
 
 //获取debug信息日志
 -(NSString *) getDebugifo;
 
 //获取最后返回的错误代码
 -(long) getLasterrCode;
 //============================================================================
 */

//通知的名字及参数
#define WX_PAY_RESULT   @"weixin_pay_result_isSuccessed"
#define IS_SUCCESSED    @"wechat_pay_isSuccessed"
#define IS_FAILED       @"wechat_pay_isFailed"


//#define APP_ID          @"wxe1193b317d360c0e"               //微信APPID 1.54版本以前的
#define APP_ID          @"wx46be1d3a86a5937e"               //微信APPID  1.5.5 版本

//#define APP_SECRET      @"e4efef815ee415bb8754718a9ef95767" //微信  1.54版本以前的

#define APP_SECRET      @"bfa33fc8163e6e211f6efc88bd4653dc" //微信  1.5.5 版本appsecret

//商户号，填写商户对应参数（客户给）1.54版本以前的
//#define MCH_ID          @"1343421001"

//商户号，填写商户对应参数（客户给） 1.5.5 版本
#define MCH_ID          @"1433815002"

//商户API密钥，填写相应参数（客户给） 1.5.4
//#define PARTNER_ID      @"04b6b4fc4286c6009356b8ea0296dc2e"

//商户API密钥，填写相应参数（客户给） 1.5.5
#define PARTNER_ID        @"1d88c8d2d8be8b6b057fdfcfbd9ffaa3" //appkey

//支付结果回调页面（后台会给你）
//#define NOTIFY_URL      @"这里填写后台给你的微信支付的后台接口网址"



@interface payRequsestHandler : NSObject{
	//预支付网关url地址
    NSString *payUrl;

    //lash_errcode;
    long     last_errcode;
	//debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
}
//初始化函数
-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
-(NSString *) getDebugifo;
-(long) getLasterrCode;
//设置商户密钥
-(void) setKey:(NSString *)key;
//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams;
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams;
//签名实例测试
- ( NSMutableDictionary *)sendPay_demo;

@end
