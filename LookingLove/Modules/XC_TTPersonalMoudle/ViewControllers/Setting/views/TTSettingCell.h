//
//  TTSettingCell.h
//  TuTu
//
//  Created by Macx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchClickBlock)(BOOL isOn);

@interface TTSettingCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *dataLabel;//
/** 开关 */
@property (nonatomic, strong) UISwitch *selectSwitch;
/** 开关值改变的回调 */
@property (nonatomic, strong) SwitchClickBlock switchClickBlock;

// 隐藏箭头
- (void)hiddenArrow:(BOOL)hidden;
@end
