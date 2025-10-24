//
//  TTVoiceMatchingNavView.h
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BackButtonDidClickAction)(void);
typedef void(^SelectSexButtonDidClickAction)(void);
@interface TTVoiceMatchingNavView : UIView
/** 返回按钮的点击 */
@property (nonatomic, strong) BackButtonDidClickAction backButtonDidClickAction;
/** 选择性别按钮的点击 */
@property (nonatomic, strong) SelectSexButtonDidClickAction selectSexButtonDidClickAction;
/** back 默认为白色 */
@property (nonatomic, strong, readonly) UIButton *backButton;
/** title 默认为白色 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/** 选择性别按钮, 默认隐藏 */
@property (nonatomic, strong, readonly) UIButton *selectSexButton;
@end

NS_ASSUME_NONNULL_END
