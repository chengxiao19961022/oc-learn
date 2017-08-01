//
//  CancelPolicyViewController.m
//  WYParking
//
//  Created by glavesoft on 17/4/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "CancelPolicyViewController.h"

@interface CancelPolicyViewController (){
    __weak IBOutlet UIWebView *mWebView;
    
}

@end

@implementation CancelPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initialization];
    [self SetNaviBar];

}

-(void)initialization{
    mWebView.backgroundColor = [UIColor whiteColor];
    NSString *webViewStr = [NSString stringWithFormat:@"%@parking/home/web/index.php/about/tuiding",apiHosr];
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
    
    
    self.title = @"退订政策";
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
