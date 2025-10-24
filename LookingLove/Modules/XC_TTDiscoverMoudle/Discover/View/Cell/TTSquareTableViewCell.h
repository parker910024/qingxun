//
//  TTSquareTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamilyModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TTSquareTableViewCellDelegate <NSObject>

- (void)squareCellMoreButtonAction:(UIButton *)sender;

@end


@interface TTSquareTableViewCell : UITableViewCell

@property (nonatomic, assign) id<TTSquareTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL isFamilyList;
@property (nonatomic, assign) NSInteger totalFamily;
@property (nonatomic, strong) NSIndexPath * indexPath;
/** 家族广场的赋值*/
- (void)configTTSquareTableViewCellWith:(XCFamilyModel *)familyModel;
@end

NS_ASSUME_NONNULL_END
