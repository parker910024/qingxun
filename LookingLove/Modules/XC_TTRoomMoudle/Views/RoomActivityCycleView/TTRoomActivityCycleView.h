//
//  TTRoomActivityCycleView.h
//  TTPlay
//
//  Created by lee on 2019/2/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ActivityPositionType) {
    // 在左上方
    ActivityPositionTypeTopLeft,
    // 在右下方
    ActivityPositionTypeBottomRight,
};

@class TTRoomActivityCycleView,ActivityInfo;
@protocol TTRoomActivityCycleViewDelegate <NSObject>
@optional
- (void)roomActivityListView:(TTRoomActivityCycleView *)activityView jumbByActivityInfo:(ActivityInfo *)activityInfo;

@end

@interface TTRoomActivityCycleView : UIView

@property (nonatomic, weak) id<TTRoomActivityCycleViewDelegate> delegate;
@property (nonatomic, assign) ActivityPositionType type;

- (instancetype)initWithType:(ActivityPositionType)type;
/// 请求接口
- (void)requestDataWithActivity;
/// 倒计时
- (void)countDownTimer:(NSInteger)seconds;
@end

NS_ASSUME_NONNULL_END
