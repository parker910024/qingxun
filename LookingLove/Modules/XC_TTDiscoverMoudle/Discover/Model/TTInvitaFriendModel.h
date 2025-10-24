//
//  TTInvitaFriendModel.h
//  TTPlay
//
//  Created by Macx on 2019/1/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTInvitaFriendModel : NSObject
/** icon */
@property (nonatomic, strong) UIImage *iconImage;
/** title */
@property (nonatomic, strong) NSString *title;
/** detail */
@property (nonatomic, strong) NSString *detail;
/** 新人数组 */
@property (nonatomic, strong) NSArray<UserInfo *> *users;
/** 目标控制器 */
@property (nonatomic, strong) Class desClass;
/** hot 标签 */
@property (nonatomic, strong) UIImage *hotImage;
@end

NS_ASSUME_NONNULL_END
