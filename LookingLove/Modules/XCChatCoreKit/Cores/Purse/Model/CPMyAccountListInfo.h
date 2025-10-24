//
//  CPMyAccountListInfo.h
//  AFNetworking
//
//  Created by apple on 2018/11/6.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPMyAccountListInfo : BaseObject


@property (copy, nonatomic)NSString *name;

@property (assign, nonatomic)int type;

@property (copy, nonatomic)NSString *changeMoney;

@property (copy, nonatomic)NSString *date;
@end

NS_ASSUME_NONNULL_END
