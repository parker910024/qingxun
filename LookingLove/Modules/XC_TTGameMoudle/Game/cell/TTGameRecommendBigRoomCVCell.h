//
//  TTGameRecommendBigRoomCVCell.h
//  TTPlay
//
//  Created by lvjunhang on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  单个方格房间视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTHomeV4DetailData;

@interface TTGameRecommendBigRoomCVCell : UICollectionViewCell

/**
 数据模型
 */
@property (nonatomic, strong, nullable) TTHomeV4DetailData *model;

/**
 显示半小时榜单的标记位，默认：NO
 
 @discussion 注意避免由于 cell 复用引起的显示错误
 */
@property (nonatomic, assign, getter=isShowRankMark) BOOL showRankMark;

@end

NS_ASSUME_NONNULL_END
