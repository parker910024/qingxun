//
//  TTNewUserCollectionViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "XCFamilyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTNewUserCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isShowID;
- (void)configTTNewUserCollectionViewCell:(UserInfo *)infor;

- (void)configTTFamilyGameCellWith:(XCFamilyModel *)familyModel;

@end

NS_ASSUME_NONNULL_END
