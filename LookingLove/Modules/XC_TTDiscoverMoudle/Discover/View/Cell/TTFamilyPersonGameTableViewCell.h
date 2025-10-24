//
//  XCFamilyPersonGameTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamilyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyPersonGameTableViewCell : UITableViewCell

@property (nonatomic, weak) UIViewController * currentVC;

- (void)configTTFamilyPersonGameTableViewCellGameArray:(NSArray<XCFamilyModel *> *)gameArray;

@end

NS_ASSUME_NONNULL_END
