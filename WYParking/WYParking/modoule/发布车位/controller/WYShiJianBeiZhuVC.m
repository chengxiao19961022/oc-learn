//
//  WYShiJianBeiZhuVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/24.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYShiJianBeiZhuVC.h"
#import "WYJiaGeVC.h"

@interface WYShiJianBeiZhuVC ()
@property (weak, nonatomic) IBOutlet UITextField *TFTime_note;

@end

@implementation WYShiJianBeiZhuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    __weak typeof(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"设置时间数量";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnNextClick:(id)sender {
    if (self.TFTime_note.text.length != 0) {
        self.saletimes.note = self.TFTime_note.text;
    }else {
        self.saletimes.note = @"";
    }
    
    WYJiaGeVC *vc = WYJiaGeVC.new;
    vc.saletimes = self.saletimes;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
