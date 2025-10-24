//
//  UIView+Toast.m
//  YYMobile
//
//  Created by 武帮民 on 14-7-21.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "UIView+XCToast.h"
//#import "UIImageView+YYWebImage.h"
#import <objc/runtime.h>
#import "XCTheme.h"

#import "YYEmptyContentToastView.h"
#import "YYHudToastView.h"
#import "YYLoadingToastView.h"
#import "YYImageToastView.h"
#import "XCMacros.h"

const CGFloat VerticalPadding = 44.0;
static char kToastViewTapBlock;
static char kToastViewCompletionBlock;
static char kToastViewTapGestureRecognizer;
static char kToastViewTag;

static char kEmptyViewUserInteractionEnabled;

@interface TapGestureRecognizerDelegateImpl : NSObject<UIGestureRecognizerDelegate>

+ (instancetype)sharedDelegateImpl;

@end

@implementation TapGestureRecognizerDelegateImpl

+ (instancetype)sharedDelegateImpl
{
    static TapGestureRecognizerDelegateImpl *sharedDelegateImpl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDelegateImpl = [[self alloc] init];
    });
    
    return sharedDelegateImpl;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end



@interface UIView (SetGetToast)<UIGestureRecognizerDelegate>


@end

@implementation UIView (SetGetToast)

#pragma mark - Action Handle

- (void)onToastViewTap:(UIGestureRecognizer*)recognizer
{
    UIView *toastView = [self getToastView];
    if ([self toastViewTapBlock] && toastView) {
        [self toastViewTapBlock]();
    }
}


#pragma mark - Getter & Setter

- (void)setEmptyViewInteractionEnabled:(BOOL)emptyViewInteractionEnabled {
    objc_setAssociatedObject(self, &kEmptyViewUserInteractionEnabled, [NSNumber numberWithBool:emptyViewInteractionEnabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (BOOL)emptyViewInteractionEnabled {
    return [objc_getAssociatedObject(self, &kEmptyViewUserInteractionEnabled) boolValue];
}

- (void)setToastView:(UIView *)toast {
    
    objc_setAssociatedObject(self, &kToastViewTag,
                             toast, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIView *)getToastView {
    UIView *toastView = objc_getAssociatedObject(self, &kToastViewTag);
    // 避免找不到toast的情况
    if(toastView == nil){
        for(UIView *subView in self.subviews){
            if([subView isKindOfClass:[YYEmptyContentToastView class]]){
                toastView = subView;
                break;
            }
        }
    }
    return toastView;
}

- (void)setCompletion:(void (^)(void))completion {
    objc_setAssociatedObject(self, &kToastViewCompletionBlock,
                             completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))completion {
    return objc_getAssociatedObject(self, &kToastViewCompletionBlock);
}

- (void (^)(void))toastViewTapBlock
{
    return objc_getAssociatedObject(self, &kToastViewTapBlock);
}

- (void)setToastViewTapBlock:(void (^)(void))toastViewTapBlock
{
    objc_setAssociatedObject(self, &kToastViewTapBlock,
                             toastViewTapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UITapGestureRecognizer *)toastViewTapGestureRecognizer
{
    return objc_getAssociatedObject(self, &kToastViewTapGestureRecognizer);
}

- (void)setToastViewTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
    objc_setAssociatedObject(self, &kToastViewTapGestureRecognizer,
                             tapGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Add & Remove TapGestureRecognizer

- (void)addTapGestureRecognizerWithTapBlock:(void (^)(void))tapBlock
{
    [self removeTapGestureRecognizerAndTapBlock];
    
    [self setToastViewTapBlock:tapBlock];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(onToastViewTap:)];
    tapGestureRecognizer.delegate = [TapGestureRecognizerDelegateImpl sharedDelegateImpl];
    [self addGestureRecognizer:tapGestureRecognizer];
    [self setToastViewTapGestureRecognizer:tapGestureRecognizer];
}

- (void)removeTapGestureRecognizerAndTapBlock
{
    if([self toastViewTapGestureRecognizer]) {
        [self toastViewTapGestureRecognizer].delegate = nil;
        [self removeGestureRecognizer:[self toastViewTapGestureRecognizer]];
        [self setToastViewTapGestureRecognizer:nil];
    }
    
    if ([self toastViewTapBlock]) {
        [self setToastViewTapBlock:NULL];
    }
}


@end


@implementation UIView (XCToast)

- (void)showToastView:(UIView *)toast
             duration:(CGFloat)interval
             position:(YYToastPosition)position {
    [self showToastView:toast duration:interval position:position userInteractionEnabled:NO animated:YES];
}

- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             position:(YYToastPosition)position
userInteractionEnabled:(BOOL)userInteractionEnabled
{
    [self showToastView:toastView duration:interval position:position userInteractionEnabled:userInteractionEnabled animated:YES];
}

- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             position:(YYToastPosition)position
userInteractionEnabled:(BOOL)userInteractionEnabled
             animated:(BOOL)animated
{
    CGPoint viewCenter = CGPointZero;
    
    if (position == YYToastPositionBottom) {
        viewCenter = CGPointMake(KScreenWidth/2,
                                 (self.bounds.size.height - (toastView.frame.size.height / 2)) - 10);
    } else if (position == YYToastPositionBottomWithTabbar) {
        viewCenter = CGPointMake(KScreenWidth/2,
                                 (self.bounds.size.height - (toastView.frame.size.height / 2)) - 64);
    } else if (position == YYToastPositionBottomWithRecordButton) {
        viewCenter = CGPointMake(KScreenWidth/2,
                                 (self.bounds.size.height - (toastView.frame.size.height / 2)) - 100);
    } else if (position == YYToastPositionCenter) {
        viewCenter = CGPointMake(KScreenWidth / 2, self.bounds.size.height / 2);
    } else if (position == YYToastPositionTop) {
        viewCenter = CGPointMake(KScreenWidth / 2, 69+(toastView.frame.size.height)/2);
    } else if (position == YYToastPositionAboveKeyboard) {
        viewCenter = CGPointMake(CGRectGetWidth(self.bounds) / 2.0,
                                 (CGRectGetHeight(self.bounds) - 252.0) - CGRectGetHeight(toastView.bounds) / 2.0 - VerticalPadding);
    } else {
        viewCenter = CGPointMake(self.bounds.size.width/2, (toastView.frame.size.height / 2) + 10);
    }
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        viewCenter.y += ((UIScrollView *)self).contentOffset.y;
    }
    
    toastView.center = viewCenter;
    
    if (userInteractionEnabled != self.emptyViewInteractionEnabled) {
        userInteractionEnabled = self.emptyViewInteractionEnabled;
    }
    if (userInteractionEnabled) {
        [self showToastView:toastView duration:interval animated:animated];
    }else {
        UIView *scale = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        scale.userInteractionEnabled = YES;
        [scale addSubview:toastView];
        [self showToastView:scale duration:interval animated:animated];
    }
}

- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             position:(YYToastPosition)position
              offsetY:(NSInteger)offsetY
userInteractionEnabled:(BOOL)userInteractionEnabled
             animated:(BOOL)animated
{
    CGPoint viewCenter = CGPointZero;
    if (position == YYToastPositionBottom) {
        viewCenter = CGPointMake(self.bounds.size.width/2,
                                 (self.bounds.size.height - (toastView.frame.size.height / 2)) - 10);
    } else if (position == YYToastPositionBottomWithTabbar) {
        viewCenter = CGPointMake(self.bounds.size.width/2,
                                 (self.bounds.size.height - (toastView.frame.size.height / 2)) - 64);
    } else if (position == YYToastPositionCenter) {
        viewCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    } else if (position == YYToastPositionTop) {
        viewCenter = CGPointMake(self.bounds.size.width / 2, 69+(toastView.frame.size.height)/2);
    } else if (position == YYToastPositionAboveKeyboard) {
        viewCenter = CGPointMake(CGRectGetWidth(self.bounds) / 2.0,
                                 (CGRectGetHeight(self.bounds) - 252.0) - CGRectGetHeight(toastView.bounds) / 2.0 - VerticalPadding);
    } else {
        viewCenter = CGPointMake(self.bounds.size.width/2, (toastView.frame.size.height / 2) + 10);
    }
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        viewCenter.y += ((UIScrollView *)self).contentOffset.y;
    }
    if(offsetY){
        viewCenter.y += offsetY;
    }
    toastView.center = viewCenter;
    
    if (userInteractionEnabled != self.emptyViewInteractionEnabled) {
        userInteractionEnabled = self.emptyViewInteractionEnabled;
    }
    
    if (userInteractionEnabled) {
        [self showToastView:toastView duration:interval animated:animated];
    }else {
        UIView *scale = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        scale.userInteractionEnabled = YES;
        [scale addSubview:toastView];
        [self showToastView:scale duration:interval animated:animated];
    }
}

    
- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             animated:(BOOL)animated
{
    
    if (![NSThread isMainThread]) {
        return;
    }
    
    [self hideToastViewAnimated:NO];
    
    if (self == nil || toastView == nil)
    {
        return ;
    }

    __weak __typeof__(self) weakSelf= self;
//    __weak __typeof__(toastView) weakToast = toastView;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        toastView.alpha = 1.0;
        [weakSelf setToastView:toastView];
        if (toastView.center.x <= 0 && toastView.center.y <= 0) {
            return;
        }
        if (toastView != weakSelf) {
            [weakSelf addSubview:toastView];
        }
        
        if (interval != MAXFLOAT) {
            
            [UIView animateWithDuration:0.2
                                  delay:interval
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 toastView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                                 
                                 if (!finished) {
                                     return ;
                                 }
                                 
                                 if ([weakSelf completion]) {
                                     [weakSelf completion]();
                                 }
                                 
                                 [weakSelf hideToastViewAnimated:NO];
                                 [toastView removeFromSuperview];
                             }];
        }
    });
    
}

- (void)hideToastViewAnimated:(BOOL)animated
{
    
    [CATransaction begin];
    [self.layer removeAllAnimations];
    [CATransaction commit];
    [CATransaction flush];
    
    UIView *tempView = [self getToastView];
    if (tempView) {

        [tempView removeFromSuperview];
        tempView = nil;
        [self setToastView:nil];
    }
    
    // 移掉completion
    [self setCompletion:nil];
    
    // 如果有 TapGestureRecognizer，则移除
    [self removeTapGestureRecognizerAndTapBlock];
}

- (void)hideToastView
{
//    NSLog(@"UIView+Toast hideToastView ======= %@", NSStringFromClass([self class]));
    [self hideToastViewAnimated:YES];
}

@end

@implementation UIView (LoadingToast)

- (void)showLoadingToastWithOffsetY:(NSInteger)offsetY
{
    UIView *toast = [YYLoadingToastView instantiateLoadingToast];
    [self showToastView:toast duration:MAXFLOAT position:YYToastPositionCenter offsetY:offsetY userInteractionEnabled:NO animated:YES];
}

- (void)showLoadingToast {
//    NSLog(@"UIView+Toast showLoadingToast ======= %@", NSStringFromClass([self class]));
    [self showLoadingToastDuration:MAXFLOAT];
}

- (void)showLoadingToastDuration:(CGFloat)interval {
    UIView *toast = [YYLoadingToastView instantiateLoadingToast];
    [self showToastView:toast duration:interval position:YYToastPositionCenter];
}

- (void)showLoadingToastDuration:(CGFloat)interval msg:(NSString *)msg {
    UIView *toast = [YYLoadingToastView instantiateLoadingToastWithText:msg];
    [self showToastView:toast duration:interval position:YYToastPositionCenter];
}

- (void)showLoadingToastDuration:(CGFloat)interval completion:(void (^)(void))completion {
    
    
    UIView *toast = [YYLoadingToastView instantiateLoadingToast];
    [self showToastView:toast duration:interval position:YYToastPositionCenter];
    
    [self setCompletion:completion];
}

+ (void)showLoadingToastDuration:(CGFloat)interval msg:(NSString *)msg {
    UIView *toast = [YYLoadingToastView instantiateLoadingToastWithText:msg];
    [[UIApplication sharedApplication].delegate.window showToastView:toast duration:interval position:YYToastPositionCenter];
}

+ (void)showLoadingToastDuration:(CGFloat)interval {
    UIView *toast = [YYLoadingToastView instantiateLoadingToast];
    [[UIApplication sharedApplication].delegate.window showToastView:toast duration:interval position:YYToastPositionCenter];
}

+ (void)hideToastView {
    [[UIApplication sharedApplication].delegate.window hideToastViewAnimated:YES];
}

@end

@implementation UIView (HudToast)

+ (void)showToastInKeyWindow:(NSString *)message
{
    [[UIApplication sharedApplication].delegate.window showToast:message];
}

+ (void)showToastInKeyWindow:(NSString *)message duration:(CGFloat)interval
{
    [self showToastInKeyWindow:message duration:interval position:YYToastPositionBottomWithTabbar];
}

+ (void)showToastInKeyWindow:(NSString *)message
                    duration:(CGFloat)interval
                    position:(YYToastPosition)position {
    if (message && message.length > 0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        UIView *toast = [YYHudToastView HudToastViewWithAttributedMessage:string inRect: [[[UIApplication sharedApplication] keyWindow]bounds]];
        [[UIApplication sharedApplication].delegate.window showToastView:toast
                                                                duration:interval
                                                                position:position];
    }
}

- (void)showToast:(NSString *)message
{
    [self showToast:message highlightText:@"" highlightColor:nil position:YYToastPositionDefault];
}

- (void)showToast:(NSString *)message position:(YYToastPosition)position
{
    [self showToast:message highlightText:@"" highlightColor:nil position:position];
}

- (void)showToastWithMessage:(NSString *)message
                    duration:(CGFloat)interval
                    position:(YYToastPosition)position
{
    
    [self showToastWithMessage:message duration:interval position:position userInteractionEnabled:YES];
    
}

- (void)showToastWithMessage:(NSString *)message
                    duration:(CGFloat)interval
                    position:(YYToastPosition)position
      userInteractionEnabled:(BOOL)userInteractionEnabled {
    if (message && message.length > 0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        UIView *toast = [YYHudToastView HudToastViewWithAttributedMessage:string
                                                                   inRect:[[[UIApplication sharedApplication] keyWindow]bounds]];
    [self showToastView:toast duration:interval position:position userInteractionEnabled:userInteractionEnabled];
    }
}

- (void)showToast:(NSString *)message
    highlightText:(NSString *)text
   highlightColor:(UIColor *)color {
    [self showToast:message highlightText:text highlightColor:color position:YYToastPositionDefault];
}

- (void)showToast:(NSString *)message
    highlightText:(NSString *)text
   highlightColor:(UIColor *)color
         position:(YYToastPosition)position
{
    if (message && message.length > 0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        [string addAttribute:NSForegroundColorAttributeName value:color range:[message rangeOfString:text]];
        
        UIView *toast = [YYHudToastView HudToastViewWithAttributedMessage:string inRect:self.bounds];
        [self showToastView:toast duration:3 position:position];
    }
}

//兼容旧版本语法接口

+ (void)showSuccess:(NSString *)success {
    [[UIApplication sharedApplication].delegate.window showToastWithMessage:success duration:1.f position:YYToastPositionCenter userInteractionEnabled:YES];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    [view showToastWithMessage:success duration:1.f position:YYToastPositionCenter userInteractionEnabled:YES];
}

+ (void)showError:(NSString *)error{
    [[UIApplication sharedApplication].delegate.window showToastWithMessage:error duration:1.f position:YYToastPositionCenter userInteractionEnabled:YES];
}

+ (void)showError:(NSString *)error toView:(UIView *)view {
    [view showToastWithMessage:error duration:1.f position:YYToastPositionCenter userInteractionEnabled:YES];
}

+ (void)showMessage:(NSString *)message {
    UIView *toast = [YYLoadingToastView instantiateLoadingToastWithText:message];
    [[UIApplication sharedApplication].delegate.window  showToastView:toast duration:20.f position:YYToastPositionCenter userInteractionEnabled:NO];
}

+ (void)showMessageCPGame:(NSString *)message WithDruation:(CGFloat )duration {
    [self hideHUD];
    UIView *toast = [YYLoadingToastView instantiateLoadingToastWithText:message];
    [[UIApplication sharedApplication].delegate.window  showToastView:toast duration:duration position:YYToastPositionCenter userInteractionEnabled:NO];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    UIView *toast = [YYLoadingToastView instantiateLoadingToastWithText:message];
    [view showToastView:toast duration:MAXFLOAT position:YYToastPositionCenter userInteractionEnabled:NO];
}

+ (void)hideHUD {
    [self hideToastView];
}

+ (void)hideHUDForView:(UIView *)view {
    [view hideToastViewAnimated:YES];
}

@end

@implementation UIView (EmptyToast)

- (void)showToast:(NSString*)message duration:(CGFloat)dur position:(YYToastPosition)position image:(UIImage*)image
{
    UIView *toast = [YYImageToastView ImageToastViewWithMessage:message Image:image];
    
    [self showToastView:toast duration:dur position:position];
}

- (void)showEmptyContentToastWithTitle:(NSString *)title
{
    [self showEmptyContentToastWithTitle:title tapBlock:NULL];
}

- (void)showEmptyContentToastWithTitle:(NSString *)title andImage:(UIImage *)image
{
    [self hideToastView];
    
    YYEmptyContentToastView *toast = [YYEmptyContentToastView instantiateEmptyContentToastWithImage:image andTile:title];
    toast.titleLabel.text = title;
    toast.imageView.image = image;
    
    if (!toast) {
        return;
    }
    
    [self showToastView:toast duration:MAXFLOAT position:YYToastPositionCenter];
}

- (void)showEmptyContentToastWithTitle:(NSString *)title tapBlock:(void (^)(void))tapBlock
{
    [self hideToastView];
    
    YYEmptyContentToastView *toast = [YYEmptyContentToastView instantiateEmptyContentToast];
    toast.titleLabel.text = title;
    
    if (!toast) {
        return;
    }
    
    [self showToastView:toast duration:MAXFLOAT position:YYToastPositionCenter];
    
    if (tapBlock != NULL) {
        [self addTapGestureRecognizerWithTapBlock:tapBlock];
    }
}

- (void)showEmptyContentToastWithAttributeString:(NSAttributedString *)attrStr
{
    [self showEmptyContentToastWithAttributeString:attrStr tapBlock:NULL];
}

- (void)showEmptyContentToastWithAttributeString:(NSAttributedString *)attrStr tapBlock:(void (^)(void))tapBlock
{
    [self hideToastView];
    
    YYEmptyContentToastView *toast = [YYEmptyContentToastView instantiateEmptyContentToast];
    toast.titleLabel.attributedText = attrStr;
    
    if (!toast) {
        return;
    }
    
    [self showToastView:toast duration:MAXFLOAT position:YYToastPositionCenter];
    
    if (tapBlock != NULL) {
        [self addTapGestureRecognizerWithTapBlock:tapBlock];
    }
}

- (void)showNoSearchResultToastWithSearchKey:(NSString *)searchKey tapBlock:(void (^)(void))tapBlock
{
    UIColor *blackColor = RGBCOLOR(40, 40, 40);
    UIColor *blueColor = RGBCOLOR(50, 161, 232);
    
    // 无搜索结果的提示
//    NSString *noResultTip = getLocalizedStringFromTable(@"gamevoice_search_no_XXX_result", @"GameVoice", nil);
//    noResultTip = [noResultTip stringByReplacingOccurrencesOfString:@"XXX" withString:searchKey];
    NSString *noResultTip = @"no result";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:noResultTip];
    
    if(noResultTip.length > 0){
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:blackColor
                        range:NSMakeRange(0, attrStr.length)];
        
        NSRange highlightRange = [[noResultTip uppercaseString] rangeOfString:[searchKey uppercaseString]];
        
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:blueColor
                        range:highlightRange];
    }
    
    [self showEmptyContentToastWithAttributeString:attrStr tapBlock:tapBlock];
}


#pragma mark - Network Toast

- (void)showNetworkDisconnectToastWithPosition:(YYToastPosition)position
{
//    [self showToast:getLocalizedStringFromTable(@"network_disconnect", @"Common", nil) position:position];
    [self showToast:@"network disconnect" position:position];
    
}

+ (void)showNetworkDisconnectToastInKeyWindowWithPosition:(YYToastPosition)position
{
//    NSString *tips = getLocalizedStringFromTable(@"network_disconnect", @"Common", nil);
    NSString *tips = @"network disconnect";
    [[UIApplication sharedApplication].keyWindow showToast:tips position:position];
}

- (void)showNetworkErrorToastWithTitle:(NSString *)title
{
    [self showNetworkErrorToastWithTitle:title tapBlock:NULL];
}

- (void)showNetworkErrorToastWithTitle:(NSString *)title tapBlock:(void (^)(void))tapBlock
{
    [self hideToastView];
    
    YYEmptyContentToastView *toast = [YYEmptyContentToastView instantiateNetworkErrorToast];
    toast.titleLabel.text = title;
    
    if (!toast) {
        return;
    }
    
    [self showToastView:toast duration:MAXFLOAT position:YYToastPositionCenter animated:NO];
    
    if (tapBlock != NULL) {
        [self addTapGestureRecognizerWithTapBlock:tapBlock];
    }
}

@end


