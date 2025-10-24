//
//  TTLittleWorldSearchView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTLittleWorldSearchView;

@protocol TTLittleWorldSearchViewDelegate <NSObject>

/** 点击了搜索框*/
- (void)tapTTLittleWorldSearchView:(TTLittleWorldSearchView *)searchView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTLittleWorldSearchView : UIView

/** 代理*/
@property (nonatomic,assign) id<TTLittleWorldSearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
