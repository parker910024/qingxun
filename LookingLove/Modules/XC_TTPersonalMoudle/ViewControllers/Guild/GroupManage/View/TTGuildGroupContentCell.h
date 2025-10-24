//
//  TTGuildGroupContentCell.h
//  TuTu
//
//  Created by lvjunhang on 2019/1/9.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//  头像、选择群分类、switch、名称共用

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTGuildGroupManageConfig;

typedef void(^SwitchClickBlock)(BOOL isOn);
typedef void(^InnerGroupClickBlock)(void);
typedef void(^OuterGroupClickBlock)(void);

@interface TTGuildGroupContentCell : UITableViewCell

@property (nonatomic, copy) SwitchClickBlock switchClickBlock;
@property (nonatomic, copy) InnerGroupClickBlock innerGroupClickBlock;
@property (nonatomic, copy) OuterGroupClickBlock outerGroupClickBlock;

@property (nonatomic, strong) TTGuildGroupManageConfig *config;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UISwitch *selectSwitch;//消息免打扰

@property (nonatomic, strong) UIButton *outerGroupButton;//外部群
@property (nonatomic, strong) UIButton *innerGroupButton;//内部群

@end

NS_ASSUME_NONNULL_END
