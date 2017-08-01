//
//  WYFuJinBottomView.m
//  WYParking
//
//  Created by glavesoft on 17/3/2.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYFuJinBottomView.h"


@interface WYFuJinBottomView ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (strong , nonatomic) NSMutableArray *dataSource;



@property (assign , nonatomic) CGFloat itemW;

@end

@implementation WYFuJinBottomView

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
    self.itemW = KscreenWidth;
    UIImageView *bImageView = [[UIImageView alloc] init];
    [self addSubview:bImageView];
    [bImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(54 / 320.0 * [UIScreen mainScreen].bounds.size.width);
    }];
    bImageView.image = [UIImage imageNamed:@""];
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    imageView.image = [UIImage imageNamed:@""];
    
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
            if (_blockIndex) {
                _blockIndex(@"上一页");
            }
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
            if (_blockIndex) {
                _blockIndex(@"下一页");
            }
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
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([wyFuJinBottomViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([wyFuJinBottomViewCell class])];
    
    //为了让itemSize更加准确
    [self layoutIfNeeded];
    self.itemW = self.collectionView.width;
    [self.collectionView reloadData];
    
}

-(void)renderViewWithArr:(NSMutableArray *)arr{
    self.dataSource = arr;
    [self.collectionView reloadData];
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    wyFuJinBottomViewCell *cell = [wyFuJinBottomViewCell cellWithCollectionView:collectionView indexPath:indexPath];

    @weakify(self);
    cell.blockcel = ^(clicktype type, id mode){
        @strongify(self);
        if (self.fujinBottomblock) {
            self.fujinBottomblock (type , mode);
        }
    };
    if (self.dataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*20, 150);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark - 点击某一个item
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


@end
