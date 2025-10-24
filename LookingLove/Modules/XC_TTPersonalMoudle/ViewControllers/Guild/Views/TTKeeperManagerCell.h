//
//  TTKeeperManagerCell.h
//  TuTu
//
//  Created by lee on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kKeeperManagerConst = @"kKeeperManagerConst";

@protocol TTKeeperManagerCellDelegate <NSObject>

- (void)onSwClickHandler:(UISwitch *)sw authStr:(NSString *)authStr;

@end

@class GuildHallManagerInfo;

@interface TTKeeperManagerCell : UITableViewCell
@property (nonatomic, weak) id<TTKeeperManagerCellDelegate> delegate;
@property (nonatomic, strong) GuildHallManagerInfo *managerInfo;
@end

NS_ASSUME_NONNULL_END
