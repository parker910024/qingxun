//
//  TTUserCardInfoFunctionContentView.h
//  TuTu
//
//  Created by 卫明 on 2018/11/16.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUserCardFunctionItem.h"

NS_ASSUME_NONNULL_BEGIN

@class TTUserCardInfoFunctionContentView;

@protocol TTUserCardInfoFunctionContentViewDelegate <NSObject>

/**
 某个按钮被点击了

 @param card 用户信息卡片的功能版面
 @param indexPath 坐标
 @param function 功能体
 */
- (void)onUserFunctionCard:(TTUserCardInfoFunctionContentView *)card didselected:(NSIndexPath *)indexPath function:(TTUserCardFunctionItem *)function;

@end

@interface TTUserCardInfoFunctionContentView : UIView

@property (strong, nonatomic) NSMutableArray *functionItem;

@property (strong, nonatomic) UserInfo *currentUserInfo;

- (instancetype)initWithFrame:(CGRect)frame actionUid:(UserID)uid;

@property (nonatomic,weak) id<TTUserCardInfoFunctionContentViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
