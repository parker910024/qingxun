//
//  TTFamilyBottomShareView.h
//  TuTu
//
//  Created by gzlx on 2018/11/10.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamily.h"
#import "GroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyBottomShareView : UIView
@property (nonatomic, weak) UIViewController * currentVC;
@property (nonatomic, strong) XCFamily *familyModel;
@property (nonatomic, strong) GroupModel * groupModel;
@end

NS_ASSUME_NONNULL_END
