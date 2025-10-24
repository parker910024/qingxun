//
//  TTInputPwdView.h
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomInfo.h"

@class TTInputPwdView;

@protocol TTInputPwdViewDelegate <NSObject>
@optional


- (void)inputPwdViewDidClose:(TTInputPwdView *)passwordView;

- (void)inputPwdViewDidClose:(TTInputPwdView *)passwordView closePwdViewAndNeedPresent:(RoomInfo *)roomInfo;

@end

@interface TTInputPwdView : UIView


@property (strong, nonatomic, readonly) RoomInfo *roomInfo;

@property (weak, nonatomic) id<TTInputPwdViewDelegate> delegate;

/**
 初始化方式

 @param frame frame
 @param roomInfo 房间信息
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame roomInfo:(RoomInfo *)roomInfo title:(NSString *)title   leftAction:(NSString *)leftAction rightAction:(NSString *)rightAction;

@end
