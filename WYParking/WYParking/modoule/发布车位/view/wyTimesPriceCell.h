//
//  wyTimesPriceCell.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/6.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , timeCellClickType) {
    timeCellClickTypeFix = 0,//修改
    timeCellClickTypeDlete//删除
};

typedef void(^timeCellClickBlock)(timeCellClickType clickType,NSIndexPath *indexPath , id model);


@interface wyTimesPriceCell : UITableViewCell

@property (copy , nonatomic) timeCellClickBlock clickBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)model;



@end
