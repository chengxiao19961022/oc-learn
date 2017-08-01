//
//  WYCarDetaiInfoFooter.m
//  WYParking
//
//  Created by glavesoft on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYCarDetaiInfoFooter.h"
#import "WYJudgeCell.h"

@interface WYCarDetaiInfoFooter ()<UITableViewDelegate,UITableViewDataSource>
@property (strong , nonatomic) NSMutableArray *dataSource;

@property (weak , nonatomic) WYJudgeCell *protocolCell;

@property (weak , nonatomic) UITableView *tbView;

@property (weak , nonatomic) UILabel *labCount;

@end

@implementation WYCarDetaiInfoFooter

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    UIView *topView = UIView.new;
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *labCount = UILabel.new;
    [topView addSubview:labCount];
    [labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labCount.superview);
        make.left.mas_equalTo(20);
    }];
    labCount.text = @"共多少条评论";
    self.labCount = labCount;
    
    UIView *line = UIView.new;
    line.backgroundColor = RGBACOLOR(234, 234, 234, 1);
    [topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labCount);
        make.top.equalTo(labCount.mas_bottom).mas_equalTo(4);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(1);
    }];
    
    
    
   
    
    UIImageView *iamgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zf_jt"]];
    [topView addSubview:iamgeView];
    [iamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(19);
        make.centerY.equalTo(iamgeView.superview);
        make.right.mas_equalTo(-20);
    }];
    
    UILabel *lab = UILabel.new;
    lab.text = @"查看更多";
    lab.font = [UIFont systemFontOfSize:14];
    [topView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(iamgeView.mas_left);
        make.centerY.equalTo(lab.superview);
    }];
    
    UIButton *btn = UIButton.new;
    [topView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_left);
        make.right.equalTo(iamgeView.mas_right);
        make.top.equalTo(iamgeView.mas_top);
        make.bottom.bottom.equalTo(iamgeView.mas_bottom);
    }];
    self.lookMoreJudge = btn;
    
    UITableView *tbView = [[UITableView alloc] init];
    [self addSubview:tbView];
    [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(240);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [[RACObserve(self.lookMoreJudge,hidden) distinctUntilChanged] subscribeNext:^(NSNumber * x) {
        BOOL flag = [x boolValue];
        if (flag) {
            lab.hidden = YES;
            iamgeView.hidden = YES;
        }else{
            lab.hidden = NO;
            iamgeView.hidden = NO;
        }
    }];
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.delegate = self;
    tbView.dataSource = self;
    
    for (int i = 0; i < 5; i++) {
        [self.dataSource addObject:@"fas"];
    }
    
  
    [tbView reloadData];
    
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

- (void)renderViewWithDataSource:(NSMutableArray *)arr{
    self.labCount.text = [NSString stringWithFormat:@"共%d条评论",arr.count];
    self.dataSource = arr.mutableCopy;
#pragma mark 本页只显示五条数据
    //如果数据大于5，则移除之后的数据
    if (self.dataSource.count > 5) {
        [self.dataSource removeObjectsInRange:NSMakeRange(5, self.dataSource.count - 5)];

    }
    
    
    [self.tbView reloadData];
}

@end
