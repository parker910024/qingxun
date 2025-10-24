//
//  AnnualBroadcastNotifyInfo.h
//  LookingLove
//
//  Created by lvjunhang on 2020/12/2.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  年度全服通知

#import "LayoutParams.h"
#import "MessageLayout.h"
#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnnualBroadcastNotifyInfo : Attachment
@property (nonatomic, assign) P2PInteractive_SkipType routerType;
@property (nonatomic, strong) NSString *routerValue;
@property (nonatomic, strong) MessageLayout *layout;
@property (nonatomic, strong) NSString *svgaUrl;
@property (nonatomic, strong) NSString *backPic;

@end

NS_ASSUME_NONNULL_END
