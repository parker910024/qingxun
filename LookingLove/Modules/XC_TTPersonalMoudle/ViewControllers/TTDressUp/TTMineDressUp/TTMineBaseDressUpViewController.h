//
//  TTMineBaseDressUpViewController.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "TTDressUpUIClient.h"
#import "UserCoreClient.h"
#import "ZJScrollPageViewDelegate.h"

@interface TTMineBaseDressUpViewController : BaseTableViewController<ZJScrollPageViewChildVcDelegate,UserCoreClient>
@property (nonatomic, strong) NSMutableArray  *data;// 数据
@property (nonatomic, assign) TTDressUpPlaceType type;//
- (void)reloadData;
@end
