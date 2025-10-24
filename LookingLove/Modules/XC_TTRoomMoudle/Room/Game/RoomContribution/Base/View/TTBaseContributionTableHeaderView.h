//
//  XC_MSBaseContributionHeadView.h
//  AFNetworking
//
//  Created by zoey on 2019/2/12.
//

#import <UIKit/UIKit.h>
#import "RoomBounsListInfo.h"


/**
 房间榜单类型

 - TTRoomContributionTypeHalfhour: 半小时榜
 - TTRoomContributionTypeInRoom: 房内榜
 */
typedef NS_ENUM(NSUInteger, TTRoomContributionType) {
    TTRoomContributionTypeHalfhour,
    TTRoomContributionTypeInRoom
};


NS_ASSUME_NONNULL_BEGIN

@class RankData;
@interface TTBaseContributionTableHeaderView : UIView

// 图片
@property (strong , nonatomic) UIImageView *headView;
// 前三名
@property (strong , nonatomic) NSArray *dataArray;

@property (assign , nonatomic) TTRoomContributionType type;
@property (assign , nonatomic) RankType rankType;

@property (strong , nonatomic)  void(^selectedBlcok)(UserID uid);

@end

NS_ASSUME_NONNULL_END
