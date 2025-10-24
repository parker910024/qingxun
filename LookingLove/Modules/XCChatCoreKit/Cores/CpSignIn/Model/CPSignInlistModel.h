//
//  CPSignInlistModel.h
//  AFNetworking
//
//  Created by apple on 2018/12/24.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPSignInlistModel : BaseObject
///签到列表字典数据 {"date":"2018-10-01","status":0}
@property (nonatomic, copy) NSArray *list;
///今天的日期 2018-11-01
@property (nonatomic, copy) NSString *today;
///连续签到天数
@property (nonatomic, copy) NSString *days;
///我是否打卡  false未打卡  true打卡
@property (nonatomic, assign) BOOL uidStatus;
///cp方是否打卡  false未打卡  true打卡
@property (nonatomic, assign) BOOL cpUidStatus;

@end

NS_ASSUME_NONNULL_END
