//
//  CTInputEmoticonTabView.h
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTInputEmoticonTabView;

@protocol CTInputEmoticonTabDelegate <NSObject>

- (void)tabView:(CTInputEmoticonTabView *)tabView didSelectTabIndex:(NSInteger) index;

@end

@interface CTInputEmoticonTabView : UIControl

@property (nonatomic,strong) UIButton * sendButton;

@property (nonatomic,weak)   id<CTInputEmoticonTabDelegate>  delegate;

- (void)selectTabIndex:(NSInteger)index;

- (void)loadCatalogs:(NSArray*)emoticonCatalogs;

@end






