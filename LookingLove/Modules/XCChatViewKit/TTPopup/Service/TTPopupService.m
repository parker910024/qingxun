//
//  TTPopupService.m
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPopupService.h"

@implementation TTPopupService

@synthesize style = _style;
@synthesize priority = _priority;
@synthesize contentView = _contentView;
@synthesize maskBackgroundAlpha = _maskBackgroundAlpha;
@synthesize shouldDismissOnBackgroundTouch = _shouldDismissOnBackgroundTouch;
@synthesize didFinishDismissHandler = _didFinishDismissHandler;
@synthesize didFinishShowingHandler = _didFinishShowingHandler;
@synthesize shouldFilterPopup = _shouldFilterPopup;
@synthesize filterIdentifier = _filterIdentifier;
@synthesize showType = _showType;
- (instancetype)init {
    self = [super init];
    if (self) {
        
        _style = TTPopupStyleAlert;
        _priority = TTPopupPriorityNormal;
        _maskBackgroundAlpha = 0.3;
        _shouldDismissOnBackgroundTouch = YES;
        _shouldFilterPopup = NO;
        _showType = TTPopupShowTypeDefault;
    }
    return self;
}

@end
