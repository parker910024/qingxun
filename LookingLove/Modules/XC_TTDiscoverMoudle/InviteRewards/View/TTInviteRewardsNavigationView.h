//
//  TTInviteRewardsNavigationView.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/21.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  自定义白色透明底导航栏，可复用，建议高度：status bar + 44

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTInviteRewardsNavigationViewDelegate<NSObject>
- (void)navigationViewClickLeftAction;
- (void)navigationViewClickRightAction;
@end

@interface TTInviteRewardsNavigationView : UIView
@property (nonatomic, assign) id<TTInviteRewardsNavigationViewDelegate> delegate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *rightTitle;
@end

NS_ASSUME_NONNULL_END
