//
//  TTGameRoomViewController+RoomInput.h
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"

@interface TTGameRoomViewController (RoomInput)

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHidden:(NSNotification *)notification;
- (void)textFieldEditChanged:(NSNotification *)notification;
- (void)hideKeyboard;

@end
