//
//  TTRoomLoveModelAttachment.h
//  WanBan
//
//  Created by Lee on 2020/10/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "Attachment.h"
#import "RoomLoveUser.h"
#import "RoomLoveModelSuccess.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTRoomLoveModelAttachment : Attachment

// 牵手成功的用户 734 使用
@property (nonatomic, strong) NSArray<RoomLoveUser *> *users;

// 牵手动画 732
@property (nonatomic, strong) RoomLoveModelSuccess *successModel;

// 流程公屏 731 && 733 使用
@property (nonatomic, copy) NSString *msg;

// 733 相亲房下麦toast
@property (nonatomic, copy) NSArray<NSNumber *> *toUids;

@end

NS_ASSUME_NONNULL_END
