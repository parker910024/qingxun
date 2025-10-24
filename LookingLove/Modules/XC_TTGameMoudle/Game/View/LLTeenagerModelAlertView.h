//
//  LLTeenagerModelAlertView.h
//  XC_TTGameMoudle
//
//  Created by lee on 2019/7/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LLTeenagerModelAlertView;

@protocol LLTeenagerModelAlertViewDelegate <NSObject>

- (void)hiddeView:(LLTeenagerModelAlertView *)view;

- (void)didClickTeenagerButtonAction:(UIButton *)button;

@end

@interface LLTeenagerModelAlertView : UIView
@property (nonatomic, weak) id<LLTeenagerModelAlertViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
