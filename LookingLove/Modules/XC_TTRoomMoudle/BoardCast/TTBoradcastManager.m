//
//  TTBoradcastManager.m
//  TuTu
//
//  Created by KevinWang on 2018/11/21.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTBoradcastManager.h"
#import "XCMacros.h"
#import "UIColor+UIColor_Hex.h"

#define kPadding  15
#define kBoradViewHeight  30

@interface TTBoradcastManager()<CAAnimationDelegate>

@property (nonatomic, strong) UIWindow *boradCastWindow;
@property (nonatomic, strong) BoradCastView *boradCastView;
@property (nonatomic, strong) NSOperationQueue *animationQueue;

@end

@implementation TTBoradcastManager

static TTBoradcastManager *_instance;

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+(instancetype)shareManager{
    
    return [[self alloc]init];
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

#pragma mark - puble method
- (void)showBoradCast:(NSMutableAttributedString *)content{
    [self showBoradCast:content width:KScreenWidth-30];
}

- (void)showBoradCast:(NSMutableAttributedString *)content width:(CGFloat)width{
    
    self.boradCastView = [[BoradCastView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, width+2*kPadding, kBoradViewHeight )];
    //由于 popup 显示冲突，自定义 window level 不能是 UIWindowLevelNormal
    self.boradCastWindow.windowLevel = UIWindowLevelNormal + 1;
    AnimOperation *op = [AnimOperation animOperationWithBoradCastView:self.boradCastView finishedBlock:^(BOOL result) {
        [self close];
    }];
    [self.animationQueue addOperation:op];
    [self.boradCastView boradCastContent:content];
    [self.boradCastWindow addSubview:self.boradCastView];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.boradCastWindow makeKeyAndVisible];
    [keyWindow makeKeyWindow];
    
}

#pragma mark - private method
- (void)close {
    [self.boradCastWindow resignKeyWindow];
    if (self.animationQueue.operations.count == 0) {
        //由于 popup 显示冲突，自定义 window level 不能是 UIWindowLevelNormal
        self.boradCastWindow.windowLevel = UIWindowLevelNormal - 1;
    }
}

#pragma mark - Getter & Setter
- (UIWindow *)boradCastWindow {
    if (!_boradCastWindow) {
        _boradCastWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 44+statusbarHeight, KScreenWidth, kBoradViewHeight)];
        _boradCastWindow.windowLevel = UIWindowLevelNormal;
        _boradCastWindow.backgroundColor = [UIColor clearColor];
        _boradCastWindow.rootViewController = [[UIViewController alloc] init];
    }
    return _boradCastWindow;
}


- (NSOperationQueue *)animationQueue{
    if (!_animationQueue) {
        _animationQueue = [[NSOperationQueue alloc] init];
        _animationQueue.maxConcurrentOperationCount = 1;
    }
    return _animationQueue;
}

@end




@interface BoradCastView ()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *broadcastImg;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation BoradCastView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.broadcastImg];
    [self addSubview:self.contentLabel];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([anim isEqual:[self.layer animationForKey:@"BoradCastViewAnimation"]]){
        if (self.block) {
            self.block(YES);
        }
        @autoreleasepool {
            [self removeFromSuperview];
            
        }
    }
}



#pragma mark - puble method
- (void)animateWithCompleteBlock:(completeBlock)completed{
    self.block = completed;
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.delegate = self;
    animation1.duration = self.bounds.size.width/40;
    animation1.keyPath = @"position.x";
    animation1.values = @[@(KScreenWidth+self.bounds.size.width/2),@(- self.bounds.size.width/2)];
    animation1.repeatCount = 1;
    animation1.removedOnCompletion = YES;
    [self performSelector:@selector(animationDidStop) withObject:nil afterDelay:self.bounds.size.width/40];
    [self.layer addAnimation:animation1 forKey:@"BoradCastViewAnimation"];
    [animation1 setValue:@"animation1" forKey:@"AnimationKey"];
}


- (void)boradCastContent:(NSMutableAttributedString *)content{
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc] init];
    
    NSDictionary *boradDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                               NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#000000"]};
    NSAttributedString *boradString = [[NSAttributedString alloc] initWithString:@"全服通知:" attributes:boradDic];
    [attributStr appendAttributedString:boradString];
    [attributStr appendAttributedString:content];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(4, attributStr.length-4)];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributStr.length)];
    self.contentLabel.attributedText = attributStr;
}

#pragma mark - private method
- (UIImage *)resizeWithImage:(UIImage *)image{
    
    CGFloat top = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat right = image.size.width * 0.5;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImageResizingMode mode = UIImageResizingModeStretch;
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    return  newImage;
}

- (void)animationDidStop{
    if (self.block) {
        self.block(YES);
    }
    @autoreleasepool {
        [self removeFromSuperview];
    }
    
}

#pragma mark - Getter & Setter

- (UIImageView *)broadcastImg{
    if (!_broadcastImg) {
        _broadcastImg = [[UIImageView alloc] initWithFrame:self.bounds];
        _broadcastImg.image = [self resizeWithImage:[UIImage imageNamed:@"boradCast_bg"]];
    }
    return _broadcastImg;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 0, self.bounds.size.width-2*kPadding, kBoradViewHeight)];
        _contentLabel.numberOfLines = 1;
    }
    return _contentLabel;
}

@end



@interface AnimOperation()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result);

@end

@implementation AnimOperation

@synthesize finished = _finished;
@synthesize executing = _executing;


+ (instancetype)animOperationWithBoradCastView:(BoradCastView *)boradCastView finishedBlock:(void (^)(BOOL))finishedBlock{
    AnimOperation *op = [[AnimOperation alloc] init];
    op.boradCastView = boradCastView;
    op.finishedBlock = finishedBlock;
    return op;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
        
        
    }
    return self;
}

- (void)start {
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [self.boradCastView animateWithCompleteBlock:^(BOOL finished) {
            self.finished = finished;
            self.finishedBlock(finished);
        }];
        
    }];
    
}

#pragma mark - KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}


@end
