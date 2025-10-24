//
//  XCLittleWorldAutoQuitView.h
//  XC_TTMessageMoudle
//
//  Created by Lee on 2019/10/31.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCLittleWorldAutoQuitAttachment.h"
#import "MessageLayout.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XCLittleWorldAutoQuitViewDelegate <NSObject>

/// 点击消息体上的加入按钮事件
/// @param btn 加入按钮
- (void)onClickAutoQuitViewButtonAction:(UIButton *)btn;

@end

@interface XCLittleWorldAutoQuitView : UIView

@property (nonatomic, strong) MessageLayout *layout; // 实体
@property(nonatomic, weak) id<XCLittleWorldAutoQuitViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
