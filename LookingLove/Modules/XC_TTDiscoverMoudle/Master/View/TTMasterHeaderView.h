//
//  TTMasterHeaderView.h
//  TTPlay
//
//  Created by Macx on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMasterAdvertisementView.h"

NS_ASSUME_NONNULL_BEGIN
@class TTMasterHeaderView;
@class TTMasterHeaderModel;

@protocol TTMasterHeaderViewDelegate <NSObject>
@optional;
/** 点击了去收徒 */
- (void)masterHeaderView:(TTMasterHeaderView *)view didClickAcceptpPrenticeView:(UIView *)view;
/** 点击了名师排行榜 */
- (void)masterHeaderView:(TTMasterHeaderView *)view didClickRankingView:(UIView *)view;
@end

@interface TTMasterHeaderView : UIView
/** 代理 */
@property (nonatomic, weak) id<TTMasterHeaderViewDelegate> delegate;

/** advModels */
@property (nonatomic, strong) NSArray *advModels;
/** rankingList */
@property (nonatomic, strong) NSArray *rankingList;
/** headerModel */
@property (nonatomic, strong) TTMasterHeaderModel *headerModel;
/** TTMasterAdvertisementView */
@property (nonatomic, strong, readonly) TTMasterAdvertisementView *advView;
@end

NS_ASSUME_NONNULL_END
