//
//  MSHomeRecommendData.h
//  AFNetworking
//
//  Created by lvjunhang on 2018/12/21.
//  萌声首页推荐数据模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MSHomeRecommendType) {
    MSHomeRecommendTypeTopBanner = 1,//头部 banner
    MSHomeRecommendTypePopUp = 2,//人气up up！！！
    MSHomeRecommendTypeHot = 3,//热门推荐
    MSHomeRecommendTypeMidBanner = 6,//中间 banner
    MSHomeRecommendTypeRookie = 5,//新秀推荐(星秀)
    MSHomeRecommendTypeKTV = 9,//热门K歌房
    MSHomeRecommendTypeCommonRoom = 10//普通房间列表
};

@class MSHomeRecommendDetailData;

@interface MSHomeRecommendData : BaseObject
@property (nonatomic, assign) MSHomeRecommendType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSArray<MSHomeRecommendDetailData *> *data;

/// 佛系交友 icon
@property (nonatomic, copy) NSString *icon;

@end

NS_ASSUME_NONNULL_END
