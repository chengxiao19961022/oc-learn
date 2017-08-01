//
//  WYRiZuVC.m
//  WYParking
//
//  Created by glavesoft on 17/3/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYRiZuVC.h"
#import "EditPopView.h"

@interface WYRiZuVC ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

//@property (assign , nonatomic) CGRect f;

@property (copy , nonatomic) NSString *parkIdStr;
@property (copy , nonatomic) NSString *parkType;
@property (copy , nonatomic) NSString *saletimes_id;

@end

@implementation WYRiZuVC


- (void)initWithparkID:(NSString *)parkIdStr parkType:(NSString *)parkType saltimes_id:(NSString *)saletimes_id{
    self.parkIdStr = parkIdStr;
    self.parkType = parkType;
    self.saletimes_id = saletimes_id;
}

#pragma mark  日租
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    EditPopView *v = [[EditPopView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kScreenHeight - 64) parkID:self.parkIdStr parkType:self.parkType saltimes_id:self.saletimes_id];
    @weakify(self);
    v.block = ^(NSArray *arr){
        @strongify(self);
        if (self.RiZublock) {
            self.RiZublock(arr);
        }
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    };
    [self.containerView addSubview:v];
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
- (IBAction)btnDismissClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

@end
