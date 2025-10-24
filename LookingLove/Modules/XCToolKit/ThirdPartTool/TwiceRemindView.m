//
//  TwiceRemindView.m
//  XChat
//
//  Created by 卫明何 on 2018/3/10.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TwiceRemindView.h"

@implementation TwiceRemindView

+ (void)showTheTwiceRemindAlertWithMessage:(NSString *)message title:(NSString *)title targetVc:(UIViewController *)targetVc enter:(void(^)())sureBlock cancle:(void(^)())cancleBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
    UIAlertAction *enter = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyle)UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (sureBlock) {
            sureBlock();
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancleBlock) {
            cancleBlock();
        }
    }];
    [alert addAction:cancel];
    [alert addAction:enter];
    [targetVc presentViewController:alert animated:YES completion:^{
        
    }];
}

@end
