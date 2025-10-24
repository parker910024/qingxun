//
//  CPMyAccountInfo.h
//  AFNetworking
//
//  Created by apple on 2018/10/14.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface CPMyAccountInfo : BaseObject

/**共同账号*/
@property (copy, nonatomic)NSString *commonAccount;
/**jianli金额*/
@property (copy, nonatomic)NSString *reward;
/**多少天后可ti xian*/
@property (copy, nonatomic)NSString *leftDay;
/**可t x金额*/
@property (copy, nonatomic)NSString *amount;
/**满多少元可 ti xian */
@property (copy, nonatomic)NSString *withdrawLimit;

/**现金jianli*/
@property (copy, nonatomic)NSString *cashReward;

/**领取奖励的周期，99天 */
@property (copy, nonatomic)NSString *duration;


/* 个人*/
@property (copy, nonatomic)NSString *withdrawableAmount;

@end


