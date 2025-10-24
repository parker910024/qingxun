//
//  HomeV5Banner.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  v5 banner，或可直接使用 BannerInfo

#import "BannerInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 androidVersion = "3.0.0";
 bannerId = 7;
 bannerName = meile;
 bannerPic = "https://img.erbanyy.com/FmbmgMEy1Am51nFiet7T6P-jOqSy?imageslim";
 iosVersion = "1.0.0";
 skipType = 1;
 skipUri = 121212;
 */
@interface HomeV5Banner : BaseObject
@property (nonatomic, copy) NSString *androidVersion;
@property (nonatomic, copy) NSString *iosVersion;
@property (nonatomic, copy) NSString *bannerName;
@property (nonatomic, copy) NSString *bannerPic;
@property (nonatomic, copy) NSString *skipUri;
@property (nonatomic, assign) NSInteger *skipType;
@end

NS_ASSUME_NONNULL_END
