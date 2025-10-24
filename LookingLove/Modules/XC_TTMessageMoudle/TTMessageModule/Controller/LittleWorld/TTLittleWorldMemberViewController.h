//
//  TTLittleWorldMemberViewController.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LittleWorldListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTLittleWorldMemberViewController : BaseTableViewController

/** 查找的是世界的ID*/
@property (nonatomic,assign) long long worldId;

/** 小世界的身份*/
@property (nonatomic,assign) TTWorldLetType type;

@end

NS_ASSUME_NONNULL_END
