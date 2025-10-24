//
//  TTFunctionMenuView.h
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFunctionMenuButton.h"
#import "TTFunctionMenuItem.h"

@class TTFunctionMenuView;

typedef NS_ENUM(NSUInteger, TTFunctionMenuType) {
    TTFunctionMenuType_Normal = 0,//正常状态
    TTFunctionMenuType_More = 1,//更多
};

@protocol TTFunctionMenuViewDelegate

// 选择了functionMenuView主功能
- (void)functionMenuView:(TTFunctionMenuView *)menuView didSelectMenuButton:(TTFunctionMenuButton *)menuButton;

//选择了 更多中的二级功能
- (void)functionMenuView:(TTFunctionMenuView *)menuView didSelectMenuItem:(TTFunctionMenuItemTag)tag;

@end

@class UserInfo;
@interface TTFunctionMenuView : UIView

@property (nonatomic, strong) NSArray<TTFunctionMenuButton *> *items;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) NSInteger widthSpacing;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) TTFunctionMenuType functionMenuTypetype;//面板展开类型
@property (nonatomic, strong) TTFunctionMenuButton *moreFunBtn;//更多功能按钮
@property (nonatomic, strong) TTFunctionMenuButton *giftFunBtn;//礼物功能按钮

@property (nonatomic, strong) UserInfo  *roomOwnerUserInfo;

@property (nonatomic, weak) id<TTFunctionMenuViewDelegate> delegate;

//功能选项
@property (nonatomic, strong, readonly) NSMutableArray<TTFunctionMenuItem *> *funArray;

//当前用户在麦上的状态，调用 layoutTheViews 前判断
@property (nonatomic, assign) BOOL currentUserOnMicStatus;

@property (nonatomic, assign) BOOL delegateSuperAdmin;

- (void)layoutTheViews;

@end
