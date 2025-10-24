//
//  TTGroupManagerTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGroupManagerModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, TTGroupCellSwitch_Type){
    TTGroupCellSwitch_Type_NoDistur = 1,
    TTGroupCellSwitch_Type_Verifica = 2,
};

@protocol TTGroupManagerTableViewCellDelegate <NSObject>
- (void)ttGroupManagerCellSwtich:(BOOL)status switchType:(TTGroupCellSwitch_Type)type;
@end

@interface TTGroupManagerTableViewCell : UITableViewCell
/** 是消息免打扰 还是群验证*/
@property (nonatomic, assign) TTGroupCellSwitch_Type switchType;
@property (nonatomic, assign) id<TTGroupManagerTableViewCellDelegate> delegate;
/** 配置*/
- (void)configTTGroupManagerTableViewCellWith:(TTGroupManagerModel *)managerModel;

@end

NS_ASSUME_NONNULL_END
