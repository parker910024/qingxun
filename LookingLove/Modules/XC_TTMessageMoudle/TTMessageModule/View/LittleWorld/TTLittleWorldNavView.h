//
//  TTLittleWorldNavView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/1.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTLittleWorldNavViewDelegate <NSObject>

@optional
- (void)goBackDidClick;

@end

@interface TTLittleWorldNavView : UIView

/** 设置标题*/
@property (nonatomic,strong) NSString *title;

/** 是不是显示分割线*/
@property (nonatomic,assign) BOOL isShowLine;

/** 是不是显示返回*/
@property (nonatomic,assign) BOOL isShowBack;

/** 代理*/
@property (nonatomic,assign) id<TTLittleWorldNavViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
