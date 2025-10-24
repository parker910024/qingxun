//
//  TTPersonalMidView.h
//  TuTu
//
//  Created by Macx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPersonalTopBottomButton.h"

@protocol TTPersonalMidViewDelegate<NSObject>

- (void)onClickFunctionType:(FunctionType)type;

@end

@class UserInfo;

@interface TTPersonalMidView : UIView

@property (nonatomic, assign) id<TTPersonalMidViewDelegate> delegate;//

@property (nonatomic, strong) UserInfo  *info;//

@end
