//
//  TTPopupManagerService.m
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPopupManagerService.h"

#import <FFPopup/FFPopup.h>

@interface TTPopupManagerService ()

@property (nonatomic, strong) NSMutableArray< id<TTPopupServiceProtocol> > *queue;

/**
 当前是否正在显示状态
 */
@property (nonatomic, assign, getter=isShowingPopup) BOOL showingPopup;

@end

@implementation TTPopupManagerService

#pragma mark - Life Cycle
+ (instancetype)sharedInstance {
    static TTPopupManagerService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = [NSMutableArray array];
    }
    return self;
}

#pragma mark - TTPopupManagerServiceProtocol
- (void)addPopupService:(id<TTPopupServiceProtocol>)service {
    
    if (![service conformsToProtocol:@protocol(TTPopupServiceProtocol)]) {
        return;
    }
    
    if ([_queue containsObject:service]) {
        return;
    }
    
    NSInteger insertPosition = [self insertPositionForPopupService:service];
    if (insertPosition == NSNotFound) {
        return;
    }
    
    [_queue insertObject:service atIndex:insertPosition];
    
    //当前没有弹窗显示且队列只有一个元素时，显示弹窗
    if (_currentPopupService == nil && _queue.count == 1) {
        [self showPopup];
    }
}

- (void)removePopupService {
    
    //防止当弹窗还未显示完成，在显示过程中频繁调用 dismiss
    //使得 _currentPopupService 被清空，导致弹窗无法消失，从而假死现象
    if (!self.isShowingPopup) {
        return;
    }
    
    if (_currentPopupService == nil) {
        return;
    }
    
    if (_queue.count > 0) {
        [_queue removeObjectAtIndex:0];
    }
    
    [FFPopup dismissPopupForView:_currentPopupService.contentView animated:YES];
    _currentPopupService = nil;
}

/**
 点击蒙层时移除队列中的数据源
 
 @discussion 注意无需调用 dismissPopupForView
 */
- (void)removeSourceWhenTouchMaskView {
    if (_currentPopupService == nil) {
        return;
    }
    
    if (_queue.count > 0) {
        [_queue removeObjectAtIndex:0];
    }
    
    _currentPopupService = nil;
}

#pragma mark - Private Methods
/**
 显示弹窗
 */
- (void)showPopup {
    if (self.isShowingPopup) {
        return;
    }
    
    if (_currentPopupService) {
        return;
    }
    
    if (_queue.count == 0) {
        return;
    }
    
    id<TTPopupServiceProtocol> popupService = _queue.firstObject;
    if (![popupService conformsToProtocol:@protocol(TTPopupServiceProtocol)]) {
        return;
    }
    
    _currentPopupService = popupService;
    
    FFPopupHorizontalLayout horizontalLayout = FFPopupHorizontalLayout_Center;
    FFPopupVerticalLayout verticalLayout = FFPopupVerticalLayout_Center;
    FFPopupShowType showType = (FFPopupShowType)popupService.showType;
    FFPopupDismissType dismissType = FFPopupDismissType_GrowOut;
    
    if (popupService.style == TTPopupStyleActionSheet) {
        verticalLayout = FFPopupVerticalLayout_Bottom;
        showType = FFPopupShowType_SlideInFromBottom;
        dismissType = FFPopupDismissType_SlideOutToBottom;
    }
    
    FFPopup *popup = [FFPopup popupWithContentView:popupService.contentView];
    popup.showType = showType;
    popup.dismissType = dismissType;
    popup.maskType = FFPopupMaskType_Dimmed;
    popup.dimmedMaskAlpha = popupService.maskBackgroundAlpha;
    popup.shouldDismissOnBackgroundTouch = popupService.shouldDismissOnBackgroundTouch;
    
    [popup showWithLayout:FFPopupLayoutMake(horizontalLayout, verticalLayout) duration:0.0];
    
    __weak typeof(self) weakSelf = self;
    
    // 不管是调用’dismissPopupForView:animated:‘ 还是‘点击蒙层消除’，最终都会走到这里
    // 适合在此展示队列中下一个弹窗
    // 通过 _currentPopupService 是否为空可以判断是哪种消除方式
    popup.didFinishDismissingBlock = ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        BOOL isDismissOnBackgroundTouch = strongSelf.currentPopupService != nil;
        
        if (isDismissOnBackgroundTouch) {
            // ‘点击蒙层消除’时，在展现下一个弹窗前移除数据源
            [self removeSourceWhenTouchMaskView];
        }
        
        if (popupService.didFinishDismissHandler) {
            popupService.didFinishDismissHandler(isDismissOnBackgroundTouch);
        }
        
        // 弹窗消除结束，更新状态
        strongSelf.showingPopup = NO;
        
        // 显示下一个弹窗
        [strongSelf showPopup];
    };
    
    popup.didFinishShowingBlock = ^{
        
        // 开始弹窗，更新状态
        self.showingPopup = YES;
        
        if (popupService.didFinishShowingHandler) {
            popupService.didFinishShowingHandler();
        }
    };
}

/**
 弹窗将要插入队列的位置

 @param service 弹窗服务实例
 @return 队列的位置
 */
- (NSInteger)insertPositionForPopupService:(id<TTPopupServiceProtocol>)service {
    
    __block NSInteger result = NSNotFound;
    
    if (service == nil) {
        return result;
    }
    
    if (_queue.count == 0) {
        return 0;
    }

    // 设置重复弹窗过滤
    if (service.shouldFilterPopup && service.filterIdentifier.length > 0) {
        
        BOOL filterFlag = NO;
        for (id<TTPopupServiceProtocol> serv in _queue) {
            if ([serv.filterIdentifier isEqualToString:service.filterIdentifier]) {
                filterFlag = YES;
                break;
            }
        }
        
        if (filterFlag) {
            return result;
        }
    }
    
    [_queue enumerateObjectsUsingBlock:^(id<TTPopupServiceProtocol> _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 找到队中比当前弹窗优先级低的位置
        if (service.priority > model.priority) {
            result = idx;
            *stop = YES;
        }
    }];
    
    // 如果没有合适的位置，则将新的弹窗放在队尾
    result = MIN(result, _queue.count);
    return result;
}

@end
