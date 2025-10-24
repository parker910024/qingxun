//
//  TTSendGiftAvatarView.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSendGiftView.h"

NS_ASSUME_NONNULL_BEGIN
@class GiftSendAllMicroAvatarInfo, TTSendGiftAvatarView, UserInfo;

@protocol TTSendGiftAvatarViewDelegate<NSObject>
@optional

/**
 点击了资料按钮 (公聊)

 @param avatarView avatarView
 @param button 资料按钮
 */
- (void)sendGiftAvatarView:(TTSendGiftAvatarView *)avatarView didClickUserInfoButton:(UIButton *)button;

/**
 点击了举报按钮 (公聊)

 @param avatarView avatarView
 @param button 举报按钮
 */
- (void)sendGiftAvatarView:(TTSendGiftAvatarView *)avatarView didClickReportButton:(UIButton *)button;
@end

@interface TTSendGiftAvatarView : UIView
@property (nonatomic, weak) id<TTSendGiftAvatarViewDelegate> delegate;
@property (nonatomic, assign) XCSendGiftViewUsingPlace usingPlace;
@property (nonatomic, strong) UserInfo *targetInfo;//礼物接受方信息
/** 选中送礼物的人 */
@property (nonatomic, strong, readonly) NSMutableArray<NSString *> *selectedUids;
/** 是否是 全麦送 */
@property (nonatomic, assign, readonly) BOOL isAllMicroSend;
/** 麦上用户 */
@property (nonatomic, strong, readonly) NSMutableArray<GiftSendAllMicroAvatarInfo *> *microArray;

/**
 初始化UI完成之后，初始化数据(选中指定送礼物的人)
 */
//- (void)initDisplayModel;
@end

NS_ASSUME_NONNULL_END
