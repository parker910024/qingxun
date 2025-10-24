//
//  XCGmaeVoiceMessageView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/12.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2PInteractiveAttachment.h"
#import "XCGameVoiceBottleAttachment.h"
@class XCGmaeVoiceMessageView;
NS_ASSUME_NONNULL_BEGIN

@protocol XCGmaeVoiceMessageViewDelegate <NSObject>

/** 点击了*/
- (void)gameVoiceMessage:(XCGmaeVoiceMessageView *)messageView didClickButtonWith:(P2PInteractive_SkipType)skipType;

@end

@interface XCGmaeVoiceMessageView : UIView

/** 代理*/
@property (nonatomic,assign) id<XCGmaeVoiceMessageViewDelegate> delegate;

/**  赋值*/
@property (nonatomic,strong) XCGameVoiceBottleAttachment *attach;

@end

NS_ASSUME_NONNULL_END
