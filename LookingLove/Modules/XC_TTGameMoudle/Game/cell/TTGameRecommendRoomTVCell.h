//
//  TTGameRecommendRoomTVCell.h
//  TTPlay
//
//  Created by lvjunhang on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  单行房间视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTHomeV4DetailData;
@protocol TTGameRecommendCellDelegate;

@interface TTGameRecommendRoomTVCell : UITableViewCell
@property (nonatomic, strong) TTHomeV4DetailData *model;
@property (nonatomic, assign) id<TTGameRecommendCellDelegate> delegate;

@property (nonatomic, strong) UIView *separateLine;
@end

NS_ASSUME_NONNULL_END
