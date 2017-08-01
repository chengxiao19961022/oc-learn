//
//  WYLatestActionVC.m
//  WYParking
//
//  Created by glavesoft on 17/3/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYLatestActionVC.h"
#import "WYModelLatesActivity.h"

@interface WYLatestActionVC ()

@property (copy , nonatomic) NSString *urlStr;

@end

@implementation WYLatestActionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [webView loadRequest:request];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    

}

- (void)renderWithUrl:(NSString *)urlstring title:(NSString *)title{
    self.urlStr = urlstring;
    self.title = title;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
