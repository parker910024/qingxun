//
//  HL_PageView.m
//  pageDemo
//
//  Created by zjht_macos on 2018/3/1.
//  Copyright © 2018年 zjht_macos. All rights reserved.
//

#import "HL_PageView.h"
#import "UIViewController+Appear.h"

@interface HL_PageView ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource , UIScrollViewDelegate ,HL_SegmentViewDelegate>
{
    
    CGFloat _previousItemoffset;
    CGRect _previousItemFrame;
    CGFloat _pageWidth , _pageHeight;
}
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *childControllers;
@property (nonatomic, weak) UIScrollView *pageVcScrollView;
//是否点击了按钮
@property (nonatomic, assign) BOOL isClickItem;
@property (nonatomic, weak) HL_SegmentView *segmentView;

@property (nonatomic, assign) CGFloat lastContentOffset;


@end
@implementation HL_PageView

- (instancetype)initWithFrame:(CGRect)frame segmentView:(HL_SegmentView *)segmentView superController:(UIViewController *)superController childControllers:(NSArray *)childControllers {
    self = [super initWithFrame:frame];
    if (self) {
        self.childControllers = childControllers;
        self.segmentView = segmentView;
        _pageWidth = frame.size.width;
        _pageHeight = frame.size.height;
        [superController addChildViewController:self.pageViewController];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self addSubview:self.pageViewController.view];
    for (UIScrollView *scrollView in self.pageViewController.view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            scrollView.delegate = self;
            self.pageVcScrollView = scrollView;
        }
    }
    UIViewController *vc = self.childControllers.firstObject;
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

#pragma mark - UIPageViewControllerDelegate

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.childControllers indexOfObject:viewController];
    self.segmentView.selectedIndex = index;
    if (index == 0 ||( index == NSNotFound)) {
        return nil;
    }
    index--;
    return self.childControllers[index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.childControllers indexOfObject:viewController];
    self.segmentView.selectedIndex = index;
    if (index == self.childControllers.count - 1 || index == NSNotFound) {
        return nil;
    }
    index++;
    return self.childControllers[index];
}

#pragma mark - UIPageViewControllerDataSource
//前一个控制器
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    UIViewController *nextVC = [pendingViewControllers firstObject];
    
    NSInteger index = [self.childControllers indexOfObject:nextVC];
    
    self.segmentView.willSelctedIndex = index;
    if (ABS(self.segmentView.willSelctedIndex - self.segmentView.selectedIndex) >= 2) {//防止不松手拖拽
        self.segmentView.selectedIndex = self.segmentView.selectedIndex + self.segmentView.willSelctedIndex - self.segmentView.selectedIndex - 1;
    }
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!pageViewController.viewControllers.firstObject.isAppear) {
        return;
    }
    
    NSInteger index  = [self.childControllers indexOfObject:pageViewController.viewControllers.firstObject];
    self.segmentView.selectedIndex = index;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //全局变量记录滑动前的contentOffset
    self.lastContentOffset = scrollView.contentOffset.x;//判断左右滑动时
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"0000000000 : %f",scrollView.contentOffset.x);
    CGFloat contentOffsetX = ABS(scrollView.contentOffset.x - _pageWidth);
    if (contentOffsetX <= 0) return;
    CGFloat prograss = contentOffsetX / _pageWidth;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageView:ScrollAnimationToPrograss:)]) {
        [self.delegate pageView:self ScrollAnimationToPrograss:prograss];
    }
}

///调用系统api滚动结束方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.segmentView.willSelctedIndex != self.segmentView.selectedIndex && _isClickItem) {
        self.segmentView.selectedIndex = self.segmentView.willSelctedIndex;
    }
    self.isClickItem = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewScrollEndAnimationCheckColorWithpageView:)]) {
        [self.delegate pageViewScrollEndAnimationCheckColorWithpageView:self];
    }
}

///手动滚动结束方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewScrollEndAnimationCheckColorWithpageView:)]) {
        [self.delegate pageViewScrollEndAnimationCheckColorWithpageView:self];
    }
}

#pragma mark - HL_SegmentViewDelegate

- (void)segmentView:(HL_SegmentView *)segement SelectedItemCallBackItem:(UIButton *)item {
    self.isClickItem = YES;
    NSInteger index = item.tag;
    NSInteger direction = index - self.segmentView.selectedIndex;
    UIViewController *vc = self.childControllers[index];
    [self.pageViewController setViewControllers:@[vc] direction:direction < 0 animated:YES completion:nil];
}


- (UIPageViewController *)pageViewController {
    if (_pageViewController != nil) {
        return _pageViewController;
    }
    //    NSDictionary *option = @{UIPageViewControllerOptionInterPageSpacingKey:@20};//页边距
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.view.frame = CGRectMake(0, 0, _pageWidth, _pageHeight);
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    return _pageViewController;
}

- (void)setIsClickItem:(BOOL)isClickItem {
    _isClickItem = isClickItem;
    self.pageVcScrollView.scrollEnabled = !isClickItem;
}
@end



