//
//  TTGameOperationViewCell.h
//  TTPlay
//
//  Created by new on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGameHomeModuleModel.h"

#import "TTGameRecommendBigRoomTVCell.h"
#import "TTGameRecommendRoomTVCell.h"

static NSString *const kRoomOperationCellID = @"kRoomOperationCellID";

@protocol TTGameOperationViewCellDelegate <NSObject>

- (void)didSelectBigRoomCell:(TTGameRecommendBigRoomTVCell *)cell data:(TTHomeV4DetailData *)data;

- (void)didSelectSmallAndJumpRoomCell:(TTGameRecommendRoomTVCell *)cell data:(TTHomeV4DetailData *)data;
@end

NS_ASSUME_NONNULL_BEGIN

@interface TTGameOperationViewCell : UITableViewCell

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<TTGameHomeModuleModel *> *operationArray; //  运营可配置模块
@property (nonatomic, weak) id<TTGameOperationViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
