//
//  TTRoomSettingsTagPickerView.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  房间标签设置

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeTag;

typedef void(^PickerViewSelectCompletion)(HomeTag *tag);
typedef void(^PickerViewCancelDismiss)(void);

@interface TTRoomSettingsTagPickerView : UIView

/**
 选中的标签
 */
@property (nonatomic, strong) HomeTag *selectedTag;

/**
 标签列表
 */
@property (nonatomic, strong) NSArray *tagList;

/**
 显示标签选择视图
 
 @param completion 输入完成回调
 @param dismiss 消失回调（点击取消按钮）
 */
- (void)showAlertWithCompletion:(PickerViewSelectCompletion)completion dismiss:(PickerViewCancelDismiss)dismiss;

@end

NS_ASSUME_NONNULL_END
