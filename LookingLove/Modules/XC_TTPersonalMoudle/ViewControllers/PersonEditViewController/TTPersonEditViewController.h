//
//  TTPersonEditViewController.h
//  TuTu
//
//  Created by Macx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"

@class UserInfo;
typedef void(^TTPersonInfoRefreshHandler)(UserInfo *currentUserInfo);

@interface TTPersonEditViewController : BaseTableViewController

@property (nonatomic, copy) TTPersonInfoRefreshHandler infoRefreshHandler;

- (void)updateUserInfo:(NSString *)key value:(NSString *)value;
@end
