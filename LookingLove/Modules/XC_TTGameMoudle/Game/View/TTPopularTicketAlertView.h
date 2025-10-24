//
//  TTPopularTicketAlertView.h
//  LookingLove
//
//  Created by lvjunhang on 2020/12/3.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  人气票

#import <UIKit/UIKit.h>
#import "PopularTicket.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPopularTicketAlertView : UIView
@property (nonatomic, strong) PopularTicket *model;

@property (nonatomic, copy) void(^doneHandler)(void);
@property (nonatomic, copy) void(^closeHandler)(void);

@end

NS_ASSUME_NONNULL_END
