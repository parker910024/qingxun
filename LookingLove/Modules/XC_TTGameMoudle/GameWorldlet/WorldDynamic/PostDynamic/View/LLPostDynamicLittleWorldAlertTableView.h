//
//  LLPostDynamicLittleWorldAlertTableView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/1/9.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LittleWorldDynamicPostWorld.h"

#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLPostDynamicLittleWorldAlertViewCell : UITableViewCell

@property (nonatomic, strong) LittleWorldDynamicPostWorld *model;

@property (nonatomic, strong) UIImageView *avatarImageView;//头像
@property (nonatomic, strong) UILabel *nameLabel;//名称
@property (nonatomic, strong) UILabel *desLabel;//描述
@end

@interface LLPostDynamicLittleWorldAlertTableView : UITableView<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) DynamicPostWorldRequestType requestType;//查看类型
@property (nonatomic, strong) NSMutableArray<LittleWorldDynamicPostWorld *> *dataArray;
@property (nonatomic, copy) void (^selectWorldHandler)(LittleWorldDynamicPostWorld *model);
@end

NS_ASSUME_NONNULL_END
