//
//  TTGameRecommendViewProtocol.h
//  TuTu
//
//  Created by lvjunhang on 2018/12/28.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#ifndef TTGameRecommendViewProtocol_h
#define TTGameRecommendViewProtocol_h

@class BannerInfo;
@class TTHomeV4Data, TTHomeV4DetailData;
@class TTGameRecommendBigRoomTVCell;
@class TTGameRecommendRoomTVCell;
//@class TTHomeRecommendBannerCell;

@protocol TTGameRecommendCellDelegate<NSObject>

@optional

/**
 选中滚动 Banner
 
 @param data 选中的数据源
 */
//- (void)didSelectBannerCell:(TTHomeRecommendBannerCell *)cell detailData:(TTHomeV4DetailData *)data;
//- (void)didSelectBannerCell:(TTHomeRecommendBannerCell *)cell bannerData:(BannerInfo *)data;

/**
 选中大房间
 
 @param data 选中的数据源，为空表示虚位以待
 */
- (void)didSelectBigRoomCell:(TTGameRecommendBigRoomTVCell *)cell data:(TTHomeV4DetailData *)data;

/**
 选中小房间
 
 @param data 选中的数据源
 */
- (void)didSelectSmallRoomCell:(TTGameRecommendRoomTVCell *)cell data:(TTHomeV4DetailData *)data;

@end

#endif /* TTGameRecommendViewProtocol_h */
