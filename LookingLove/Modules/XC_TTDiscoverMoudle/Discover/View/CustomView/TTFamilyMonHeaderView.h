//
//  TTFamilyMonHeaderView.h
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamily.h"

@protocol TTFamilyMonHeadDelegate <NSObject>
/** 贡献家族bi*/
- (void)contriMonToOwner:(UIButton *)sender;

@end
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyMonHeaderView : UIView
@property (nonatomic, weak) UIViewController * currentController;
@property (nonatomic, assign) id <TTFamilyMonHeadDelegate>delegate;
@property (nonatomic, assign) FamilyMoneyOwnerType monType;
- (void)configFamilyMoneyHeaderWithFamily:(XCFamily *)model;
@end

NS_ASSUME_NONNULL_END
