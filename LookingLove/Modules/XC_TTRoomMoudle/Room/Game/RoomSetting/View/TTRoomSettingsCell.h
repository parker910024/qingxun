//
//  TTRoomSettingsCell.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTRoomSettingsConfig;

typedef void(^SwitchClickBlock)(BOOL isOn);

@interface TTRoomSettingsCell : UITableViewCell

@property (nonatomic, strong) SwitchClickBlock switchClickBlock;

/**
 配置信息
 */
@property (nonatomic, strong) TTRoomSettingsConfig *config;

/**
 隐藏分割线
 */
@property (nonatomic, assign) BOOL hiddenSeparateLine;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UISwitch *selectSwitch;
/** detailLabel */
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *contentImageView;
@end

NS_ASSUME_NONNULL_END
