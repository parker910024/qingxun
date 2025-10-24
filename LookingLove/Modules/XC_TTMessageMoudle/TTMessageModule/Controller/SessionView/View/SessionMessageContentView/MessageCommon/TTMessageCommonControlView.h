//
//  MessageCommonControlView.h
//  XChat
//
//  Created by 卫明何 on 2018/5/28.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBussiness.h"

@interface TTMessageCommonControlView : UIView
@property (strong, nonatomic) MessageBussiness *bussiness;
@property (strong, nonatomic) NIMMessage *message;
@end
