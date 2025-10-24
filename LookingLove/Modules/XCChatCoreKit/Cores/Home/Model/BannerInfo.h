//
//  BannerInfo.h
//  BberryCore
//
//  Created by chenran on 2017/7/17.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "P2PInteractiveAttachment.h"

/**
 banner 跳转类型
 
 @discussion 其实应该叫路由跳转类型，应用内跳转有两种情况：
 使用旧版 BannerInfoSkipTypePage 时，取值 skipUri；
 使用新版 BannerInfoSkipTypeInApp 时，取值 routerType 和 routerValue

 - BannerInfoSkipTypePage: app页面
 - BannerInfoSkipTypeRoom: 房间
 - BannerInfoSkipTypeWeb: H5
 - BannerInfoSkipTypeInApp: 应用内跳转，新版路由协议，
 用于代替和兼容旧版本 BannerInfoSkipTypePage

 */
typedef NS_ENUM(NSUInteger, BannerInfoSkipType) {
    BannerInfoSkipTypePage = 1,
    BannerInfoSkipTypeRoom = 2,
    BannerInfoSkipTypeWeb = 3,
    BannerInfoSkipTypeInApp = 5
};

@interface BannerInfo : BaseObject
@property (nonatomic, strong)NSString *bannerId;
@property (nonatomic, strong)NSString *bannerName;
@property (nonatomic, strong)NSString *bannerPic;
@property (nonatomic, strong)NSString *skipUri;
@property (nonatomic, assign)BannerInfoSkipType skipType;//跳转类型
@property (nonatomic, assign)NSInteger seqNo;//排序
/** banner的类型 1:顶部banner 2:底部banner */
@property (nonatomic, assign) NSInteger displayType;

#pragma mark - 新版路由协议新增
/**
 路由跳转类型
 */
@property (nonatomic, assign) P2PInteractive_SkipType routerType;
/**
 跳转参数值
 */
@property (nonatomic, copy) NSString *routerValue;


#pragma mark - mengsheng
@property (nonatomic, strong) NSString * advName;//萌声广告的name
@property (nonatomic, strong) NSString * advIcon;//萌声广告也的图片

@property (nonatomic, strong) NSString * skipUrl;//萌声分类的跳转
@property (nonatomic, strong) NSString * panelName;//萌声名称
@property (nonatomic, strong) NSString * panelPic;//萌声广告也的图片

@end
