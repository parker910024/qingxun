//
//  TTGroupMemberListViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "GroupMemberModel.h"
#import "FamilyCore.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTGroupMemberListViewController : BaseTableViewController
/** 选择的类型 群管理 群禁言 移出群 查看成员*/
@property (nonatomic, assign) FamilyMemberListType  listType;
/** 请求群聊列表的时候用的是 我们自己服务器的id*/
@property (nonatomic, assign) NSInteger teamId;
/** 云信服务器的id*/
@property (nonatomic, assign) NSInteger chatId;
/** 群的职务*/
@property (nonatomic,assign) GroupMemberRole role;
@end

NS_ASSUME_NONNULL_END
