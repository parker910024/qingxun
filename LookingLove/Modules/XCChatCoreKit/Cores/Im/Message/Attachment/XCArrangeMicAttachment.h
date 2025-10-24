//
//  XCArrangeMicAttachment.h
//  AFNetworking
//
//  Created by gzlx on 2018/12/18.
//

#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCArrangeMicAttachment : Attachment
/** 操作者的UId*/
@property (nonatomic, strong) NSString * operatorUid;
/**操作者的名称 */
@property (nonatomic, strong) NSString * operatorNick;
/** 备操作的uid*/
@property (nonatomic, strong) NSString * uid;
/** 被操作者的名字*/
@property (nonatomic, strong) NSString * targetNick;
/** 更新的时间*/
@property (nonatomic, assign) UserID updateTime;
/** 在排麦列表中的位置*/
@property (nonatomic, assign) int queueCount;
/** 麦位*/
@property (nonatomic, strong) NSString * micPos;


@end

NS_ASSUME_NONNULL_END
