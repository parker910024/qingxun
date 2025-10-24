//
//  TTDiscoverPublicMessageCell.h
//  TuTu
//
//  Created by 卫明 on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//SDK
#import <NIMSDK/NIMSDK.h>


#import "NIMMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTDiscoverPublicMessageCellDelegate <NSObject>
@optional

- (BOOL)onLongPressCell:(NIMMessage *)message
                 inView:(UIView *)view;

- (BOOL)onLongPressAvatar:(NIMMessage *)message;

- (BOOL)onTapAvatar:(NIMMessage *)message;

@end

@interface TTDiscoverPublicMessageCell : UITableViewCell

/**
 云信消息实体
 */
@property (strong, nonatomic) NIMMessageModel *messageModel;

/**
 delegate:NIMMessageCellDelegate
 */
@property (nonatomic,weak) id delegate;

@end

NS_ASSUME_NONNULL_END
