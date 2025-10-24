//
//  CheckinDrawNotice.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/3/25.
//  瓜分金币通知栏

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckinDrawNotice : BaseObject
@property (nonatomic, copy) NSString *erbanNo;//耳伴号
@property (nonatomic, copy) NSString *goldNum;//瓜分的金币数
@end

NS_ASSUME_NONNULL_END
