//
//  TTGuildAddMemberSecretCodeView.h
//  TTPlay
//
//  Created by lee on 2019/2/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
// 生成的暗号用来展示的 view

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TTGuildMemberCodeShareType) {
    TTGuildMemberCodeShareTypeUndefined = 0,
    TTGuildMemberCodeShareTypeWX = 1,
    TTGuildMemberCodeShareTypeQQ = 2,
};

@protocol TTGuildAddMemberSecretCodeViewDelegate <NSObject>

/**
 点击分享的的事件

 @param shareType 要分享平台类型
 */
- (void)onClickShareBtnWithType:(TTGuildMemberCodeShareType)shareType;

/** 取消事件 */
- (void)onClickCancelBtnAction;

@end


NS_ASSUME_NONNULL_BEGIN
@class GuildEmojiCode;
@interface TTGuildAddMemberSecretCodeView : UIView

@property (nonatomic, assign) TTGuildMemberCodeShareType shareType;
@property (nonatomic, weak) id<TTGuildAddMemberSecretCodeViewDelegate> delegate;
@property (nonatomic, strong) GuildEmojiCode *emojiCode;
@end

NS_ASSUME_NONNULL_END
