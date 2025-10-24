//
//  TTVoiceTableViewCell.h
//  XC_TTPersonalMoudle
//
//  Created by fengshuo on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "TTMineInfoEnumConst.h"
NS_ASSUME_NONNULL_BEGIN

@class TTMineInfoVoiceCell;

@protocol TTMineInfoVoiceCellDelegate <NSObject>

- (void)personNoVoiceToAddVoice:(TTMineInfoVoiceCell *)cell;

@end

@interface TTMineInfoVoiceCell : UITableViewCell

/** 用户信息*/
@property (nonatomic,strong) UserInfo *userInfo;


/** 查看自己还是查看别人*/
@property (nonatomic,assign) TTMineInfoViewStyle style;

/** 代理*/
@property (nonatomic,assign) id<TTMineInfoVoiceCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
