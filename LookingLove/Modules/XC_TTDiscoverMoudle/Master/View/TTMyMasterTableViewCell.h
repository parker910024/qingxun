//
//  TTMyMasterTableViewCell.h
//  TTPlay
//
//  Created by Macx on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UserInfo;

typedef void(^DeleteButtonDidClickBlcok)(long long uid);
@interface TTMyMasterTableViewCell : UITableViewCell
/** 解除关系按钮被点击的回调 */
@property (nonatomic, strong) DeleteButtonDidClickBlcok deleteButtonDidClickBlcok;

/** userinfo */
@property (nonatomic, strong) UserInfo *userInfo;
@end

NS_ASSUME_NONNULL_END
