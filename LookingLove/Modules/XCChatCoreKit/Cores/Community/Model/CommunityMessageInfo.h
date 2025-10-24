//
//  CommunityMessageInfo.h
//  AFNetworking
//
//  Created by zoey on 2019/2/28.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityMessageInfo : BaseObject

/*消息ID*/
@property (strong , nonatomic) NSString *ID;
// 用户uid
@property (assign , nonatomic) UserID uid;
// 触发用户uid
@property (assign , nonatomic) UserID sourceUid;
// 触发用户昵称
@property (strong , nonatomic) NSString *sourceNick;
// 触发用户头像
@property (strong , nonatomic) NSString *sourceAvatar;
// 作品封面
@property (strong , nonatomic) NSString *cover;
// 状态. 1-未读, 2-已读
@property (assign , nonatomic) BOOL status;
// 关联业务的id，比如作品id、评论id
@property (strong , nonatomic) NSString *refId;

// 作品id
@property (strong , nonatomic) NSString *worksId;


// 关联业务的类型，1-作品，2-评论
@property (assign , nonatomic) int refType;

// 关联的业务是否已经被删除，比如说作品或者评论已经被删除
@property (assign , nonatomic) BOOL refIsDeleted;

// 内容
@property (strong , nonatomic) NSString *content;

// 创建时间
@property (strong , nonatomic) NSString *createTime;


//本地创建
// 创建时间
@property (strong , nonatomic) NSDate *createDate;


@end

NS_ASSUME_NONNULL_END
