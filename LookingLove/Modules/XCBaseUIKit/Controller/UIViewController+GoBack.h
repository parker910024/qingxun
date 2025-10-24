//
//  UIViewController+GoBack.h
//  XCBaseUIKit
//
//  Created by KevinWang on 2019/2/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (GoBack)

-(void)goBackToController:(NSString *)controllerName animated:(BOOL)animaed;

@end

NS_ASSUME_NONNULL_END
