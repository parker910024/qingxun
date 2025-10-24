//
//  CPOnline.h
//  AFNetworking
//
//  Created by apple on 2018/11/15.
//  查询当前陪伴值以及在线时长阶段 接口模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPOnline : BaseObject <NSCopying>
///倒计时时间，10，倒计时10分钟，20表示20分钟，30表示30分钟，0表示机会用完
@property (nonatomic, assign) int countDown;
///倒计时的开始时间
@property (nonatomic, assign) long startTime;
///用户的陪伴值
@property (nonatomic, assign) int accompanyValue;
///倒计时秒
@property (nonatomic, assign) int secondDown;
///如果不为0 就说明有两分钟的缓存时间  
@property (nonatomic, assign) int difference;

@end

NS_ASSUME_NONNULL_END
