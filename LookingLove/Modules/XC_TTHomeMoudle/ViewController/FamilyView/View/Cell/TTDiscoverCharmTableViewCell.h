//
//  TTDiscoverCharmTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTDiscoverCharmTableViewCell : UITableViewCell

@property (nonatomic, weak) UIViewController * currentVC;

- (void)configDiscoverCharmTableViewCell:(NSArray*)charms;
@end

NS_ASSUME_NONNULL_END
