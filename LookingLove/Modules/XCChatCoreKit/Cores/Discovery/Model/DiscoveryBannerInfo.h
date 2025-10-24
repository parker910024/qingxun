//
//  DiscoveryBannerInfo.h
//  AFNetworking
//
//  Created by lee on 2019/3/29.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiscoveryBannerInfo : BaseObject
@property (nonatomic, copy) NSString *bannerId;
@property (nonatomic, copy) NSString *bannerName;
/** 大图 */
@property (nonatomic, copy) NSString *bannerPic;
@property(nonatomic, assign) NSInteger skipType;
@property(nonatomic, copy) NSString *skipUri;
@property (nonatomic, copy) NSString *displayType;
@property (nonatomic, copy) NSString *seqNo;
@end

NS_ASSUME_NONNULL_END
