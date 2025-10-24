//
//  TTGameRecommendBigRoomTVCell.h
//  TTPlay
//
//  Created by lvjunhang on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  多个方格房间集合视图

#import <UIKit/UIKit.h>
#import "TTHomeV4Data.h"

NS_ASSUME_NONNULL_BEGIN

extern CGFloat const TTGameRecommendBigRoomTVCellTopMargin;//顶部边距
extern CGFloat const TTGameRecommendBigRoomTVCellBottomMargin;//底部边距

extern CGFloat const TTGameRecommendBigRoomCVCellTopMargin;//cell顶部边距
extern CGFloat const TTGameRecommendBigRoomCVCellBottomMargin;//cell底部边距
extern CGFloat const TTGameRecommendBigRoomCVCellHoriInterval;//cell水平间距
extern CGFloat const TTGameRecommendBigRoomCVCellVertInterval;//cell垂直间距
extern CGFloat const TTGameRecommendBigRoomCVCellLabelHeight;//标题+间隔 30+8

@class TTHomeV4DetailData;
@protocol TTGameRecommendCellDelegate;

@interface TTGameRecommendBigRoomTVCell : UITableViewCell
@property (nonatomic, strong) NSArray<TTHomeV4DetailData *> *dataModelArray;
@property (nonatomic, assign) id<TTGameRecommendCellDelegate> delegate;

/**
 是否为强烈推荐的数据，默认：NO
 
 @discussion 保险起见，必须在赋值【dataModelArray】之后设置 YES，否则无效
 */
@property (nonatomic, assign) BOOL isSupperDataType;

@end

NS_ASSUME_NONNULL_END
