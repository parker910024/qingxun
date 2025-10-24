//
//  TTVoiceTimeView.h
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTVoiceTimeView : UIView

/** 当前的时间*/
@property (nonatomic,assign) NSTimeInterval second;

/** 更新显示的内容
 
 @param content 内容
 @param isShort 是不是提示录音时间太短
 */
- (void)updateContentWith:(NSString *)content isRecordShort:(BOOL)isShort;

/**
 
 更新时间
 @param second 当前的时间
 @param totalSecond 总的时间
 */
- (void)setSecond:(NSTimeInterval)second totalSecond:(NSTimeInterval)totalSecond;

@end

NS_ASSUME_NONNULL_END
