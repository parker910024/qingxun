//
//  CPGameHomeBannerModel.h
//  XCChatCoreKit
//
//  Created by new on 2019/1/21.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPGameHomeBannerModel : BaseObject

@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, strong) NSString *bannerName;
@property (nonatomic, strong) NSString *bannerPic;
@property (nonatomic, assign) NSInteger skipType;
@property (nonatomic, strong) NSString *skipUri;
@property (nonatomic, assign) NSInteger displayType;
@property (nonatomic, assign) NSInteger seqNo;

@end

NS_ASSUME_NONNULL_END
