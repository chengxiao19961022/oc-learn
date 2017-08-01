//
//  RCDCustomerServiceViewController.h
//  RCloudMessage
//
//  Created by litao on 16/2/23.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface RCDCustomerServiceViewController :
                        RCConversationViewController
//RCChatSessionInputBarControl
//@property (copy, nonatomic) NSString *labAddress;
//@property (copy, nonatomic) NSString *labAddressRemark;
@property (copy, nonatomic) NSString *parktitle;
@property (nonatomic, retain) NSObject<RCChatSessionInputBarControlDelegate> *delegate;
@end
