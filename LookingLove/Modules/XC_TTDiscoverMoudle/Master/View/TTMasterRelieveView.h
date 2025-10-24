//
//  TTMasterRelieveView.h
//  TTPlay
//
//  Created by Macx on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTMasterRelieveView;

@protocol TTMasterRelieveViewDelegate <NSObject>
@optional;
/** 点击了关闭按钮 */
- (void)masterRelieveView:(TTMasterRelieveView *)view didClickCloseButton:(UIButton *)closeButton;
@end

@interface TTMasterRelieveView : UIView
/** 代理 */
@property (nonatomic, weak) id<TTMasterRelieveViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
