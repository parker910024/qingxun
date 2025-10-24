//
//  TTVoiceSelectSexView.h
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** 偏好设置 存储上一次用户选中的性别的key "0":不限 "1":男 "2":女 */
static NSString *const kRequestVoiceBottleListTypeKey = @"kRequestVoiceBottleListType";
@class TTVoiceSelectSexView;

@protocol TTVoiceSelectSexViewDelegate<NSObject>
@optional
/** 点击了关闭 */
- (void)voiceSelectSexViewCloseAction:(TTVoiceSelectSexView *)selectSexView;
/** 点击了确定按钮 */
- (void)voiceSelectSexView:(TTVoiceSelectSexView *)selectSexView didClickSureButton:(UIButton *)button;
@end

@interface TTVoiceSelectSexView : UIView
@property (weak, nonatomic) id<TTVoiceSelectSexViewDelegate> delegate;
/** 选中的type 0:不限 1:男 2:女 */
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
