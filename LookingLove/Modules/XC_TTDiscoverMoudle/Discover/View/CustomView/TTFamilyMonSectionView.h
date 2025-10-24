//
//  TTFamilyMonSectionView.h
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamilyMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TTFamilyMonSectionViewDelegate <NSObject>

- (void)chooseDataWith:(UIButton *)sender;

@end

@interface TTFamilyMonSectionView : UIView
@property (nonatomic, assign) id<TTFamilyMonSectionViewDelegate>delegate;

- (void)cofigFamilyMonSetionWith:(XCFamilyMoneyModel *)familyMon selectData:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
