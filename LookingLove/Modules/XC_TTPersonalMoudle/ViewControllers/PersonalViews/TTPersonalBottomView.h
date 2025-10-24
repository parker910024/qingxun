//
//  TTPersonBottomView.h
//  TuTu
//
//  Created by Macx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTPersonalTopBottomButton.h"

@protocol TTPersonalBottomViewDelegate<NSObject>

- (void)onClickFunctionType:(FunctionType)type;

@end
@class UserInfo;
@interface TTPersonalBottomView : UIView
@property (nonatomic, weak) id<TTPersonalBottomViewDelegate> delegate;//
@property (strong , nonatomic) UserInfo *info;
@end
