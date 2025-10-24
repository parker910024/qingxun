//
//  TTGroupChatMemberAddViewController.h
//  TTPlay
//
//  Created by lee on 2019/1/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildMemberlistViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGroupChatMemberAddViewController : BaseTableViewController
/** 模厅信息 */
@property (nonatomic, strong) GuildHallInfo *hallInfo;
/** 群聊 id */
@property (nonatomic, copy) NSString *chatID;
/** 刷新 handler */
@property (nonatomic, copy) RefreshKeeperHander refreshHander;
/** 传递数据 handler */
@property (nonatomic, copy) TranfromDataHandler tranfromHandler;
/** 群聊群信息 */
@property (nonatomic, strong) GuildHallGroupInfo *groupChatInfo;
@end

NS_ASSUME_NONNULL_END
