//
//  TTGameRoomViewController+RoomInput.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+RoomInput.h"
#import <Masonry.h>

//公屏限制最大字数
#define MAX_STARWORDS_LENGTH 300

@implementation TTGameRoomViewController (RoomInput)


- (void)keyboardWillShow:(NSNotification *)notification {
    if ([self.roomContainerView viewWithTag:10000]) {
        //查找10000的子view，说明是私聊的键盘
        return;
    }
    
    if ([self.view.superview.subviews containsObject:self.redDrawView] ||
        [self.view.superview.subviews containsObject:self.redListView]) {
        //红包键盘弹起
        return;
    }
    
    //刷新公屏
    [self.messageView reloadChatList:NO];
    
    self.keyboardIsShow = YES;
    self.editTextFiled.text = self.inputMessage;
    [self.view bringSubviewToFront:self.editContainerView];
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat h = endKeyboardRect.size.height;
    NSLog(@"%.2f",h);
    @weakify(self);
    [UIView animateWithDuration:duration animations:^{
        @strongify(self);
        [self.editContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@40);
            make.bottom.equalTo(self.view).offset(-h);
        }];
        self.editContainerView.hidden = NO;
        [self.view layoutIfNeeded];
    }];
}

//键盘隐藏
- (void)keyboardWillHidden:(NSNotification *)notification {
    if ([self.roomContainerView viewWithTag:10000]) {
        return;
    }
    
    if ([self.view.superview.subviews containsObject:self.redDrawView] ||
        [self.view.superview.subviews containsObject:self.redListView]) {
        //红包键盘弹起
        return;
    }
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.keyboardIsShow = NO;
    [self.editContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    @weakify(self);
    [UIView animateWithDuration:duration animations:^{
        @strongify(self);
        self.editContainerView.hidden = YES;
        [self.view layoutIfNeeded];
    }];
}

-(void)textFieldEditChanged:(NSNotification *)notification{
    
    UITextField *textField = (UITextField *)notification.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    
    if ([lang isEqualToString:@"zh-Hans"]){// 简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){
            
            if (toBeString.length > MAX_STARWORDS_LENGTH){
                [XCHUDTool showErrorWithMessage:@"输入字数已达上限"];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1){
                    
                    textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }else{
                    
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > MAX_STARWORDS_LENGTH){
            [XCHUDTool showErrorWithMessage:@"输入字数已达上限"];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1){
                
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }else{
                
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    self.inputMessage = textField.text;
}


- (void)hideKeyboard {
    [self.editTextFiled resignFirstResponder];
}

@end
