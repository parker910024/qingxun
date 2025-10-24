//
//  TTGameNavView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTGameNavView;

@protocol TTGameNavViewDelegate <NSObject>
/** 点击创建我的房间 */
- (void)navViewDidClickCreateRoom:(TTGameNavView *)view;

/** 点击搜索 */
- (void)navViewDidClickSearch:(TTGameNavView *)view;

/** 点击签到 */
- (void)navViewDidClickCheckin:(TTGameNavView *)view;

@end

@interface TTGameNavView : UIView

@property (nonatomic, weak) id<TTGameNavViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
