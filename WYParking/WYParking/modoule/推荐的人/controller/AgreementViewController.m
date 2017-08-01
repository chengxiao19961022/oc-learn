//
//  AgreementViewController.m
//  TheGenericVersion
//
//  Created by liuqiang on 16/4/23.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];        

    [self SetNaviBar];

    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:AGREEMENTADDRESS]];

    [self.webView loadRequest:request];

}

- (void)SetNaviBar
{
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    
    self.title = @"分红股协议";
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 27, 27)];
    [btn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)Back{

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
