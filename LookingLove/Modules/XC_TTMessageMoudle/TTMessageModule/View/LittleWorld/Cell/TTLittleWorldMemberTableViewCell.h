//
//  TTLittleWorldMemberTableViewCell.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleWolrdMember.h"
#import "LittleWorldListModel.h"
NS_ASSUME_NONNULL_BEGIN

@class TTLittleWorldMemberTableViewCell;

@protocol TTLittleWorldMemberTableViewCellDelegate <NSObject>

- (void)ttLittleWorldMemberTableViewCell:(TTLittleWorldMemberTableViewCell *)cell ownerRemoveMember:(LittleWolrdMember *)member;

@end

@interface TTLittleWorldMemberTableViewCell : UITableViewCell


/** 代理*/
@property (nonatomic,assign) id<TTLittleWorldMemberTableViewCellDelegate> delegate;

/** 当前的memer*/
@property (nonatomic,strong) LittleWolrdMember *member;

/** 是不是有删除的按钮*/
@property (nonatomic,assign) TTWorldLetType type;

@end

NS_ASSUME_NONNULL_END
