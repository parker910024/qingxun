//
//  CommunityProductInfo.h
//  AFNetworking
//
//  Created by zoey on 2019/2/28.
//

#import "CommunityInfo.h"

NS_ASSUME_NONNULL_BEGIN


@interface CommunityProductInfo : CommunityInfo


//状态描述
@property (strong , nonatomic) NSString *statusDesc;
//播放量
@property (assign , nonatomic) long long playCount;

@end

NS_ASSUME_NONNULL_END
