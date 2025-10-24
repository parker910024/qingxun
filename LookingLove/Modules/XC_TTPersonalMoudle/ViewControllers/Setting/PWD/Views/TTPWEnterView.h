//
//  TTPWEnterView.h
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPWEnterView : UIView
@property (nonatomic, assign) BOOL isSecurity;//
@property (nonatomic, strong) NSString  *title;//
@property (nonatomic, strong) NSString  *placeholder;//
@property (nonatomic, assign) int limitLeght;//
@property (nonatomic, assign) UIKeyboardType keyboardType;////
@property (nonatomic, strong) NSString  *contentString;//
//获取验证码 发送验证码
@property (nonatomic, strong) NSString  *btnTitle;//
@property (nonatomic, copy) void (^onClickCodeBtn)(void);

- (NSString *)getContentText;
@end
