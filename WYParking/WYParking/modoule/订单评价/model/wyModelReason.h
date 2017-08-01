//
//  wyModelReason.h
//  TheGenericVersion
//
//  Created by glavesoft on 16/9/6.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelReason : NSObject

//id": "25",
@property (copy , nonatomic) NSString *id;
//"type": "1",
@property (copy , nonatomic) NSString *type;
//"content": "暂时不外租了",
@property (copy , nonatomic) NSString *content;
//"orderby": "100"
@property (copy , nonatomic) NSString *orderby;

@property (assign , nonatomic) BOOL isSelected;


@end
