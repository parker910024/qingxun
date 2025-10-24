//
//  CTInputEmoticonTabView.m
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CTInputEmoticonTabView.h"
#import "CTInputEmoticonManager.h"
#import "UIView+NIM.h"
#import "UIImage+NIMKit.h"
#import "NIMGlobalMacro.h"
#import "XCTheme.h"

const NSInteger CTInputEmoticonTabViewHeight = 35;
const NSInteger CTInputEmoticonSendButtonWidth = 66;

const CGFloat CTInputLineBoarder = .5f;

@interface CTInputEmoticonTabView()

@property (nonatomic,strong) NSMutableArray * tabs;

@property (nonatomic,strong) NSMutableArray * seps;

@end

#define sepColor NIMKit_UIColorFromRGB(0x8A8E93)

@implementation CTInputEmoticonTabView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, CTInputEmoticonTabViewHeight)];
    if (self) {
        _tabs = [[NSMutableArray alloc] init];
        _seps = [[NSMutableArray alloc] init];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
//        [_sendButton setBackgroundColor:NIMKit_UIColorFromRGB(0x0079FF)];
        
        _sendButton.nim_height = CTInputEmoticonTabViewHeight;
        _sendButton.nim_width = CTInputEmoticonSendButtonWidth;
//        [_sendButton setBackgroundImage:[UIImage imageNamed:@"emoticon_popup_button"] forState:UIControlStateNormal];
        _sendButton.backgroundColor = UIColorFromRGB(0x39E2C6);
        _sendButton.layer.cornerRadius = CTInputEmoticonTabViewHeight/2;
        _sendButton.layer.masksToBounds = YES;
        [self addSubview:_sendButton];
        
//        self.layer.borderColor = sepColor.CGColor;
//        self.layer.borderWidth = CTInputLineBoarder;
        
    }
    return self;
}


- (void)loadCatalogs:(NSArray*)emoticonCatalogs
{
//    for (UIView *subView in [_tabs arrayByAddingObjectsFromArray:_seps]) {
//        [subView removeFromSuperview];
//    }
//    [_tabs removeAllObjects];
//    [_seps removeAllObjects];
//    for (CTInputEmoticonCatalog * catelog in emoticonCatalogs) {
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage nim_fetchEmoticon:catelog.icon] forState:UIControlStateNormal];
//        [button setImage:[UIImage nim_fetchEmoticon:catelog.iconPressed] forState:UIControlStateHighlighted];
//        [button setImage:[UIImage nim_fetchEmoticon:catelog.iconPressed] forState:UIControlStateSelected];
//        [button addTarget:self action:@selector(onTouchTab:) forControlEvents:UIControlEventTouchUpInside];
//        [button sizeToFit];
//        [self addSubview:button];
//        [_tabs addObject:button];
//
//        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CTInputLineBoarder, CTInputEmoticonTabViewHeight)];
////        sep.backgroundColor = sepColor;
//        sep.backgroundColor = [UIColor clearColor];
//        [_seps addObject:sep];
//        [self addSubview:sep];
//    }
}

- (void)onTouchTab:(id)sender{
    NSInteger index = [self.tabs indexOfObject:sender];
    [self selectTabIndex:index];
    if ([self.delegate respondsToSelector:@selector(tabView:didSelectTabIndex:)]) {
        [self.delegate tabView:self didSelectTabIndex:index];
    }
}


- (void)selectTabIndex:(NSInteger)index{
    for (NSInteger i = 0; i < self.tabs.count ; i++) {
        UIButton *btn = self.tabs[i];
        btn.selected = i == index;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    CGFloat spacing = 10;
//    CGFloat left    = spacing;
//    for (NSInteger index = 0; index < self.tabs.count ; index++) {
//        UIButton *button = self.tabs[index];
//        button.nim_left = left;
//        button.nim_centerY = self.nim_height * .5f;
//
//        UIView *sep = self.seps[index];
//        sep.nim_left = (int)(button.nim_right + spacing);
//        left = (int)(sep.nim_right + spacing);
//    }
    _sendButton.nim_right = (int)self.nim_width-15;
    _sendButton.nim_top = -10;
}


@end

