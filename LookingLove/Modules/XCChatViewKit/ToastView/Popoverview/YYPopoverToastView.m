//
//  YYPopoverToastView.m
//  YYMobile
//
//  Created by 武帮民 on 14-8-4.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "YYPopoverToastView.h"
#import "UIView+NTES.h"
#import "XCTheme.h"
const static NSInteger kPopoverViewTag = 12345678;

@interface YYPopoverToastView ()

@property (nonatomic, strong) NSDictionary *userInfo;
@property (copy)void(^onCompelt)(NSDictionary *info);

@end

@implementation YYPopoverToastView

+ (void)YYPopoverToastViewHide {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak UIView *tempView = [window viewWithTag:kPopoverViewTag];
    if (tempView) {
        [tempView removeFromSuperview];
    }
}

- (instancetype)initWithLiveNoticeInfo:(NSDictionary *)dic
                                       inView:(UIView *)inView
                                    arrowSide:(YYPopoverSide)side {
    
    self = [super init];
    if (self) {
        
        self.userInfo = dic;
        
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempBtn addTarget:self action:@selector(touchUpViews) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.frame = self.bounds;
        [self addSubview:tempBtn];
        
    }
    
    return self;
}

- (UIView *)popoverViewWithMessage:(NSString *)message
                         mutiColorText:(NSString *)text
                               icoImag:(NSString *)imageUrl
                             arrowSide:(YYPopoverSide)side
                                inView:(UIView *)inView {
    
    // fixed text
    if (text.length > 7) {
        NSRange rannge = [message rangeOfString:text];
        
        NSString *lastText = [message substringFromIndex:rannge.location + rannge.length];
        
        text = [NSString stringWithFormat:@"%@...", [text substringToIndex:7]];
        
        message = [NSString stringWithFormat:@"%@ %@", text, lastText];
        
    }
    
    UIView *wrapperView = [[UIView alloc] init];
    
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = 4;
    wrapperView.layer.borderWidth = 0.5;
    wrapperView.clipsToBounds = YES;
    
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85f];
    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_channel_logo"]];
//    imageView.layer.cornerRadius = 6;
    
    UILabel *messageLabel = nil;
    messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = 1;
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.alpha = 1.0;
    [messageLabel setText:message];
    
    // 多颜色
    UIColor *color = RGBCOLOR(255, 172, 50);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
    [string addAttribute:NSForegroundColorAttributeName value:color range:[message rangeOfString:text]];
    [messageLabel setAttributedText:string];
    
    // size the message label according to the length of the text
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rc = [window convertRect:inView.frame fromView:inView.superview];
    
//    CGFloat width = rc.origin.x - 20;
    
    CGSize maxSizeMessage = CGSizeMake(0, 30);
    
    NSDictionary *attribute = @{NSFontAttributeName: messageLabel.font};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize expectedSizeMessage = [message boundingRectWithSize:maxSizeMessage
                                                       options:options
                                                    attributes:attribute
                                                       context:nil].size;
    
    messageLabel.frame = CGRectMake(30.0, 0.0,
                                    expectedSizeMessage.width, expectedSizeMessage.height);
    
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = expectedSizeMessage.width;
        messageHeight = maxSizeMessage.height;
        messageLeft = 10;
        messageTop = 0;
    }
    messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
    [wrapperView addSubview:messageLabel];
    
    CGFloat wrapperWidth = messageLeft + messageWidth + 10;
    CGFloat wrapperHeight = messageTop + messageHeight + 10;
    
//    imageView.frame = CGRectMake(0, 0, 30, 30);
//    [wrapperView addSubview:imageView];
    
    wrapperView.frame = CGRectMake(0.0, 5.0, wrapperWidth, 30);
    
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, wrapperWidth, wrapperHeight);
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_notice_tips"]];
    
    
    CGRect toastRect = view.frame;
    
    
    switch (side) {
        case YYPopoverSideUp:
            
            toastRect.origin.y = inView.frame.origin.y - wrapperHeight;
            toastRect.origin.x = rc.origin.x - wrapperWidth + rc.size.width;
            
            image.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
            image.frame = CGRectMake(wrapperWidth-image.image.size.width-10, wrapperHeight+5, 10, 5);
            
            break;
            
        case YYPopoverSideDown:
            
            toastRect.origin.y = inView.frame.origin.y + inView.height + 15;
            toastRect.origin.x = rc.origin.x - wrapperWidth + rc.size.width;
            
            image.frame = CGRectMake(wrapperWidth-image.image.size.width-10, 0, 10, 5);
            break;
            
        case YYPopoverSideLeft:
            
            toastRect.origin.y = rc.origin.y + 5;
            toastRect.origin.x = rc.origin.x - wrapperWidth + 10;
            
            image.transform = CGAffineTransformMakeRotation(90 *M_PI / 180.0);
            image.frame = CGRectMake(wrapperWidth, 10, 5, 10);
            
            break;
            
        case YYPopoverSideRight:
            
            toastRect.origin.y = rc.origin.y + 5;
            toastRect.origin.x = rc.origin.x + rc.size.width;
            
            image.transform = CGAffineTransformMakeRotation(-90 *M_PI / 180.0);
            image.frame = CGRectMake(-5, 10, 5, 10);
            
            break;
            
        default:
            break;
    }
    
    view.frame = toastRect;
    
    [view addSubview:image];
    [view addSubview:wrapperView];
    
    self.frame = view.frame;
    view.frame = self.bounds;
    
    [self addSubview:view];
    
    return view;
}

- (void)touchUpViews {
    
    if (self.onCompelt) {
        self.onCompelt(self.userInfo);
        
        self.onCompelt = nil;
    }
    
}

- (void)showPopoverViewWithTouchAction:(void (^)(NSDictionary *))completion {
    
    [self hidePopoverView];
    
    self.tag = kPopoverViewTag;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.onCompelt = completion;
    
    [window addSubview:self];
    
    __weak __typeof__(self) weakToast = self;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakToast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         
                         [weakToast performSelector:@selector(hidePopoverView) withObject:nil afterDelay:4];
                     }];
    
}

- (void)hidePopoverView {
    
    [YYPopoverToastView YYPopoverToastViewHide];
}


@end
