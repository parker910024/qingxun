//
//  TTRecommendBaseCell.h
//  TTPlay
//
//  Created by lee on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 cell 显示类型

 - TTRecommendCellStyleUndefined: 未定义
 - TTRecommendCellStyleUnUsed: 未使用
 - TTRecommendCellStyleUsing: 使用中
 - TTRecommendCellStyleUsed: 已使用
 - TTRecommendCellStyleInvalid: 已失效
 */
typedef NS_ENUM(NSUInteger, TTRecommendCellStyle) {
    /** 未定义 */
    TTRecommendCellStyleUndefined = 0,
    /** 未使用 */
    TTRecommendCellStyleUnUsed = 1,
    /** 使用中 */
    TTRecommendCellStyleUsing = 2,
    /** 已使用 */
    TTRecommendCellStyleUsed = 3,
    /** 已失效 */
    TTRecommendCellStyleInvalid = 4,
};

static NSString *const kTTRecommendBaseCellConst = @"kTTRecommendBaseCellConst";

@class RecommendModel;
NS_ASSUME_NONNULL_BEGIN

@interface TTRecommendBaseCell : UITableViewCell
/** cell 风格 */
@property (nonatomic, assign) TTRecommendCellStyle cellStyle;
@property (nonatomic, strong) RecommendModel *model;
@property (nonatomic, copy) void(^recommendCellBtnClickHandler)(RecommendModel *model);
@end

NS_ASSUME_NONNULL_END
