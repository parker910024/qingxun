//
//  TTQueueMikeCell.h
//  TuTu
//
//  Created by lee on 2018/12/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTQueueMikeCellDelegate <NSObject>

- (void)onQueueMicBtnClick:(UIButton *)btn userID:(long long)userID gender:(UserGender)gender;

@end

@interface TTQueueMikeCell : UITableViewCell
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, assign) BOOL isMyRoom;
@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic, weak) id<TTQueueMikeCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
