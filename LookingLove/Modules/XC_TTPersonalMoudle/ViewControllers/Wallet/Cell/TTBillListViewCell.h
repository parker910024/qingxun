//
//  TTBillListViewCell.h
//  TuTu
//
//  Created by lee on 2018/11/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBillListEnumConst.h"

NS_ASSUME_NONNULL_BEGIN
@class BaseObject;
@interface TTBillListViewCell : UITableViewCell

@property (nonatomic, assign) TTBillListViewType billType;

- (void)configModel:(__kindof BaseObject *)baseObject;

@end

NS_ASSUME_NONNULL_END
