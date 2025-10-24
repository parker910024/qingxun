//
//  TTGameTextScrollView.m
//  Created by C CP on 16/9/27.
//  Copyright © 2016年 C CP. All rights reserved.
//

#import "TTGameTextScrollView.h"
#import <YYLabel.h>

@interface TTGameTextScrollView ()<UIScrollViewDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong) UIScrollView *textScrollView;
/**
 *  label的宽度
 */
@property (nonatomic,assign) CGFloat labelW;
/**
 *  label的高度
 */
@property (nonatomic,assign) CGFloat labelH;
/**
 *  定时器
 */
@property (nonatomic,strong) NSTimer *timer;
/**
 *  记录滚动的页码
 */
@property (nonatomic,assign) int page;

@end

@implementation TTGameTextScrollView

- (UIScrollView *)textScrollView {
    
    if (_textScrollView == nil) {
        
        _textScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _textScrollView.showsHorizontalScrollIndicator = NO;
        _textScrollView.showsVerticalScrollIndicator = NO;
        _textScrollView.scrollEnabled = NO;
        _textScrollView.pagingEnabled = YES;
        [self addSubview:_textScrollView];
        
//        [_textScrollView setContentOffset:CGPointMake(0 , self.labelH) animated:YES];
    }
    
    return _textScrollView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.labelW = frame.size.width;
        
        self.labelH = frame.size.height;
        
        self.textScrollView.delegate = self;
        
        [self addTimer];
        
    }
    
    return self;
}

//重写set方法 创建对应的label
- (void)setTitleArray:(NSArray *)titleArray {
    
    _titleArray = titleArray;
    
    if (titleArray == nil) {
        [self removeTimer];
        return;
    }
    
    if (titleArray.count == 1) {
        [self removeTimer];
    }
    
    id lastObj = [titleArray lastObject];
    
    NSMutableArray *objArray = [[NSMutableArray alloc] init];
    
    [objArray addObject:lastObj];
    [objArray addObjectsFromArray:titleArray];
    
    self.titleNewArray = objArray;
    
    //CGFloat contentW = 0;
    CGFloat contentH = self.labelH *objArray.count;
    
    self.textScrollView.contentSize = CGSizeMake(0, contentH);
    
    CGFloat labelW = self.textScrollView.frame.size.width;
    self.labelW = labelW;
    CGFloat labelH = self.textScrollView.frame.size.height;
    self.labelH = labelH;
    CGFloat labelX = 0;
    
//    //防止重复赋值数据叠加
//    for (id label in self.textScrollView.subviews) {
//        
//        [label removeFromSuperview];
//        
//    }
    
    [self.textScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeFromSuperview];
    }];
    
    for (int i = 0; i < objArray.count; i++) {
        
        CGFloat labelY = i * labelH;
        
        YYLabel *titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        
        titleLabel.tag = 100 + i;
        
        titleLabel.attributedText = objArray[i];
        
        [self.textScrollView addSubview:titleLabel];
        
    }
    
}

//- (void)clickTheLabel:(UITapGestureRecognizer *)tap {
//
//    if (self.clickLabelBlock) {
//
//        NSInteger tag = tap.view.tag - 1;
//
//        if (tag < 100) {
//
//            tag = 100 + (self.titleArray.count - 1);
//
//        }
//
//        self.clickLabelBlock(tag - 100,self.titleArray[tag - 100]);
//
//    }
//
//}

//- (void) clickTitleLabel:(clickLabelBlock) clickLabelBlock {
//
//    self.clickLabelBlock = clickLabelBlock;
//
//}

- (void)setIsCanScroll:(BOOL)isCanScroll {
    
    if (isCanScroll) {
        
        self.textScrollView.scrollEnabled = YES;
        
    } else {
        
        self.textScrollView.scrollEnabled = NO;
        
    }
    
}

//- (void)setTitleColor:(UIColor *)titleColor {
//
//    _titleColor = titleColor;
//
//    for (UILabel *label in self.textScrollView.subviews) {
//
//        label.textColor = titleColor;
//
//    }
//}
//
//- (void)setTitleFont:(CGFloat )titleFont {
//
//    _titleFont = titleFont;
//
//    for (UILabel *label in self.textScrollView.subviews) {
//
//        label.font = [UIFont systemFontOfSize: titleFont];;
//
//    }
//
//}

- (void)setBGColor:(UIColor *)BGColor {
    
    _BGColor = BGColor;
    
    self.backgroundColor = BGColor;
    
}

- (void)nextLabel {
    
    CGPoint oldPoint = self.textScrollView.contentOffset;
    oldPoint.y += self.textScrollView.frame.size.height;
    [self.textScrollView setContentOffset:oldPoint animated:YES];
    
}
//当滚动时调用scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.textScrollView.contentOffset.y == self.textScrollView.frame.size.height * (self.titleArray.count)) {
        
        [self.textScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        
    }
    
}


// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //开启定时器
    [self addTimer];
}

- (void)setTimerCount:(NSInteger)timerCount{
    [self removeTimer];
    if (timerCount >= 0) {
        self.timer = [NSTimer timerWithTimeInterval:timerCount target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)addTimer{
    
    /*
     scheduledTimerWithTimeInterval:  滑动视图的时候timer会停止
     这个方法会默认把Timer以NSDefaultRunLoopMode添加到主Runloop上，而当你滑tableView的时候，就不是NSDefaultRunLoopMode了，这样，你的timer就会停了。
     self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];
     */
    
    self.timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
