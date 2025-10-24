//
//  HL_SegmentView.m
//  pageDemo
//
//  Created by 黄清华 on 2018/3/2.
//  Copyright © 2018年 zjht_macos. All rights reserved.
//

#import "HL_SegmentView.h"
#import "HL_PageView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"

@interface HL_SegmentView () <HL_PageViewDelegate>
@property (nonatomic, strong) UIScrollView *itemScrollView;
@property (nonatomic, strong) UIView *selLine;
@property (nonatomic, strong) UIButton *selectedButton;
//@property (nonatomic, assign) BOOL isClickItem;


@end

@implementation HL_SegmentView {
    CGFloat _previousItemoffset;
    CGRect _previousItemFrame;
    CGFloat _norRed , _norGreen , _norBlue;
    CGFloat _selRed , _selGreen , _selBlue;
    UIColor *_titleNorColor , *_titleSelColor;
    CGFloat _segmentWidth , _segmentHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _segmentWidth = frame.size.width;
        _segmentHeight = frame.size.height;
    }
    return self;
}

- (void)setUpComplete {
    [self setUpUI];
}

- (void)setDefaultSelectedWithIndex:(NSInteger)index {
    self.willSelctedIndex = index;
    self.selectedIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:SelectedItemCallBackItem:)]) {
        UIButton *item = [self.itemScrollView viewWithTag:index];
        [self.delegate segmentView:self SelectedItemCallBackItem:item];
    }
}

#pragma mark - HL_PageViewDelegate

- (void)pageView:(HL_PageView *)pageView ScrollAnimationToPrograss:(CGFloat)prograss {
    if (self.selectedIndex == self.willSelctedIndex) return;
    CGFloat redOffset = _selRed - _norRed;
    CGFloat greenOffset = _selGreen - _norGreen;
    CGFloat blueOffset = _selBlue - _norBlue;
    UIButton *nextBtn = self.itemScrollView.subviews[self.willSelctedIndex];
    CGFloat lineWidthOffset = nextBtn.frame.size.width - 32;
    CGFloat lineXOffset = nextBtn.centerX  - _previousItemFrame.origin.x - 32/2.f;
    CGRect lineFrame = _previousItemFrame;
    CGFloat x = lineFrame.origin.x;
//    CGFloat width = lineFrame.size.width;
    lineFrame.origin.x =  x + prograss *lineXOffset;
    lineFrame.size.width =  32;
    [nextBtn setTitleColor:[[UIColor alloc] initWithRed:(_norRed + redOffset*prograss)/255.0 green:(_norGreen + greenOffset*prograss)/255.0 blue:(_norBlue + blueOffset*prograss)/255.0 alpha:1] forState:UIControlStateNormal];
    [self.selectedButton setTitleColor:[[UIColor alloc] initWithRed:(_selRed - redOffset*prograss)/255.0 green:(_selGreen - greenOffset*prograss)/255.0 blue:(_selBlue - blueOffset*prograss)/255.0 alpha:1] forState:UIControlStateNormal];
    CGFloat offsetFont = self.titleSelFont.pointSize - self.titleNorFont.pointSize;
    if (![self.titleNorFont isEqual:self.titleSelFont]) {//字体大小不一致才做动画
        nextBtn.titleLabel.font = [UIFont fontWithName:self.titleNorFont.fontName size: self.titleNorFont.pointSize + offsetFont * prograss];
        self.selectedButton.titleLabel.font = [UIFont fontWithName:self.titleSelFont.fontName size:self.titleSelFont.pointSize - offsetFont * prograss];
    }
//    CGFloat nextW = [nextBtn sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
//    CGFloat selW = [self.selectedButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
//    nextBtn.width = MAX(nextW, nextBtn.width);
//    self.selectedButton.width =  MAX(selW, self.selectedButton.width);
    CGFloat centerXOffset = nextBtn.center.x - _segmentWidth/2.0;
    if (nextBtn.center.x  + _segmentWidth/2.0 > self.itemScrollView.contentSize.width)
        centerXOffset = self.itemScrollView.contentSize.width - _segmentWidth;//向后滚
    if (centerXOffset < 0) {//往回滚
        centerXOffset = 0;
    }
    [self.itemScrollView setContentOffset:CGPointMake(_previousItemoffset + (centerXOffset - _previousItemoffset )*prograss , 0)];
    lineFrame.size.width = 32;
    self.selLine.centerX = lineFrame.origin.x + lineFrame.size.width/2.f;
}

- (void)pageViewScrollEndAnimationCheckColorWithpageView:(HL_PageView *)pageView {
    [self handleItemColor];
}


#pragma mark - 自定义按钮

- (void)didClickItem:(UIButton *)item {
    if (self.pageVcScrollView.isDecelerating || self.pageVcScrollView.isDragging || item == self.selectedButton) return;
    NSInteger index = item.tag;
    self.willSelctedIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:SelectedItemCallBackItem:)]) {
        [self.delegate segmentView:self SelectedItemCallBackItem:item];
    }
}

#pragma mark - 私有方法
- (void)setUpUI {
    [self addSubview:self.itemScrollView];
    CGFloat speaceW = self.itemMarge;
    UIButton *previousBtn = nil;
    for (int i = 0; i < self.titles.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        btn.tag = i;
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.titleNorFont];
        [btn addTarget:self action:@selector(didClickItem:) forControlEvents:UIControlEventTouchUpInside];
        if (self.isAvgWith) {//平分宽度
            CGFloat avgW = self.width/self.titles.count;
            btn.frame = CGRectMake(i * avgW, 0, avgW, self.height - 6);
        }else {//不是平分
            if (i == 0) {
                btn.frame = CGRectMake(self.leftRightMarge, 0, [self getTextWidthWithString:self.titles[i] font:self.titleSelFont] + 10, _segmentHeight - 6);
            }else {
                CGFloat offsetW = [self getTextWidthWithString:self.titles[i] font:self.titleSelFont] - [self getTextWidthWithString:self.titles[i] font:self.titleNorFont];
                btn.frame = CGRectMake(CGRectGetMaxX(previousBtn.frame) + speaceW - offsetW/2, 0, [self getTextWidthWithString:self.titles[i] font:self.titleSelFont] + 10, _segmentHeight - 6);
            }
        }
        previousBtn = btn;
        [self.itemScrollView addSubview:btn];
    }
    CGFloat contentSizeW = self.isAvgWith ? CGRectGetMaxX(previousBtn.frame) : CGRectGetMaxX(previousBtn.frame) + 10;
    [self.itemScrollView setContentSize:CGSizeMake(contentSizeW, 0)];
    self.selectedIndex = 0;
}

- (CGFloat)getTextWidthWithString:(NSString *)string font:(UIFont *)font {
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, _segmentHeight - 6) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :font} context:nil].size.width;
}

- (void)getColorRGBColor:(UIColor *)color IsSelColor:(BOOL)isSelColor {
    
    CGFloat r=0,g=0,b=0,a=0;
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&r green:&g blue:&b alpha:&a];
    }else {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    if (isSelColor) {
        _selRed = r*255.0 ;_selGreen =g*255.0 ;_selBlue = b*255.0;
    }else {
        _norRed = r*255.0 ;_norGreen = g*255.0 ;_norBlue = b*255.0;
    }
}

- (void)handleItemColor {
    self.selLine.frame = CGRectMake(self.selectedButton.frame.origin.x, self.height- 3, 12, 3);
    self.selLine.centerX = self.selectedButton.centerX;
    self.selLine.layer.cornerRadius = 3/2.f;
    self.selLine.layer.masksToBounds = YES;
    CGFloat centerXOffset = self.selectedButton.center.x - _segmentWidth/2.0;
    if (self.selectedButton.center.x  + _segmentWidth/2.0 > self.itemScrollView.contentSize.width) centerXOffset = self.itemScrollView.contentSize.width - _segmentWidth;//向后滚
    if (centerXOffset < 0) {//往回滚
        centerXOffset = 0;
    }
    [self.itemScrollView setContentOffset:CGPointMake(centerXOffset , 0)];
    _previousItemoffset = self.itemScrollView.contentOffset.x;
    _previousItemFrame = self.selLine.frame;
    
    for (UIButton *btn in self.itemScrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn != self.selectedButton) {
                [btn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
                btn.titleLabel.font = self.titleNorFont;
//                CGFloat nextW = [btn sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.height)].height;
//                btn.width = MAX(nextW, btn.width);
            }
        }
    }
//    CGFloat selW = [self.selectedButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
//    self.selectedButton.width =  MAX(selW, self.selectedButton.width);
    [self.selectedButton setTitleColor:self.titleSelColor forState:UIControlStateNormal];
    self.selectedButton.titleLabel.font = self.titleSelFont;

}


#pragma mark - get/set

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0) return;
    _selectedIndex = selectedIndex;
    self.selectedButton = self.itemScrollView.subviews[self.selectedIndex];
    [self handleItemColor];
}

- (void)setTitleNorColor:(UIColor *)titleNorColor {
    _titleNorColor = titleNorColor;
    for (UIButton *btn in self.itemScrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn != self.selectedButton) [btn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
        }
    }
    [self getColorRGBColor:titleNorColor IsSelColor:NO];
}

- (void)setTitleNorFont:(UIFont *)titleNorFont {
    _titleNorFont = titleNorFont;
    for (UIButton *btn in self.itemScrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn != self.selectedButton) btn.titleLabel.font = titleNorFont;
        }
    }
}

- (void)setTitleSelFont:(UIFont *)titleSelFont {
    _titleSelFont = titleSelFont;
    self.selectedButton.titleLabel.font = titleSelFont;
}

- (UIColor *)titleNorColor {
    if (_titleNorColor == nil) {
        UIColor *norColor = [UIColor grayColor];
        [self getColorRGBColor:norColor IsSelColor:NO];
        self.titleNorColor = norColor;
    }
    return _titleNorColor;
}

- (void)setTitleSelColor:(UIColor *)titleSelColor {
    _titleSelColor = titleSelColor;
    [self.selectedButton setTitleColor:titleSelColor forState:UIControlStateNormal];
    [self getColorRGBColor:titleSelColor IsSelColor:YES];
}

- (UIColor *)titleSelColor {
    if (_titleSelColor == nil) {
        UIColor *selColor = [UIColor blackColor];
        [self getColorRGBColor:selColor IsSelColor:YES];
        self.titleSelColor = selColor;
    }
    return _titleSelColor;
}

- (CGFloat)itemMarge {
    if (_itemMarge == 0) {
        _itemMarge = 15;
    }
    return _itemMarge;
}

- (CGFloat)leftRightMarge {
    if (_leftRightMarge == 0) {
        _leftRightMarge = 15;
    }
    return _leftRightMarge;
}

- (UIScrollView *)itemScrollView {
    if (_itemScrollView != nil) {
        return _itemScrollView;
    }
    _itemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _segmentWidth, _segmentHeight)];
    _itemScrollView.showsHorizontalScrollIndicator = NO;
    return _itemScrollView;
}

- (UIView *)selLine {
    if (_selLine != nil) {
        return _selLine;
    }
    _selLine = [[UIView alloc]initWithFrame:CGRectZero];
    _selLine.backgroundColor = UIColorFromRGB(0x39E2C6);
    [self.itemScrollView addSubview:_selLine];
    return _selLine;
}



@end

