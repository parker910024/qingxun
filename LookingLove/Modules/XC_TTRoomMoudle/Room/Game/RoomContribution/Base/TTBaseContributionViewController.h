//
//  TTBaseContributionViewController.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TTBaseContributionTableHeaderView.h"
#import "UserID.h"

NS_ASSUME_NONNULL_BEGIN

///房间榜单需更新接口通知
extern NSString *const TTBaseContributionViewControllerShouldUpdateDataNoti;

@interface TTBaseContributionViewController : BaseUIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) TTRoomContributionType type;
@property (nonatomic, strong) TTBaseContributionTableHeaderView *headView;
@property (nonatomic, strong) NSMutableArray *dataArray;//数据源

@property (nonatomic, copy) void(^selectUserBlock)(UserID uid);


- (void)addEmpty;
- (void)removeEmpty;

/**
 更新数据接口
 */
- (void)updateData;

@end

NS_ASSUME_NONNULL_END
