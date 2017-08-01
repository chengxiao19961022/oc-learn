//
//  WYHomeTypeView.m
//  WYParking
//
//  Created by glavesoft on 17/2/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYHomeTypeView.h"
#import "WYCollectionViewCell.h"
#import "WYHomeActivityCell.h"
#import "WYNearSpotCell.h"
#import "WYNearFriendCell.h"
#import "wyModelActivity.h"
#import "XZMRefresh.h"
#import "UIScrollView+PSRefresh.h"

@interface WYHomeTypeView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong , nonatomic) NSMutableArray *dataSource;

@property (weak , nonatomic) UILabel *titleLab;

@property (copy , nonatomic) NSString *cellClass;

@property (assign , nonatomic) homeViewType type;
//@property (weak , nonatomic) UICollectionView * collectionView;

@end



@implementation WYHomeTypeView


- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
    }
    return self;
}

- (void)setUPStyle{
    
    UILabel *labTypeTitle = UILabel.new;
    labTypeTitle.text = @"热门专题";
    [self addSubview:labTypeTitle];
    [labTypeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(6);
    }];
    self.titleLab = labTypeTitle;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"sy_xyjt"];//图标“>“
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.height.mas_equalTo(15);
    }];
    self.imageView = imageView;
    
    UIButton *btn = UIButton.new;
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2.5);
        make.right.equalTo(imageView.mas_left).with.offset(-2);
    }];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.rightBtn = btn;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"查看全部" forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        WYLog(@"点击查看更多");
    } forControlEvents:UIControlEventTouchUpInside];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn.mas_centerY);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];

    
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(btn.mas_bottom).with.offset(10);
        
    }];
    
    //////     颜色       /////
    //collectionView.backgroundColor = [UIColor blueColor];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.collectionViewLayout = flowLayout;
    collectionView.showsHorizontalScrollIndicator = NO;
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:self.cellClass bundle:nil] forCellWithReuseIdentifier:self.cellClass];
    self.collectionView = collectionView;
    
//    [self.collectionView addRefreshHeaderWithClosure:^{
//        
//        // 模拟延迟加载数据，因此2秒后才调用）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.collectionView reloadData];
//            // 结束刷新
//            [self.collectionView endRefreshing];
//        });
//        
//    }];
    
//    //左边刷新更新
//    __weak typeof(self) weakself = self;
//    [self.collectionView xzm_addNormalHeaderWithCallback:^{
//        
//        
//        // 模拟延迟加载数据，因此2秒后才调用）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakself.collectionView reloadData];
//            // 结束刷新
//            [weakself.collectionView.xzm_header endRefreshing];
//        });
//        
//    }];
//    [weakself.collectionView.xzm_header beginRefreshing];

    
}

- (void)renderViewWithleftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle type:(homeViewType)type{
    self.type = type;
    if (type == homeViewTypeAction) {
        self.cellClass =  NSStringFromClass( [WYHomeActivityCell class]) ;
    }else if(type == homeViewTypeFriend){
        self.cellClass = NSStringFromClass( [WYNearFriendCell class]);
    }else{
        self.cellClass = NSStringFromClass( [WYNearSpotCell class]);
    }
    [self setUPStyle];
    
    if (!([leftTitle isEqualToString:@""] || leftTitle == nil)) {
        self.titleLab.text = leftTitle;
    }
    if (!([rightTitle isEqualToString:@""] || rightTitle == nil)) {
        [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    }
    
}

//re men zhuan ti
- (void)fetchActivityData{
    [self.dataSource removeAllObjects];
    if ([self.cellClass isEqualToString:@"WYHomeActivityCell"]) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        NSString * urlString = [[NSString alloc] initWithFormat:@"%@index/topics", KSERVERADDRESS];
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        //    [paramsDict setObject:@"10"  forKey:@"limit"];
        //    [paramsDict setObject:[NSString stringWithFormat:@"%ld",_RemenIndex]  forKey:@"page"];
        if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
            [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
        }
        
        [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
            if(self.collectionView){
                [self.collectionView endRefreshing];
            }
            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
            
            if ([paramsDict[@"status"] isEqualToString:@"200"]) {
                NSArray *sourceArr  = [wyModelActivity mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
                if (sourceArr.count > 0) {
                    
                    if (_RemenIndex == 1) {
                        //下拉刷新
                        self.dataSource = sourceArr.mutableCopy;
                        
                    }else{
                        //上拉加载
                        [self.dataSource addObjectsFromArray: sourceArr.mutableCopy];
                        
                    }
                    [self.collectionView reloadData];
                }else{
                    //                    [self.view makeToast:@"没有了,亲"];
                }
                
                //                NSMutableArray *datasourcetmp = [wyModelActivity
                //                                                 mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
                //                //wyModelActivity *remencelltmp = [datasourcetmp objectAtIndex:0];
                ////                for (NSInteger i = 0; i < [datasourcetmp count]; i++){
                ////                        [[[datasourcetmp objectAtIndex:i] pic] setString: [[datasourcetmp objectAtIndex:i] pic_new]];
                ////                }
                //                self.dataSource = datasourcetmp;
                
            }
            else if([paramsDict[@"status"] isEqualToString:@"104"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
            }
            else
            {
                [keyWindow makeToast:paramsDict[@"message"]];
            }
            
        } failuer:^(NSError *error) {
            if(self.collectionView){
                [self.collectionView endRefreshing];
            }
            [keyWindow makeToast:@"请检查网络"];
        }];
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([self.cellClass isEqualToString:@"WYHomeActivityCell"]) {
        return self.dataSource.count;
    }else if ([self.cellClass isEqualToString:@"WYNearSpotCell"]){
        if (self.dataSource.count > 5) {
            return 5;
        }else{
            return self.dataSource.count;
        }
    }else{
        if (self.dataSource.count > 10) {
            return 10;
        }else{
            return self.dataSource.count;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellClass forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        if ([self.cellClass isEqualToString:@"WYHomeActivityCell"]) {
            WYHomeActivityCell *cellT = (WYHomeActivityCell *)cell;
            [cellT renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
        }else if ([self.cellClass isEqualToString:@"WYNearSpotCell"]){
            WYNearSpotCell *cellT = (WYNearSpotCell *)cell;
            [cellT renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
        }else if ([self.cellClass isEqualToString:@"WYNearFriendCell"]){
            WYNearFriendCell *cellT = (WYNearFriendCell *)cell;
            [cellT renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
    if ([self.cellClass isEqualToString:NSStringFromClass([WYHomeActivityCell class])]) {
        //size = CGSizeMake(161, 280);
        int rm_width = [UIScreen mainScreen].bounds.size.width/2 - 25;        
        //NSLog(@"!!!!%f!!!!%f!!!!!%d",self.width, self.height ,rm_width);
        size = CGSizeMake(rm_width, rm_width * 1.7);
    }else if ([self.cellClass isEqualToString:NSStringFromClass([WYNearSpotCell class])]) {
        size = CGSizeMake(222, 190);
    }else{
        size = CGSizeMake(104, 155);
    }
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block != nil) {
        self.block(_type , [self.dataSource objectAtIndex:indexPath.row] , indexPath);
    }
}

- (void)renderViewWithArr:(NSMutableArray *)dataSource{
    self.dataSource = [NSMutableArray arrayWithArray:dataSource.copy];
    [self.collectionView reloadData];
}

@end
