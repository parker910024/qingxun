//
//  MSAlertView.h
//  XCChatViewKit
//
//  Created by KevinWang on 2019/1/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MSAlertView;

@protocol MSAlertViewDelegate <NSObject>

@optional
- (void)alertViewDidClickSureButton:(MSAlertView *)alertView;
- (void)alertViewDidClickCancleButton:(MSAlertView *)alertView;

@end

@interface MSAlertView : UIView

@property (nonatomic, weak) id<MSAlertViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                 alertMessage:(NSMutableAttributedString *)message
                  cancleTitle:(NSString *)cancleTitle
                    sureTitle:(NSString *)sureTitle;

@end

NS_ASSUME_NONNULL_END
