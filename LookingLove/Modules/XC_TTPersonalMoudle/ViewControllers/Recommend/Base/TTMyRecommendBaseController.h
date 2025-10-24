//
//  TTMyRecommendBaseController.h
//  TTPlay
//
//  Created by lee on 2019/2/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
#import "TTRecommendBaseCell.h"
// core
#import "RecommendCore.h"
#import "RecommendClient.h"
// model
#import "RecommendModel.h"
#import "BaseTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTMyRecommendBaseController : BaseTableViewController<ZJScrollPageViewChildVcDelegate, RecommendClient>

@property (nonatomic, strong) NSMutableArray<RecommendModel *> *dataArray;

@property (nonatomic, assign) TTRecommendCellStyle currentStyle;

- (TTRecommendCellStyle)style;
@end

NS_ASSUME_NONNULL_END
