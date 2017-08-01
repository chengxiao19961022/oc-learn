//
//  CarTableViewCell.h
//  TheGenericVersion
//
//  Created by Glavesoft on 16/1/11.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carIcon;

@property (weak, nonatomic) IBOutlet UILabel *carName;
@end
