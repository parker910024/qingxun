//
//  TTMineInfoView.h
//  TuTu
//
//  Created by lee on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMineInfoEnumConst.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TTBubbleViewType) {
    TTBubbleViewTypeFollow = 0,
    TTBubbleViewTypeFans = 1,
    TTBubbleViewTypeFindTA = 2,
    TTBubbleViewTypeRoom = 3
};

typedef void(^TTBubbleViewClickHandler)(TTBubbleViewType type);
typedef void(^TTHeaderAvatarClickHandler)(void);

@class UserInfo;
@interface TTMineInfoView : UIView

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, copy) TTBubbleViewClickHandler bubbleClickHandler;
/** 头像的点击事件 */
@property (nonatomic, strong) TTHeaderAvatarClickHandler headerAvatarClickHandler;
- (instancetype)initWithFrame:(CGRect)frame style:(TTMineInfoViewStyle)style;
@end

NS_ASSUME_NONNULL_END
