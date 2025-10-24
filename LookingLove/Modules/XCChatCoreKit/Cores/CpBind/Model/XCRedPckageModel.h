//
//  XCRedPckageModel.h
//  AFNetworking
//
//  Created by apple on 2019/1/19.
//  统一的红包数据模型


#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCRedPckageModel : BaseObject

///陪伴值  进入第二轮的倒计时时间
@property (nonatomic, copy) NSString *duration;
///奖励金额 600
@property (nonatomic, copy) NSString *reward;
///1 绑定红包，2 亲亲红包，3随机红包。4 早安吻红包 5.推荐奖励 6，二级推荐奖励
@property (nonatomic, copy) NSString *redPacketType;
///cp头像
@property (nonatomic, copy) NSString *cpAvatar;
///cpUid
@property (nonatomic, assign) long long cpUid;
///我的头像
@property (nonatomic, copy) NSString *avatar;
///恭喜绑定成功
@property (nonatomic, copy) NSString *title;
///已存入你们共同的账户
@property (nonatomic, copy) NSString *message;
///房间id
@property (nonatomic, assign) long long roomId;
///坚持亲亲99天，即可提现
@property (nonatomic, copy) NSString *desc;
///1 绑定红包，2 亲亲红包，3随机红包。4 早安吻红包 5.推荐奖励 6，二级推荐奖励
//@property (nonatomic, assign) NSInteger type;

///早晚安字段 0代表未读
@property (nonatomic, assign) NSInteger count;


/**************签到奖励特有字段***************/
///签到天数
@property (nonatomic, assign) NSInteger days;
///和desc内容一致
@property (nonatomic, copy) NSString *signInDesc;
///打卡天数  ”我们已经连续亲亲1天“
@property (nonatomic, copy) NSString *dateStr;



@end

NS_ASSUME_NONNULL_END
