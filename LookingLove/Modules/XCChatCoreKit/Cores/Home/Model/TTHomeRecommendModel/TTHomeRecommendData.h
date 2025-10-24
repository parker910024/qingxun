//
//  TTHomeRecommendData.h
//  AFNetworking
//
//  Created by lvjunhang on 2018/11/13.
//  兔兔首页推荐数据模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

//首页模块类型（1:顶部banner,2:星推荐,3:热门推荐,4:房间类型,5:星秀,6:底部banner,7:偶遇,8:今日头条,9:ktv）


typedef NS_ENUM(NSUInteger, TTHomeRecommendDataType) {
    TTHomeRecommendDataTypeTopBanner = 1,//头部 banner
    TTHomeRecommendDataTypeRecommend = 2,//星推荐(为你推荐)
    TTHomeRecommendDataTypeHot = 3,//热门推荐
    TTHomeRecommendDataTypeRoomClass = 4,//房间分类(房间类型)
    TTHomeRecommendDataTypeRookieRecomm = 5,//新秀推荐(星秀)
    TTHomeRecommendDataTypeBottomBanner = 6,//底部banner
    TTHomeRecommendDataTypePersonalLike = 7,//佛系交友(偶遇)
    TTHomeRecommendDataTypeHeadline = 8,//今日头条
    TTHomeRecommendDataTypeKTV = 9//KTV-和我一起嗨
};

@class TTHomeRecommendDetailData;

@interface TTHomeRecommendData : BaseObject
@property (nonatomic, assign) TTHomeRecommendDataType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<TTHomeRecommendDetailData *> *data;

/// 佛系交友 icon
@property (nonatomic, copy) NSString *icon;

@end

NS_ASSUME_NONNULL_END
