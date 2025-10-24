//
//  XCLittleWorldRoomAttachment.h
//  XCChatCoreKit
//
//  Created by apple on 2019/7/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCLittleWorldRoomAttachment : Attachment<NIMCustomAttachment>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *worldName;

/**
 *是不是加入过小世界
 */
@property (nonatomic,assign) BOOL isEnterLittleWorld;
/** 是否关注了房主 - 辅助属性 */
@property (nonatomic, assign) BOOL isFollowRoomOwner;
@end

NS_ASSUME_NONNULL_END
