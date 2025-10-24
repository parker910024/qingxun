//
//  TTGameRoomViewController+OnlineList.h
//  TuTu
//
//  Created by KevinWang on 2018/12/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"
#import "TTRoomOnlineListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (OnlineList)<TTRoomOnlineListControllerDelegate>

- (void)ttShowOnlineList;

@end

NS_ASSUME_NONNULL_END
