//
//  GuildHallManagerInfo.h
//  AFNetworking
//
//  Created by lee on 2019/1/16.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildHallManagerInfo : BaseObject
/** 标题 */
@property (nonatomic, copy) NSString *name;
/** 描述 */
@property (nonatomic, copy) NSString *desc;
/** 授权码字段 */
@property (nonatomic, copy) NSString *code;
/** 开关状态 staus为0表示未拥有此权限,status为1表示拥有此权限     */
@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END
