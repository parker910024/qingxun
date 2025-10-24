//
//  TTMasterHintView.h
//  TTPlay
//
//  Created by Macx on 2019/4/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTMasterHintView;
@class UserInfo;

@protocol TTMasterHintViewDelegate <NSObject>
/** hint 的点击事件 */
- (void)masterHintView:(TTMasterHintView *)hintView didTapActionView:(UIView *)tapView;
@end

@interface TTMasterHintView : UIView
+ (instancetype)shareMasterHintView;
- (void)show;
- (void)dismiss;

/** 代理 */
@property (nonatomic, weak) id<TTMasterHintViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
