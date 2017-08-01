//
//  AboutUsViewController.m
//  WYParking
//
//  Created by glavesoft on 17/3/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
// 设置->关于我们

#import "AboutUsViewController.h"

@interface AboutUsViewController (){
    __weak IBOutlet UIWebView *mWebView;
    
}

@end

@implementation AboutUsViewController

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [UINavigationBar appearance].translucent = NO;
//    
//}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [UINavigationBar appearance].translucent = YES;
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initialization];
    [self SetNaviBar];
    [self getInfo];
}

-(void)initialization{
    mWebView.backgroundColor = [UIColor whiteColor];
    NSString *webViewStr = [NSString stringWithFormat:@"%@parking/home/web/index.php/about/about",apiHosr];
    NSURLRequest *urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:webViewStr]];
    [mWebView loadRequest:urlrequest];
    mWebView.opaque = NO;
}

- (void)SetNaviBar
{
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    
    self.title = @"关于我们";
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 27, 27)];
    [btn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getInfo{
//    
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //    manager.requestSerializer.timeoutInterval = 10.0f;
//    
//    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
//    
//    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/agreement", KSERVERADDRESS];
//    
//    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        //            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
//        NSString * result = [responseObject objectForKey:@"status"];
//        NSString * message = [responseObject objectForKey:@"message"];
//        NSLog(@"message = %@",message);
//        
//        if ([result isEqualToString:@"200"]){
//            
//            NSDictionary *dict = [responseObject objectForKey:@"data"];
//            NSString *agreementStr = dict[@"has"];
//            
//            [mWebView loadHTMLString:agreementStr baseURL:nil];
//            
//        } else if([result isEqualToString:@"104"]){
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
//        }else{
//            
//            
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //
//        
//    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
