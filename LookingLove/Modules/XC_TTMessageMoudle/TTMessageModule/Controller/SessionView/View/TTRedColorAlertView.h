//
//  RedAlertView.h
//  XChat
//
//  Created by 卫明何 on 2018/5/30.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketDetailInfo.h"

@interface TTRedColorAlertView : UIView
@property (strong, nonatomic) RedPacketDetailInfo *info;
@property (nonatomic,weak) UINavigationController *navigationController;
@property (strong, nonatomic) NIMMessage *message;
@end
