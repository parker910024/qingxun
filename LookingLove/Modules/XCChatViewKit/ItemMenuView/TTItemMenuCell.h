//
//  TTItemMenuCell.h
//  TuTu
//
//  Created by 卫明 on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//item
#import "TTItemMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTItemMenuCell : UITableViewCell

@property (strong, nonatomic) TTItemMenuItem *item;

@end

NS_ASSUME_NONNULL_END
