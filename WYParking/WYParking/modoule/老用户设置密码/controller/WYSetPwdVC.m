//
//  WYSetPwdVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/8.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYSetPwdVC.h"
#import "wyTabBarController.h"
#import "WYNavigationController.h"

@interface WYSetPwdVC ()
@property (weak, nonatomic) IBOutlet UIView *pwdErrorView;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation WYSetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnNext.layer.cornerRadius = 25.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}

#pragma mark - 下一步
- (IBAction)btnNextClick:(id)sender {
    AppDelegate *app = KappDelegate;
    [app setTabBarAsRootVC];
    
}



@end
