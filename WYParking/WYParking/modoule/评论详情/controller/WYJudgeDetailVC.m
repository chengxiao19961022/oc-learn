//
//  WYJudgeDetailVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYJudgeDetailVC.h"
#import "WYJudgeCell.h"
#import "WYStarView.h"
#import "wyModel_Park_detail.h"

@interface WYJudgeDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *starViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (strong , nonatomic) NSMutableArray *dataSource;
@property (weak , nonatomic) WYJudgeCell *protocolCell;
@property (weak, nonatomic) IBOutlet UILabel *labCount;
@property (weak, nonatomic) IBOutlet UILabel *labAverage;
@property (strong , nonatomic) wyModel_Park_detail *model;

@end

@implementation WYJudgeDetailVC
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"评论详情";
    WYStarView *starView = WYStarView.new;
    [self.starViewContainer addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(starView.superview);
    }];
    [starView renderViewWithMark:self.model.average];
    
    self.labCount.text = [NSString stringWithFormat:@"共%lu条评论",(unsigned long)self.model.comment.count];
    self.labAverage.text = [NSString stringWithFormat:@"%@分",self.model.average];
    _dataSource = _model.comment;
    [self.tbView reloadData];
    // Do any additional setup after loading the view from its nib.
}



#pragma mark - UItableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYJudgeCell *cell = [WYJudgeCell cellWithTableView:tableView indexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    self.protocolCell = cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.protocolCell == nil) {
        return 150;
    }else{
        return [self.protocolCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
}

- (void)renderWithModel:(wyModel_Park_detail *)m{
    self.model = m;
}

@end
