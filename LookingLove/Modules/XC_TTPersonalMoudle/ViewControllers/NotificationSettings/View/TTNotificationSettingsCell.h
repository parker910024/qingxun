//
//  TTNotificationSettingsCell.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/12/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNotificationSettingsItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTNotificationSettingsCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UISwitch *selectSwitch;
@property (nonatomic, copy) void (^switchClickBlock)(BOOL isOn);
@end

NS_ASSUME_NONNULL_END
