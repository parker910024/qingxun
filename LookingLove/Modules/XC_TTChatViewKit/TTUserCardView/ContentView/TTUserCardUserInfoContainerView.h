//
//  TTUserCardUserInfoContainerView.h
//  TuTu
//
//  Created by 卫明 on 2018/11/15.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCore.h"
#import "TTUserCardContainerView.h"
NS_ASSUME_NONNULL_BEGIN


@class TTUserCardUserInfoContainerView;

@protocol TTUserCardUserInfoContainerViewDelegate <NSObject>

@optional

/**
 用户信息更新

 @param view self
 @param userInfo 用户信息实体
 */
- (void)onUserContentView:(TTUserCardUserInfoContainerView *)view updateWithUserInfo:(UserInfo *)userInfo;

@end

@interface TTUserCardUserInfoContainerView : UIView

/**
 delegate:TTUserCardUserInfoContainerViewDelegate
 */
@property (nonatomic,weak) id<TTUserCardUserInfoContainerViewDelegate> delegate;

@property (nonatomic, assign) ShowUserCardType type;

- (instancetype)initWithFrame:(CGRect)frame uid:(UserID)uid;
@end

NS_ASSUME_NONNULL_END
