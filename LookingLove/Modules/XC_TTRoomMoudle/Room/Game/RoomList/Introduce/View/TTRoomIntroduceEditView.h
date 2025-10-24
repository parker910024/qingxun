//
//  TTRoomIntroduceEditView.h
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTRoomIntroduceEditView : UIView
/** textView */
@property (nonatomic, strong, readonly) UITextView *textView;

/**
 更新 文字长度限制字数的已输入字数, (外界设置textView.text后, 调用)
 */
- (void)textViewTextDidChange;
@end

NS_ASSUME_NONNULL_END
