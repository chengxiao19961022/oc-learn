//
//  WYWMVC.m
//  WYParking
//
//  Created by glavesoft on 17/3/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYWMVC.h"
#import "WMEditPopView.h"

@interface WYWMVC ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (copy , nonatomic) NSString *parkIdStr;
@property (copy , nonatomic) NSString *parkType;
@property (copy , nonatomic) NSString *saletimes_id;

@end

@implementation WYWMVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    WMEditPopView *v= [[WMEditPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) parkID:self.parkIdStr parkType:self.parkType saleTimesid:self.saletimes_id];
    @weakify(self);
    v.wmJumpBlock = ^(NSString *wmInfo,NSString *endDate){
        @strongify(self);
        if (self.wmBlock) {
            self.wmBlock(wmInfo,endDate);
            [self dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }
        
    };
    [self.containerView addSubview:v];
}

- (void)initWithparkID:(NSString *)parkIdStr parkType:(NSString *)parkType saleTimesid:(NSString *)saletimes_id{
    self.parkIdStr = parkIdStr;
    self.parkType = parkType;
    self.saletimes_id = saletimes_id;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCloseCLick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}


@end
