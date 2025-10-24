//
//  XC_MSContributionChampiomView.h
//  AFNetworking
//
//  Created by zoey on 2019/2/12.
//  房间榜中的单个皇冠视图

#import <UIKit/UIKit.h>

#import "TTBaseContributionTableHeaderView.h"
#import "UserID.h"

NS_ASSUME_NONNULL_BEGIN

/**
 皇冠类型

 - TTRoomContributionCrownTypeFirst: 第一名
 - TTRoomContributionCrownTypeSecond: 第二名
 - TTRoomContributionCrownTypeThird: 第三名
 */
typedef NS_ENUM(NSUInteger, TTRoomContributionCrownType) {
    TTRoomContributionCrownTypeFirst,
    TTRoomContributionCrownTypeSecond,
    TTRoomContributionCrownTypeThird
};

@interface TTRoomContributionCrownView : UIView
@property (nonatomic, strong) UIImageView *avatarImageView;//头像
@property (nonatomic, assign) UserID uid;
@property (nonatomic, strong) void(^selectedBlock)(UserID uid);

/**
 是否显示头像背景占位(虚位以待)，默认:YES
 */
@property (nonatomic, assign) BOOL showAvatarPlaceholder;

- (instancetype)initWithChampiomPostion:(TTRoomContributionCrownType)champiomPostion contributionType:(TTRoomContributionType)contributionType;

@end

NS_ASSUME_NONNULL_END
