//
//  TTCheckinScrollNotifyView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  滚动通知

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CheckinDrawNotice;

@interface TTCheckinScrollNotifyView : UIView

@property (nonatomic, strong) NSArray<CheckinDrawNotice *> *models;

- (void)stopCountDown;

@end

NS_ASSUME_NONNULL_END
