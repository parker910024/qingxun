//
//  TTMineInfoGuildsCell.h
//  TuTu
//
//  Created by lee on 2019/1/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kMineInfoGuildsCellConst = @"kMineInfoGuildsCellConst";

@class GuildOwnerHallInfo, GuildOwnerHallGroupChat;

@protocol TTMineInfoGuildsCellDelegate <NSObject>

/**
 cell 上按钮点击事件

 @param btn 被点击的 按钮
 */
- (void)onClickBtnAction:(UIButton *)btn groupChat:(GuildOwnerHallGroupChat *)groupChat;

@end

@interface TTMineInfoGuildsCell : UITableViewCell
@property (nonatomic, weak) id<TTMineInfoGuildsCellDelegate> delegate;
@property (nonatomic, strong) GuildOwnerHallInfo *infoModel;
@property (nonatomic, strong, readonly) UIButton *joinChatBtn;
@property (nonatomic, copy, readonly) NSString *publicChatID;
@end

NS_ASSUME_NONNULL_END
