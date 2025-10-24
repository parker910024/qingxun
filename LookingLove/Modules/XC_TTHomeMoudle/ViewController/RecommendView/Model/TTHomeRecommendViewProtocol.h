//
//  TTHomeRecommendViewProtocol.h
//  TuTu
//
//  Created by lvjunhang on 2018/12/28.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#ifndef TTHomeRecommendViewProtocol_h
#define TTHomeRecommendViewProtocol_h

@class BannerInfo;
@class TTHomeV4Data, TTHomeV4DetailData;
@class TTHomeRecommendBigRoomTVCell;
@class TTHomeRecommendRoomTVCell;
@class TTHomeRecommendBannerCell;

@protocol PDHomeRecommendCellDelegate<NSObject>

@optional

/**
 选中滚动 Banner
 
 @param data 选中的数据源
 */
- (void)didSelectBannerCell:(TTHomeRecommendBannerCell *)cell detailData:(TTHomeV4DetailData *)data;
- (void)didSelectBannerCell:(TTHomeRecommendBannerCell *)cell bannerData:(BannerInfo *)data;

/**
 选中大房间
 
 @param data 选中的数据源，为空表示虚位以待
 */
- (void)didSelectBigRoomCell:(TTHomeRecommendBigRoomTVCell *)cell data:(TTHomeV4DetailData *)data;

/**
 选中小房间
 
 @param data 选中的数据源
 */
- (void)didSelectSmallRoomCell:(TTHomeRecommendRoomTVCell *)cell data:(TTHomeV4DetailData *)data;

@end

#endif /* TTHomeRecommendViewProtocol_h */
