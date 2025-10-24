//
//  NIMKitKeyboardInfo.m
//  NIMKit
//
//  Created by chris on 2017/11/3.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NIMKitKeyboardInfo.h"
#import "LittleWorldCore.h"


NSNotificationName const NIMKitKeyboardWillChangeFrameNotification = @"NIMKitKeyboardWillChangeFrameNotification";
NSNotificationName const NIMKitKeyboardWillShowNotification        = @"NIMKitKeyboardWillShowNotification";
NSNotificationName const NIMKitKeyboardWillHideNotification        = @"NIMKitKeyboardWillHideNotification";

@interface NIMKitKeyboardInfo ()

/**
 *
 */
@property (nonatomic,assign) BOOL isOtherInput;;

@end


@implementation NIMKitKeyboardInfo

@synthesize keyboardHeight = _keyboardHeight;

+ (instancetype)instance
{
    static NIMKitKeyboardInfo *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NIMKitKeyboardInfo alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputChange:) name:KTTInputViewBecomeFirstResponder object:nil];
    }
    return self;
}

- (void)inputChange:(NSNotification *)notification {
    
    _isOtherInput = YES;
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (self.isOtherInput) {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _isVisiable = endFrame.origin.y != [UIApplication sharedApplication].keyWindow.frame.size.height;
    _keyboardHeight = _isVisiable? endFrame.size.height: 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NIMKitKeyboardWillChangeFrameNotification object:nil userInfo:notification.userInfo];
}



- (void)keyboardWillHide:(NSNotification *)notification
{
    _isVisiable = NO;
    _keyboardHeight = 0;
    _isOtherInput = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NIMKitKeyboardWillChangeFrameNotification object:nil userInfo:notification.userInfo];
    GetCore(LittleWorldCore).isLittleWorldInput = NO;
}




@end
