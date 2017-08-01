//
//  TradeDetailsViewController.m
//  WYParking
//
//  Created by admin on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
// 资金明细

#import "TradeDetailsViewController.h"
#import "NaviView.h"
@interface TradeDetailsViewController ()
{
    NaviView* naviView;
}
@end

@implementation TradeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    
    [self SetNaviBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)SetNaviBar
{
    naviView = [[NaviView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.view addSubview:naviView];
    
    [naviView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    naviView.rightBtn.hidden = YES;
    naviView.titleLab.text = @"资金明细";
    naviView.titleLab.textColor = [UIColor whiteColor];
    
    [naviView.leftBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
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
