//
//  TTGameExitAlertView.h
//  TuTu
//
//  Created by new on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTGameExitAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message cancel:(void(^)(void))cancel ensure:(void(^)(void))ensure;
@end

NS_ASSUME_NONNULL_END
