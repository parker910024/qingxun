//
//  TTGuildGroupChatCell.h
//  TuTu
//
//  Created by lee on 2019/1/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GuildHallGroupListItem;

static NSString *const kGuildGroupChatConst = @"kGuildGroupChatConst";

@protocol TTGuildGroupChatCellDelegate <NSObject>

- (void)onJoinGroupChatClickHandler:(UIButton *)btn groupChatItem:(GuildHallGroupListItem *)item;

@end

@interface TTGuildGroupChatCell : UICollectionViewCell
@property (nonatomic, strong) GuildHallGroupListItem *listItem;
@property (nonatomic, weak) id<TTGuildGroupChatCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
