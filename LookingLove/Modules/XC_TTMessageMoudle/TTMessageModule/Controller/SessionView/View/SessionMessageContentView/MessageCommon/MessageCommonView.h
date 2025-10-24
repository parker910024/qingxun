//
//  MessageCommonView.h
//  XChat
//
//  Created by 卫明何 on 2018/5/28.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMKit.h"
#import "MessageBussiness.h"
#import "TTMessageCommonControlView.h"

@interface MessageCommonView : NIMSessionMessageContentView

@property (strong, nonatomic) MessageBussiness *bussiness;

@end
