//
//  TTWorldletRoomModel.h
//  AFNetworking
//
//  Created by apple on 2019/7/11.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletRoomModel : BaseObject

@property (nonatomic, assign) NSInteger worldId;
@property (nonatomic, strong) NSString *worldName;
@property (nonatomic, assign) BOOL inWorld;

@property (nonatomic, assign) UserID uid;
@property (nonatomic, strong) NSString *nick;
@end

NS_ASSUME_NONNULL_END
