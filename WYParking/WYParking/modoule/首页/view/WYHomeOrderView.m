//
//  WYHomeOrderView.m
//  WYParking
//
//  Created by glavesoft on 17/2/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYHomeOrderView.h"
#import "WYCollectionViewCell.h"
#import "WYModelMYOrder.h"


@interface WYHomeOrderView ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (strong , nonatomic) NSMutableArray *dataSource;

@property (weak , nonatomic) UICollectionView *collectionView;

@property (assign , nonatomic) CGFloat itemW;

@end

@implementation WYHomeOrderView

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
    return self ;
}

- (void)configStyle{
    self.itemW = [UIScreen mainScreen].bounds.size.width - 2*20 - 8;
    UIImageView *bImageView = [[UIImageView alloc] init];
    [self addSubview:bImageView];
    [bImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(54 / 320.0 * [UIScreen mainScreen].bounds.size.width);
    }];
    bImageView.image = [UIImage imageNamed:@"sy_bg"];
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    imageView.image = [UIImage imageNamed:@"sy_bgk"];
    
    UIButton *leftBtn  = UIButton.new;
    leftBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(20);
    }];
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"sy_xzjt"] forState:UIControlStateNormal];
    [leftBtn bk_addEventHandler:^(id sender) {
        WYLog(@"左");
        NSIndexPath *currentIndexPath = [self.collectionView indexPathsForVisibleItems].firstObject;
        if (currentIndexPath.row > 0) {
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row - 1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow makeToast:@"亲，已经是第一页了"];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn  = UIButton.new;
    rightBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(20);
    }];
     [rightBtn setImage:[UIImage imageNamed:@"sy_xyjt"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"" forState:UIControlStateNormal];
    [rightBtn bk_addEventHandler:^(id sender) {
         WYLog(@"右");
        NSIndexPath *currentIndexPath = [self.collectionView indexPathsForVisibleItems].lastObject;
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 1 inSection:0];
        if (self.dataSource.count > nextIndexPath.row) {
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow makeToast:@"亲，已经是最后一页了"];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.collectionViewLayout = flowLayout;
    collectionView.pagingEnabled = YES;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right);
        make.top.bottom.mas_equalTo(0);
        make.right.equalTo(rightBtn.mas_left);
    }];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor clearColor];
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WYCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WYCollectionViewCell class])];
    
    //为了让itemSize更加准确
    [self layoutIfNeeded];
    self.itemW = self.collectionView.width;
    [self.collectionView reloadData];
    
    
}

- (void)fetchData{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@order/ordershows", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.dataSource = [WYModelMYOrder mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            [self.collectionView reloadData];
            [self.dataSource enumerateObjectsUsingBlock:^(WYModelMYOrder *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.is_me = @"1";
            }];
            if (self.dataSource.count == 0) {
                self.hidden = YES;
            }else{
                self.hidden = NO;
            }
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
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
       
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYCollectionViewCell *cell = [WYCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*20 - 8, 200);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark - 点击某一个item
    if (self.block != nil) {
        self.block([self.dataSource objectAtIndex:indexPath.row]);
    }
}

@end
