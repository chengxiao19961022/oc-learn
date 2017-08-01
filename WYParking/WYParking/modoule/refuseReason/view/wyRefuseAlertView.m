//
//  wyRefuseAlertView.m
//  TheGenericVersion
//
//  Created by glavesoft on 16/9/5.
//  Copyright © 2016年 李杰. All rights reserved.
//


#import "wyRefuseAlertView.h"
#import "wyReasonCell.h"
#import "wyModelReason.h"

@interface wyRefuseAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak , nonatomic) UITableView *tbView;
@property (weak , nonatomic) wyReasonCell *protocolCell;
@property (weak , nonatomic) UIButton *btnEnsure;//确定按钮
@property (weak , nonatomic) UIButton *btnCanCle;//取消按钮
@property (strong , nonatomic) NSMutableArray<wyModelReason *> *reasons;//数据源
@property (weak , nonatomic) UILabel *labType;
@property (copy , nonatomic) NSString *reason;

@end

@implementation wyRefuseAlertView

#pragma mark - lazy
- (NSMutableArray *)reasons{
    if (_reasons == nil) {
        _reasons = [NSMutableArray array];
    }
    return _reasons;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}


#pragma mark - 页面初始化
- (void)configUI{
    UITableView *tbView = [[UITableView alloc] init];
    [self addSubview:tbView];
    tbView.layer.cornerRadius = 12.0f;
    tbView.layer.masksToBounds = YES;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.scrollEnabled = NO;
    tbView.delegate = self;
    tbView.dataSource = self;
    [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tbView = tbView;
    //header
    {
        //label - 提示
        UIView *headerView = UIView.new;
        UILabel *labTitle = UILabel.new;
        labTitle.text = @"提示";
        labTitle.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:labTitle];
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(labTitle.superview.mas_centerX);
            make.top.mas_equalTo(4);
            make.height.mas_equalTo(37);
        }];
        
        //line
        UIView *line = UIView.new;
        line.backgroundColor = kNavigationBarBackGroundColor;
        [headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labTitle.mas_bottom).offset(4);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        //label - 请选择拒绝理由
        UILabel *labReject = UILabel.new;
        labReject.text = @"请选择拒绝理由";
        labReject.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:labReject];
        [labReject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.equalTo(line.mas_bottom).offset(10);
            make.height.mas_equalTo(25);
            make.bottom.equalTo(labTitle.superview.mas_bottom).offset(-10);
        }];
        CGFloat topHeight = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        headerView.height = topHeight;
        self.labType = labReject;
        self.tbView.tableHeaderView = headerView;
        
        
    }
    //footer
    {
        UIView *footer1 = UIView.new;
//        确定按钮
        UIButton *ensuerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ensuerBtn setTitle:@"确定" forState:UIControlStateNormal];
        [ensuerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ensuerBtn.layer.cornerRadius = 8.0f;
        ensuerBtn.layer.masksToBounds = YES;
        ensuerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [ensuerBtn setBackgroundColor:kNavigationBarBackGroundColor];
        [footer1 addSubview:ensuerBtn];
        [ensuerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(ensuerBtn.superview.mas_centerX).offset(60);
            make.top.equalTo(ensuerBtn.superview.mas_top).offset(8);
            make.bottom.equalTo(ensuerBtn.superview.mas_bottom).offset(-15);
            
        }];
        [ensuerBtn addTarget:self action:@selector(btnEnsureClick) forControlEvents:UIControlEventTouchUpInside];
        self.btnEnsure = ensuerBtn;
//       取消按钮
        UIButton *btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancle.layer.cornerRadius = 8.0f;
        btnCancle.layer.masksToBounds = YES;
        btnCancle.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnCancle setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnCancle setBackgroundColor:kNavigationBarBackGroundColor];
        [footer1 addSubview:btnCancle];
        [btnCancle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(ensuerBtn.superview.mas_centerX).offset(-60);
            make.top.equalTo(btnCancle.superview.mas_top).offset(8);
            make.bottom.equalTo(btnCancle.superview.mas_bottom).offset(-15);
        }];
        self.btnCanCle = btnCancle;
         [btnCancle addTarget:self action:@selector(btnCancleClick) forControlEvents:UIControlEventTouchUpInside];
        CGFloat footerHeight = [footer1 systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
       footer1.height = footerHeight;
        self.tbView.tableFooterView = footer1;
    }
}


#pragma mark - 获得数据
- (void)renderViewWithType:(contentsType)type{
    switch (type) {
        case contentsTypeRefuse:
            self.labType.text = @"请选择拒绝理由";
            break;
        case contentsTypeUnsubscribe:
            self.labType.text = @"请选择退订理由";
            break;
        default:
            break;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@content/getcontents", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"type"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self animated:YES];
       
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            
            
            [self.reasons removeAllObjects];
            NSArray *temptArr = paramsDict[@"data"];
            self.reasons = [wyModelReason mj_objectArrayWithKeyValuesArray:temptArr];
            CGRect frame1 = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 4/5.0, 146 + 40 * self.reasons.count + 10);
            self.frame = frame1;
            [self.reasons enumerateObjectsUsingBlock:^(wyModelReason * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    obj.isSelected = YES;
                    self.reason = obj.content;
                }else{
                    obj.isSelected = NO;
                }
            }];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            
            
        }else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
            
        }else
        {
            [self makeToast:paramsDict[@"message"]];
        }
    } failuer:^(NSError *error) {
        [self makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
  }


//点击确定按钮
- (void)btnEnsureClick{
    if (self.clickBlock) {
        self.clickBlock(YES,YES,self.reason);
    }
}

//点击取消按钮
- (void)btnCancleClick{
    if (self.clickBlock) {
        self.clickBlock(YES,NO,self.reason);
    }
}



#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reasons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    wyReasonCell *cell = [wyReasonCell cellWithTableView:tableView indexPath:indexPath];
    if (self.reasons.count > indexPath.row) {
        [cell renderViewWithModel:[self.reasons objectAtIndex:indexPath.row]];
    }
    self.protocolCell = cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.protocolCell == nil) {
        return 30;
    }else{
        return [self.protocolCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.reasons enumerateObjectsUsingBlock:^(wyModelReason * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row) {
            obj.isSelected = YES;
            self.reason = obj.content;
        }else{
            obj.isSelected = NO;
        }
    }];
    [self.tbView reloadData];
}

@end
