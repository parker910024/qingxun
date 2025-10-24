//
//  TTPersonGroupTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamilyModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TTPersonGroupTableViewCellDelegate <NSObject>

- (void)enterFamilyGroupWithFamilyModel:(XCFamilyModel *)group;

@end

@interface TTPersonGroupTableViewCell : UITableViewCell

@property(nonatomic, assign) id<TTPersonGroupTableViewCellDelegate>delegate;

- (void)configTTPersonGroupTableViewCellWithfamilyModel:(XCFamilyModel *)family;

@end

NS_ASSUME_NONNULL_END
