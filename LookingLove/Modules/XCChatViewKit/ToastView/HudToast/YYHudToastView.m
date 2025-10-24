//
//  YYHudToastView.m
//  YYMobile
//
//  Created by 武帮民 on 14-8-12.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "YYHudToastView.h"

@interface YYHudToastView ()

@property (nonatomic, strong) NSAttributedString *labelAttributed;
@property (nonatomic, assign) CGRect lastViewRect;

@property (nonatomic, strong) UIView *wrapperView;

- (id)initWithAttributedMessage:(NSAttributedString *)message inRect:(CGRect)lastViewRect;

@end

@implementation YYHudToastView

+ (instancetype)HudToastViewWithAttributedMessage:(NSAttributedString *)attributed
                                           inRect:(CGRect)lastViewRect {
    
    YYHudToastView *view = [[YYHudToastView alloc] initWithAttributedMessage:attributed inRect:lastViewRect];
    
    return view;
}

- (void)dealloc {
    
}

- (id)initWithAttributedMessage:(NSAttributedString *)message inRect:(CGRect)lastViewRect {
    
    self = [super init];
    
    if (self) {
        
        self.labelAttributed = message;
        self.lastViewRect = lastViewRect;
        
        [self buildHudToast];
        
    }
    
    return self;
}

- (void)buildHudToast {
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = 6;
    
    wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
    wrapperView.layer.shadowOpacity = 0.8f;
    wrapperView.layer.shadowRadius = 6.0f;
    wrapperView.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    
    UILabel *messageLabel = nil;
    messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.alpha = 1.0;
    
    [messageLabel setAttributedText:self.labelAttributed];
    
    
    CGSize maxSizeMessage = CGSizeMake((self.lastViewRect.size.width * 0.8),
                                       self.lastViewRect.size.height * 0.8);
    
    NSDictionary *attribute = @{NSFontAttributeName: messageLabel.font};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize expectedSizeMessage = [self.labelAttributed.string boundingRectWithSize:maxSizeMessage
                                                                           options:options
                                                                        attributes:attribute
                                                                           context:nil].size;
    
    messageLabel.frame = CGRectMake(0.0, 0.0,
                                    expectedSizeMessage.width, expectedSizeMessage.height);
    
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = 10;
        messageTop = 10;
    }
    messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
    [wrapperView addSubview:messageLabel];
    
    CGFloat wrapperWidth = messageLeft + messageWidth + 10;
    CGFloat wrapperHeight = messageTop + messageHeight + 10;
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = wrapperView.frame;
    wrapperView.frame = self.bounds;
    
    [self addSubview:wrapperView];
    self.wrapperView = wrapperView;
    
}


- (void)toastBackgroudColor:(UIColor *)color {
    self.wrapperView.backgroundColor = [color colorWithAlphaComponent:0.7];
}

@end
