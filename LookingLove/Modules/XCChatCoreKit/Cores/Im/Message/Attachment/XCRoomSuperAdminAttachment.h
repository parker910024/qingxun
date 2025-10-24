//
//  XCRoomSuperAdminAttachment.h
//  XCChatCoreKit
//
//  Created by jiangfuyuan on 2019/8/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "Attachment.h"
#import "BaseObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface XCRoomSuperAdminAttachment : Attachment<NIMCustomAttachment>

@end


@interface TTRoomSuperAdminModel : BaseObject

@property (nonatomic, assign) UserID handleUid;
@property (nonatomic, strong) NSString *handleNick;
@property (nonatomic, assign) UserID targetUid;
@property (nonatomic, strong) NSString *targetNick;
@property (nonatomic, strong) NSString *micNumber;

@end

NS_ASSUME_NONNULL_END
