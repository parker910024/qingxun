//
//  HomeDataInfor.h
//  BberryCore
//
//  Created by gzlx on 2018/4/26.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "HomebaseModel.h"

typedef NS_ENUM(NSInteger, HomeDataInforType){
    HomeDataInforTypeTopBanner = 1,//t头部banner
    HomeDataInforTypeRecommend = 2,//新秀推荐
    HomeDataInforTypeHotRoom = 3,//热门
    HomeDataInforTypeRoomClass = 4,//房间分类
    HomeDataInforTypeRookieRecomm = 5,//新秀推荐
    HomeDataInforTypeBottomBanner = 6,//底部的banner
    HomeDataInforTypePersonalLike = 7,//猜你喜欢
    HomeDataInforTypeHeadLine = 8,//耳伴头条
};

@interface HomeDataInfor : BaseObject


@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) HomeDataInforType type;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, strong) NSMutableArray<HomebaseModel *> * data;
@property (nonatomic, strong) NSString * tagId;


@end
