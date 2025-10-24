//
//  TTVoiceMyCell.h
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VoiceBottleModel;

typedef void(^ReorderButtonDidClickAction)(VoiceBottleModel *model);
@interface TTVoiceMyCell : UITableViewCell
/** model */
@property (nonatomic, strong) VoiceBottleModel *model;

/** 重新录制按钮点击的回调 */
@property (nonatomic, strong) ReorderButtonDidClickAction reorderButtonDidClickAction;

- (void)resetVoiceMyCell;
@end

NS_ASSUME_NONNULL_END
