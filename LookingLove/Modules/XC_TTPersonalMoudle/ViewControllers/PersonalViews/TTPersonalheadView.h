//
//  TTPersonalheadView.h
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfo;

@protocol TTPersonalheadViewDelegate<NSObject>
//用户详情
- (void)onGotoPersonView;
//用户编辑页面
- (void)onGotoPersonEditing;
@end

@interface TTPersonalheadView : UIView
@property (nonatomic, weak) id<TTPersonalheadViewDelegate> delegate;//
@property (nonatomic, strong) UserInfo  *info;//
@end
