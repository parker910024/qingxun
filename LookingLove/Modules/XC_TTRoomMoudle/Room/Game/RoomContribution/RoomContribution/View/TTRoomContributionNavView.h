//
//  TTRoomContributionNavView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  贡献榜顶部导航栏（半小时榜、房内榜)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTRoomContributionNavView;

@protocol TTRoomContributionNavViewDelegate <NSObject>
@optional
/** 点击半小时榜 */
- (void)didClickHalfhourRankInNavView:(TTRoomContributionNavView *)view;
/** 点击房间榜 */
- (void)didClickRoomRankInNavView:(TTRoomContributionNavView *)view;
@end

@interface TTRoomContributionNavView : UIView

@property (nonatomic, weak) id<TTRoomContributionNavViewDelegate> delegate;

@property (nonatomic, strong) NSArray<NSString *> *titleArray;

- (void)updateButtonWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
