//
//  TTDynamicMessageCell.h
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2019/11/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DynamicMessage;
@interface TTDynamicMessageCell : UITableViewCell

@property (nonatomic, strong) DynamicMessage *model;
@property (nonatomic, copy) void (^avatarActionHandler)(void);//头像动作回调
@property (nonatomic, copy) void (^nameActionHandler)(void);//姓名性别年龄动作回调
@end

NS_ASSUME_NONNULL_END
