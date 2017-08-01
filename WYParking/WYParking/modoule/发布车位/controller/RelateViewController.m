//
//  RelateViewController.m
//  TheGenericVersion
//
//  Created by liuqiang on 16/4/23.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "RelateViewController.h"
#import "wyParkInfoSettingVC.h"

@interface RelateViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RelateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self showLeftMenu];
    }];
    self.title = @"关联停车场";
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:RELATEADDRESS]];
    [self.webView loadRequest:request];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showLeftMenu
{
   [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if ([obj isKindOfClass:[wyParkInfoSettingVC class]]) {
           wyParkInfoSettingVC *vc = (wyParkInfoSettingVC *)obj;
           [Utils setNavigationControllerPopWithAnimation:self timingFunction:KYNaviAnimationTimingFunctionEaseInEaseOut type:KYNaviAnimationTypePageCurl subType:KYNaviAnimationDirectionDefault duration:0.38 target:vc];
       }
   }];
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
