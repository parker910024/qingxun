//
//  LLProfileView.h
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/7.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLDynamicLayoutModel;

typedef NS_ENUM(NSUInteger, ProfileViewActionType) {
    ProfileViewActionTypeProfile = 0, // 个人资料
    ProfileViewActionTypeAnchorChat = 1,//主播订单聊天
    ProfileViewActionTypeAnchorMark = 2,//主播订单问号
    ProfileViewActionTypeAlbumEmpty = 3,//相册空白处
};

typedef void(^ProfileClickHandler)(ProfileViewActionType type);

NS_ASSUME_NONNULL_BEGIN

@interface LLProfileView : UIView
@property (nonatomic, strong) LLDynamicLayoutModel *layout;

@property (nonatomic, copy) ProfileClickHandler clickHandler;

@end

NS_ASSUME_NONNULL_END
