//
//  UIViewController+GoBack.m
//  XCBaseUIKit
//
//  Created by KevinWang on 2019/2/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "UIViewController+GoBack.h"

@implementation UIViewController (GoBack)

-(void)goBackToController:(NSString *)controllerName animated:(BOOL)animaed{
    
    if (self.navigationController) {
        
        NSArray *controllers = self.navigationController.viewControllers;
        NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            
            return [evaluatedObject isKindOfClass:NSClassFromString(controllerName)];
        }]];
        
        if (result.count > 0) {
            [self.navigationController popToViewController:result[0] animated:YES];
        }
    }
}

@end
