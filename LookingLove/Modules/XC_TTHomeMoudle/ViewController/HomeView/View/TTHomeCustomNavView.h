//
//  TTHomeCustomNavView.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//  首页自定义导航栏

#import <UIKit/UIKit.h>

@class TTHomeCustomNavView;
@class RoomCategory;
@class JXCategoryTitleVerticalZoomView;

@protocol TTHomeCustomNavViewDelegate <NSObject>
@optional
/** 点击了搜索按钮 */
- (void)homeCustomNavView:(TTHomeCustomNavView *)view didClickSearchButton:(UIButton *)btn;
/** 点击了我的房间按钮 */
- (void)homeCustomNavView:(TTHomeCustomNavView *)view didClickMyRoomButton:(UIButton *)btn;

@end

@interface TTHomeCustomNavView : UIView

@property (nonatomic, strong) JXCategoryTitleVerticalZoomView *categoryView;

@property (nonatomic, weak) id<TTHomeCustomNavViewDelegate> delegate;

@property (nonatomic, strong) NSArray<RoomCategory *> *roomCategory;

@end
