//
//  TTAdjustMixView.h
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTAdjustMixView;

@protocol TTAdjustMixViewDelegate<NSObject>
@optional

/**
 调节音乐音量
 
 @param adjustMixView 混响调节view self
 @param vol 调节后的音量值
 */
- (void)adjustMixView:(TTAdjustMixView *)adjustMixView adjustSoundVolFromMixView:(NSInteger)vol;


/**
 调节人声音量
 
 @param adjustMixView 混响调节view self
 @param vol  调节后的音量值
 */
- (void)adjustMixView:(TTAdjustMixView *)adjustMixView adjustVoiceVolFromMixView:(NSInteger)vol;

@end

@interface TTAdjustMixView : UIView
/**
 delegate:TTAdjustMixViewDelegate
 */
@property (weak, nonatomic) id <TTAdjustMixViewDelegate> delegate;
@end
