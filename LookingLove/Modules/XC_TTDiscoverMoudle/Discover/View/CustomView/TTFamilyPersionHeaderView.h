//
//  TTFamilyPersionHeaderView.h
//  TuTu
//
//  Created by gzlx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamily.h"
#import "TTFamilyManagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyPersionHeaderView : UIView
/** 管理家族*/
@property (nonatomic, strong) TTFamilyManagerView * managerView;
@property (nonatomic, weak) UIViewController * controtroller;
-(void)configTTFamilypersonHeaderViewWithFamily:(XCFamily *)family;

@end

NS_ASSUME_NONNULL_END
