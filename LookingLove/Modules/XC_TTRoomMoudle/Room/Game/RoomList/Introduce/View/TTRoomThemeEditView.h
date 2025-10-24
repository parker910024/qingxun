//
//  TTRoomThemeEditView.h
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTRoomThemeEditView : UIView
/** textField */
@property (nonatomic, strong, readonly) UITextField *textField;

/**
 更新 文字长度限制字数的已输入字数, (外界设置textField.text后, 调用)
 */
- (void)textFieldTextDidChange;
@end

NS_ASSUME_NONNULL_END
