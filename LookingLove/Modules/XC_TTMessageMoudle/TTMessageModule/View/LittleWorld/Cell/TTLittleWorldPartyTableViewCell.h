//
//  TTLittleWorldPartyTableViewCell.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/1.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTLittleWorldPartyModel.h"
@class TTLittleWorldPartyTableViewCell;
NS_ASSUME_NONNULL_BEGIN

@protocol TTLittleWorldPartyTableViewCellDelegate <NSObject>
@optional
- (void)ttLittleWorldPartyTableViewCell:(TTLittleWorldPartyTableViewCell *)cell enterButtonDidClick:(UIButton *)sender;

@end

@interface TTLittleWorldPartyTableViewCell : UITableViewCell

/** 代理*/
@property (nonatomic,assign) id<TTLittleWorldPartyTableViewCellDelegate> delegate;

/** 派对的*/
@property (nonatomic,strong) TTLittleWorldPartyModel *partyModel;

@end

NS_ASSUME_NONNULL_END
