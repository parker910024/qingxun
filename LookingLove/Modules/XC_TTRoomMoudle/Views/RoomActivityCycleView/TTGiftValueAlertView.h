//
//  TTGiftValueAlertView.h
//  XC_TTRoomMoudle
//
//  Created by lee on 2019/4/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 选择确认按钮回调

 @param notShowNextTime 下次是否显示 默认为NO
 */
typedef void(^TTGiftValueEnterHandler)(BOOL notShowNextTime);
// 取消回调
typedef void(^TTGiftValueCancelHandler)(void);

@interface TTGiftValueAlertView : UIView

/** 仅仅是读的权限，用于读取选中状态来处理是否要再次显示 */
@property (nonatomic, strong, readonly) UIButton *notShowNextTimeBtn;
@property (nonatomic, copy) TTGiftValueEnterHandler enterHandler;
@property (nonatomic, copy) TTGiftValueCancelHandler cancelHandler;
/**
 推荐使用的初始化方法

 @param frame 控件的大小
 @param text 提示内容
 */
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
