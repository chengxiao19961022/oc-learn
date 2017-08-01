//
//  WYNavigationController.m
//  WYParking
//
//  Created by glavesoft on 17/2/6.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYNavigationController.h"

@interface WYNavigationController ()

@end

@implementation WYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setShadowImage:UIImage.new];//去除导航栏下面的横线
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
