//
//  TTFamilyPersonMemTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamilyModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TTFamilyPersonMemTableViewCellDelegate <NSObject>

- (void)didSelectFamilyMemberWith:(XCFamilyModel *)familyMolde;

@end

@interface TTFamilyPersonMemTableViewCell : UITableViewCell

@property (nonatomic, assign) id<TTFamilyPersonMemTableViewCellDelegate> delegate;
- (void)configTTFamilyPersonMemTableViewCellWith:(NSArray<XCFamilyModel *> *)memberarray;

@end

NS_ASSUME_NONNULL_END
