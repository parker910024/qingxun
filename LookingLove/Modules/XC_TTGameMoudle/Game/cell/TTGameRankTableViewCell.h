//
//  TTGameRankTableViewCell.h
//  TTPlay
//
//  Created by new on 2019/3/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGameRankModel.h"

@protocol TTGameRankTableViewCellDelegate <NSObject>

- (void)clickRankButtonJumpH5;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRankTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TTGameRankTableViewCellDelegate> delegate;


- (void)congifModel:(TTGameRankModel *)model;

@end

NS_ASSUME_NONNULL_END
