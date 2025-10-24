//
//  XCAnchorOrderTipsContentMessageView.h
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2020/5/11.
//  Copyright © 2020 WJHD. All rights reserved.
//  主播订单消息提示

#import "NIMSessionMessageContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCAnchorOrderTipsContentMessageView : NIMSessionMessageContentView
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *bgView;
@end

NS_ASSUME_NONNULL_END
