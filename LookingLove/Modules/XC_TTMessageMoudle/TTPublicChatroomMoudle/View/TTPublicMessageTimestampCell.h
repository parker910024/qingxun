//
//  TTPublicMessageTimestampCellTableViewCell.h
//  TuTu
//
//  Created by 卫明 on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTTimestampModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicMessageTimestampCell : UITableViewCell

@property (strong, nonatomic) UIImageView *timeBackgroud;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) TTTimestampModel *model;

@end

NS_ASSUME_NONNULL_END
