//
//  ActivityContainInfo.h
//  AFNetworking
//
//  Created by User on 2019/5/7.
//

#import "BaseObject.h"
#import "ActivityInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface ActivityContainInfo : BaseObject

@property (nonatomic, assign) NSInteger rotateInterval;

@property (nonatomic, strong) NSMutableArray<ActivityInfo *> *list;

@end

NS_ASSUME_NONNULL_END
