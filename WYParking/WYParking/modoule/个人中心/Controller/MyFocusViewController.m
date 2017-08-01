//
//  MyFocusViewController.m
//  WYParking
//
//  Created by admin on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
//  关注

#import "MyFocusViewController.h"
#import "NaviView.h"
@interface MyFocusViewController ()
{
    NaviView* naviView;
}
@end

@implementation MyFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
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
    naviView.titleLab.text = @"我的关注";
    naviView.titleLab.textColor = [UIColor whiteColor];
    
    [naviView.leftBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
