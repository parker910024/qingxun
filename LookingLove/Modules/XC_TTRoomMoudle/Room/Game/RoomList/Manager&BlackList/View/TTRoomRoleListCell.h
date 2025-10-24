//
//  TTRoomRoleListCell.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NIMChatroomMember;

typedef void(^RemoveMemberBlock)(void);

@interface TTRoomRoleListCell : UITableViewCell

/**
 云信用户实体
 */
@property (strong, nonatomic) NIMChatroomMember *member;

@property (nonatomic, copy) RemoveMemberBlock removeMemberBlock;

@end

NS_ASSUME_NONNULL_END
