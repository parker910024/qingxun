//
//  LLDynamicSquareCell.h
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/7.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLProfileView.h"
#import "LTDynamicToolView.h"
#import <YYText/YYText.h>

@class CTDynamicModel, LLDynamicLayoutModel, LLStatusToolView;

typedef void(^DynamicRefreshCellOpenUpBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@protocol LLDynamicSquareCellDelegate <NSObject>

// 用户信息view 点击事件
- (void)didSelectProfileAtCellLayoutModel:(LLDynamicLayoutModel *)layout actionType:(ProfileViewActionType)actionType;

// 底部工具栏 点击事件
- (void)didSelectToolBarViewAtCellLayoutModel:(LLDynamicLayoutModel *)layout actionType:(ToolViewActionType)actionType toolView:(LTDynamicToolView *)toolView;

@end

@interface LLDynamicSquareCell : UITableViewCell
///动态模型
@property (nonatomic, strong) CTDynamicModel *dynamicModel;
@property (nonatomic, strong) LLDynamicLayoutModel *layout;

@property (nonatomic, strong, readonly) LLStatusToolView *worldView;

@property (nonatomic, copy) DynamicRefreshCellOpenUpBlock openUpBlock;
@property(nonatomic, weak) id<LLDynamicSquareCellDelegate> delegate;

@property (nonatomic, copy) void (^albumEmptyAreaHandler)(void);//相册空白处

@end

NS_ASSUME_NONNULL_END
