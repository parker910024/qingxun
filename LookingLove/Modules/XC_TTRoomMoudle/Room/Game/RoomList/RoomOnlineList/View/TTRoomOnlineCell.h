//
//  TTRoomOnlineCell.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NIMChatroomMember;

@interface TTRoomOnlineCell : UITableViewCell

/**
 云信房间成员实体
 */
@property (strong, nonatomic) NIMChatroomMember *member;

@end

NS_ASSUME_NONNULL_END
