//
//  YYImageToastView.m
//  YYMobile
//
//  Created by JianchengShi on 14-9-22.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "YYImageToastView.h"

@interface YYImageToastView()

@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) UIImage* image;

@end

@implementation YYImageToastView

+ (instancetype)ImageToastViewWithMessage:(NSString *)message Image:(UIImage*)image
{
    
    YYImageToastView *view = [[YYImageToastView alloc] initWithMessage:message image:image];
    
    return view;
}

- (instancetype) initWithMessage:(NSString*)message image:(UIImage*)image
{
    self = [super init];
    
    if (self) {
        
        self.message = message;
        self.image = image;
        
        [self _buildImageToast];
        
    }
    
    return self;
}

- (void) _buildImageToast
{
    CGFloat leftEdge = 10;
    CGFloat topEdge = 10;
    CGFloat msgEdgeWithImage = 10;
    
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = 6;
    
    wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
    wrapperView.layer.shadowOpacity = 0.8f;
    wrapperView.layer.shadowRadius = 6.0f;
    wrapperView.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:self.image];
    [wrapperView addSubview:imageView];
    CGFloat imageViewWidth = self.image.size.width;
    CGFloat imageViewHeight = self.image.size.height;

    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * boundsConstraintW = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:imageViewWidth];
    NSLayoutConstraint * boundsConstraintH = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:imageViewHeight];
    [imageView addConstraint:boundsConstraintW];
    [imageView addConstraint:boundsConstraintH];
    
    NSLayoutConstraint * imageCenterConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:wrapperView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * imageTopConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:wrapperView attribute:NSLayoutAttributeTop multiplier:1 constant:topEdge];
    [wrapperView addConstraint:imageCenterConstraint];
    [wrapperView addConstraint:imageTopConstraint];
    
    
    UILabel *messageLabel = nil;
    messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.alpha = 1.0;
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [messageLabel setText:self.message];
    [wrapperView addSubview:messageLabel];
    NSLayoutConstraint * labelCenterConstraint = [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:wrapperView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * msgTopConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:messageLabel attribute:NSLayoutAttributeTop multiplier:1 constant:-msgEdgeWithImage];
    [wrapperView addConstraint:labelCenterConstraint];
    [wrapperView addConstraint:msgTopConstraint];
    
    CGSize maxSizeMessage = CGSizeMake(300,
                                       100);
    
    NSDictionary *attribute = @{NSFontAttributeName: messageLabel.font};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize expectedSizeMessage = [self.message boundingRectWithSize:maxSizeMessage
                                                                           options:options
                                                                        attributes:attribute
                                                                           context:nil].size;
    
    CGFloat wrapperWidth = MAX(imageViewWidth, expectedSizeMessage.width) + 2 * leftEdge;
    CGFloat wrapperHeight = imageViewHeight+expectedSizeMessage.height + 2 * topEdge + msgEdgeWithImage;
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = wrapperView.frame;
    wrapperView.frame = self.bounds;
    
    [self addSubview:wrapperView];

}

@end
