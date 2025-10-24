//
//  TTChannalGiftManager.m
//  TuTu
//
//  Created by KevinWang on 2018/11/21.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTChannalGiftManager.h"

//t
#import "TTRoomModuleCenter.h"
#import "NSString+Utils.h"
#import "XCHUDTool.h"
#import "UIImageView+QiNiu.h"
#import "UIView+ALEffects.h"
#import "XCMacros.h"
#import "XCTheme.h"
#import <POP.h>
#import <Masonry.h>
#import "XCMediator+TTMessageMoudleBridge.h"
#import <YYText/YYText.h>
#import "UIColor+UIColor_Hex.h"
#import "WBRollView.h"
#import "SVGA.h"
#import "SVGAParserManager.h"

//core
#import "GameCore.h"
#import "UserCore.h"
#import "ImRoomCoreV2.h"
#import "ImPublicChatroomCore.h"
#import "XCCurrentVCStackManager.h"
#import "TTPopup.h"

#import "WBNamePlateChanelNotifyInfo.h"

@interface TTChannalGiftManager()

@property (nonatomic, strong) UIWindow *giftBoradCastWindow;
@property (nonatomic, strong) GiftBoradCastView *giftBoradCastView;
@property (nonatomic, strong) GiftBoradAdminCastView *giftBoradAdminView;
@property (nonatomic, strong) NSOperationQueue *giftAnimationQueue;

@end

@implementation TTChannalGiftManager

static TTChannalGiftManager *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)shareManager {
    return [[self alloc] init];
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark - puble method
- (void)showGiftBoradCast:(GiftChannelNotifyInfo *)giftNotifyInfo{
    if (GetCore(GameCore).isPlayingGame || !GetCore(UserCore).haddRepairUserInfo) {
        return;
    }
    [[BaiduMobStat defaultStat]logEvent:@"full_gift" eventLabel:@"全服礼物"];
    BOOL isAdmin = giftNotifyInfo.roomUid == GetCore(ImRoomCoreV2).currentRoomInfo.uid;
    if (isAdmin) {
        switch (giftNotifyInfo.levelNum) {
            case GiftChannelNotifyType_Normal:
            case GiftChannelNotifyType_Middle:
            case GiftChannelNotifyType_Full:
                self.giftBoradAdminView = [[GiftBoradAdminCastView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, 100) andDisplayType:giftNotifyInfo.levelNum];
                self.giftBoradCastWindow.frame = CGRectMake(0, 15 + statusbarHeight, KScreenWidth, 100);
                break;
                
            default:
                return;
                break;
        }
    } else {
        if (giftNotifyInfo.levelNum == GiftChannelNotifyType_Full) {
            self.giftBoradCastView = [[GiftBoradCastView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, 200) andDisplayType:giftNotifyInfo.levelNum];
            self.giftBoradCastWindow.frame = CGRectMake(0, 35 + statusbarHeight, KScreenWidth, 200);
        } else if (giftNotifyInfo.levelNum == GiftChannelNotifyType_Normal){
            self.giftBoradCastWindow.frame = CGRectMake(0, 35 + statusbarHeight, KScreenWidth, 150);
            self.giftBoradCastView = [[GiftBoradCastView alloc] initWithFrame:CGRectMake(KScreenWidth, 6, KScreenWidth, 150) andDisplayType:giftNotifyInfo.levelNum];
            
        }else if (giftNotifyInfo.levelNum == GiftChannelNotifyType_Middle) {
            self.giftBoradCastWindow.frame = CGRectMake(0, 35 + statusbarHeight, KScreenWidth, 200);
            self.giftBoradCastView = [[GiftBoradCastView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, 200) andDisplayType:giftNotifyInfo.levelNum];
            
            
        }else {
            return;
        }
    }
    self.giftBoradCastWindow.userInteractionEnabled = YES;
    //由于 popup 显示冲突，自定义 window level 不能是 UIWindowLevelNormal
    self.giftBoradCastWindow.windowLevel = UIWindowLevelNormal + 1;
    
    if (isAdmin) {
        GiftAnimOperation *op = [GiftAnimOperation animOperationWithGiftBoradAdminView:self.giftBoradAdminView isAdmin:YES finishedBlock:^(BOOL result) {
            [self close];
        }];
        [self.giftAnimationQueue addOperation:op];
        [self.giftBoradAdminView boradCastByGiftNotifyInfo:giftNotifyInfo];
        [self.giftBoradCastWindow addSubview:self.giftBoradAdminView];
    } else {
        GiftAnimOperation *op = [GiftAnimOperation animOperationWithGiftBoradCastView:self.giftBoradCastView finishedBlock:^(BOOL result) {
            [self close];
        }];
        [self.giftAnimationQueue addOperation:op];
        [self.giftBoradCastView boradCastByGiftNotifyInfo:giftNotifyInfo];
        [self.giftBoradCastWindow addSubview:self.giftBoradCastView];
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.giftBoradCastWindow makeKeyAndVisible];
    [keyWindow makeKeyWindow];
    
}

- (void)showNamePlate:(NSArray *)array  {
    self.giftBoradCastView = [[GiftBoradCastView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, 220) andDisplayType:GiftChannelNotifyType_NamePlate];
    self.giftBoradCastWindow.frame = CGRectMake(0, 87 + statusbarHeight, KScreenWidth, 220);
   
    //由于 popup 显示冲突，自定义 window level 不能是 UIWindowLevelNormal
    self.giftBoradCastWindow.windowLevel = UIWindowLevelNormal + 1;
    
    GiftAnimOperation *op = [GiftAnimOperation animOperationWithGiftBoradCastView:self.giftBoradCastView finishedBlock:^(BOOL result) {
        [self close];
    }];
    [self.giftAnimationQueue addOperation:op];
    
    [self.giftBoradCastView boradCastByNamePlate:array];
    [self.giftBoradCastWindow addSubview:self.giftBoradCastView];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.giftBoradCastWindow makeKeyAndVisible];
    [keyWindow makeKeyWindow];
}

//全服年度通知
- (void)showAnnualBroadcast:(AnnualBroadcastNotifyInfo *)info jumpHandler:(void(^)(void))jumpHandler {
    
    if (!info) {
        return;
    }
    
    self.giftBoradCastView = [[GiftBoradCastView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, 78) andDisplayType:GiftChannelNotifyType_Annual];
    [self.giftBoradCastView broadcastByAnnualInfo:info];
    @weakify(self)
    self.giftBoradCastView.userInteractionHandler = ^{
        @strongify(self)
        self.giftBoradCastWindow.hidden = YES;
        [self close];
        
        !jumpHandler ?: jumpHandler();
    };
    
    self.giftBoradCastWindow.frame = CGRectMake(0, 20 + statusbarHeight, KScreenWidth, 78);
    //由于 popup 显示冲突，自定义 window level 不能是 UIWindowLevelNormal
    self.giftBoradCastWindow.windowLevel = UIWindowLevelNormal + 1;
    [self.giftBoradCastWindow addSubview:self.giftBoradCastView];

    GiftAnimOperation *op = [GiftAnimOperation animOperationWithGiftBoradCastView:self.giftBoradCastView finishedBlock:^(BOOL result) {
        @strongify(self)
        [self close];
    }];
    [self.giftAnimationQueue addOperation:op];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.giftBoradCastWindow makeKeyAndVisible];
    [keyWindow makeKeyWindow];
}

#pragma mark - private method
- (void)close {
    [self.giftBoradCastWindow resignKeyWindow];
    if (self.giftAnimationQueue.operations.count == 0) {
        //由于 popup 显示冲突，自定义 window level 不能是 UIWindowLevelNormal
        self.giftBoradCastWindow.windowLevel = UIWindowLevelNormal - 1;
    }
}

#pragma mark - Getter & Setter
- (UIWindow *)giftBoradCastWindow {
    if (!_giftBoradCastWindow) {
        _giftBoradCastWindow = [[UIWindow alloc] init];
        _giftBoradCastWindow.windowLevel = UIWindowLevelNormal;
        _giftBoradCastWindow.backgroundColor = [UIColor clearColor];
    }
    return _giftBoradCastWindow;
}

- (NSOperationQueue *)giftAnimationQueue {
    if (!_giftAnimationQueue) {
        _giftAnimationQueue = [[NSOperationQueue alloc] init];
        _giftAnimationQueue.maxConcurrentOperationCount = 1;
    }
    return _giftAnimationQueue;
}

@end


@interface GiftBoradCastView ()

/** 礼物通知背景 */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 发送者头像 */
@property (nonatomic, strong) UIImageView *sendIconImg;
/** 发送者头像光圈 */
@property (nonatomic,strong) UIImageView *sendIconBorderImg;
/** 发送者名字 */
@property (nonatomic, strong) UILabel *sendNameLabel;
/** “赠送”两个字的图片 */
@property (nonatomic, strong) UIImageView *tipImage;
/** 接受者头像 */
@property (nonatomic, strong) UIImageView *receiveIconImg;
/** 接受者头像光圈 */
@property (nonatomic,strong) UIImageView *receiveIconBorderImg;
/** 接受者名字 */
@property (nonatomic, strong) UILabel *receiveNameLabel;
/** 礼物图片 */
@property (nonatomic, strong) UIImageView *giftImageView;
/** 礼物数量label */
@property (nonatomic, strong) UILabel *numLabel;
/** 前往围观label */
@property (nonatomic,strong) UILabel *goLabel; // ????
/** 前往围观 */
@property (nonatomic,strong) UIImageView *goImageView;
/** 弹幕背景 */
@property (nonatomic,strong) UIImageView *speakerBg;
/** 弹幕label */
@property (nonatomic,strong) UILabel *speakerLabel;
/** 礼物通知实体 */
@property (nonatomic, strong) GiftChannelNotifyInfo *giftNotifyInfo;
/** 关闭按钮 */
@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic,assign) BOOL hadOpenRoom;
/** 铭牌label */
@property (nonatomic, strong) WBRollView *namePlateLabel;

@property (nonatomic, strong) SVGAImageView *svgImageView;
@property (nonatomic, strong) SVGAParserManager *svgManager;

@end

@implementation GiftBoradCastView


- (instancetype)initWithFrame:(CGRect)frame andDisplayType:(GiftChannelNotifyType)displayType {
    if (self = [super initWithFrame:frame]) {
        
        [self setupWithType:displayType];
        [self setupConstraintWithType:displayType];
        if (displayType == GiftChannelNotifyType_NamePlate ||
            displayType == GiftChannelNotifyType_Annual) {
            self.giftNotifyInfo = [GiftChannelNotifyInfo new];
            self.giftNotifyInfo.levelNum = displayType;
        }
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)didTapView {
    !self.userInteractionHandler ?: self.userInteractionHandler();
}

#pragma mark - puble method
- (void)giftViewAnimateWithCompleteBlock:(completeBlock)completed{
    [self layoutIfNeeded];
    if (self.giftNotifyInfo.levelNum == GiftChannelNotifyType_Full) {
        self.block = completed;
        CGFloat startTime = self.giftNotifyInfo.notifyStaySecond > 0 ? self.giftNotifyInfo.notifyStaySecond : 3.0;
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnimation.springSpeed = 12;
        springAnimation.springBounciness = 10.f;
        springAnimation.fromValue = [NSValue valueWithCGPoint:self.center];
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 + self.frame.size.width / 2, self.center.y)];
        @weakify(self);
        if (self.giftNotifyInfo.msg.length > 0) {
            [springAnimation setAnimationDidStartBlock:^(POPAnimation *anim) {
                @strongify(self);
                self.speakerBg.hidden = NO;
                self.speakerLabel.hidden = NO;
                POPBasicAnimation *moveAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
                moveAnimation.duration = startTime + 1;
                moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                moveAnimation.fromValue = [NSValue valueWithCGPoint:self.speakerBg.center];
                moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 - self.speakerBg.frame.size.width, self.speakerBg.center.y)];
                [moveAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    [self.speakerBg removeFromSuperview];
                    self.speakerBg = nil;
                }];
                [self.speakerBg pop_addAnimation:moveAnimation forKey:@"moveAnimation"];
            }];
        }
        [springAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self moveOutAnimation:self stayTime:startTime];
            }
        }];
        [self pop_addAnimation:springAnimation forKey:@"spingOutAnimation"];
    }else if(self.giftNotifyInfo.levelNum == GiftChannelNotifyType_Normal) {
        self.block = completed;
        CGFloat startTime = self.giftNotifyInfo.notifyStaySecond > 0 ? self.giftNotifyInfo.notifyStaySecond : 3.0;
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnimation.springSpeed = 12;
        springAnimation.springBounciness = 10.f;
        springAnimation.fromValue = [NSValue valueWithCGPoint:self.center];
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 + self.frame.size.width / 2, self.center.y)];
        [springAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self moveOutAnimation:self stayTime:startTime];
            }
        }];
        [self pop_addAnimation:springAnimation forKey:@"spingOutAnimation"];
    }else if (self.giftNotifyInfo.levelNum == GiftChannelNotifyType_Middle) {
        self.block = completed;
        CGFloat startTime = self.giftNotifyInfo.notifyStaySecond > 0 ? self.giftNotifyInfo.notifyStaySecond : 3.0;
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnimation.springSpeed = 12;
        springAnimation.springBounciness = 10.f;
        springAnimation.fromValue = [NSValue valueWithCGPoint:self.center];
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 + self.frame.size.width / 2, self.center.y)];
        @weakify(self);
        if (self.giftNotifyInfo.msg.length > 0) {
            [springAnimation setAnimationDidStartBlock:^(POPAnimation *anim) {
                @strongify(self);
                self.speakerBg.hidden = NO;
                self.speakerLabel.hidden = NO;
                POPBasicAnimation *moveAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
                moveAnimation.duration = startTime + 1;
                moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                moveAnimation.fromValue = [NSValue valueWithCGPoint:self.speakerBg.center];
                moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 - self.speakerBg.frame.size.width, self.speakerBg.center.y)];
                [moveAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    [self.speakerBg removeFromSuperview];
                    self.speakerBg = nil;
                }];
                [self.speakerBg pop_addAnimation:moveAnimation forKey:@"moveAnimation"];
            }];
        }
        [springAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self moveOutAnimation:self stayTime:startTime];
            }
        }];
        [self pop_addAnimation:springAnimation forKey:@"spingOutAnimation"];
    } else if (self.giftNotifyInfo.levelNum == GiftChannelNotifyType_NamePlate ||
               self.giftNotifyInfo.levelNum == GiftChannelNotifyType_Annual) {
        self.block = completed;
        CGFloat startTime = 3.0;
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnimation.springSpeed = 12;
        springAnimation.springBounciness = 10.f;
        springAnimation.fromValue = [NSValue valueWithCGPoint:self.center];
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 + self.frame.size.width / 2, self.center.y)];
        @weakify(self);
      
        [springAnimation setAnimationDidStartBlock:^(POPAnimation *anim) {
           @strongify(self);
           [self.namePlateLabel startAnimation];
        }];
        
        [springAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            @strongify(self);
            if (finished) {
                [self.namePlateLabel stopAnimation:startTime + 2];
                [self moveOutAnimation:self stayTime:startTime + 2];
            }
        }];
        
        [self pop_addAnimation:springAnimation forKey:@"spingOutAnimation"];
        
    }
}

- (void)boradCastByNamePlate:(NSArray *)array {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
   
    for (int i = 0; i < array.count; i++) {
        WBNamePlateChanelNotifyInfo *info = array[i];
        NSMutableAttributedString *subAttString = [[NSMutableAttributedString alloc] initWithString:info.text];

        subAttString.yy_color = [UIColor colorWithHexString:info.color];
        subAttString.yy_font = [UIFont systemFontOfSize:12];
        [attString appendAttributedString:subAttString];
    }
    
    self.namePlateLabel.repectAnimation = YES;
    [self.namePlateLabel layoutIfNeeded];
    self.namePlateLabel.marqueeLabel.textAlignment = NSTextAlignmentCenter;
    self.namePlateLabel.marqueeLabel.attributedText = attString;
}

//全服年度通知
- (void)broadcastByAnnualInfo:(AnnualBroadcastNotifyInfo *)info {
    NSAttributedString *str = [self annualAttributedStringWithLayout:info.layout];
   
    self.namePlateLabel.repectAnimation = NO;
    [self.namePlateLabel layoutIfNeeded];
    self.namePlateLabel.marqueeLabel.textAlignment = NSTextAlignmentLeft;
    self.namePlateLabel.marqueeLabel.attributedText = str;

    BOOL svga = info.svgaUrl.length > 0;
    self.svgImageView.hidden = !svga;
    
    if (svga) {
        [self loadSvgaAnimation:info.svgaUrl];
    } else {
        [self.bgImageView qn_setImageImageWithUrl:info.backPic placeholderImage:@"broadcast_bg_annual" type:ImageTypeUserLibaryDetail];
    }
}

- (void)boradCastByGiftNotifyInfo:(GiftChannelNotifyInfo *)giftNotifyInfo{
    _giftNotifyInfo = giftNotifyInfo;
    if (giftNotifyInfo.roomErbanNo > 0) {
        self.goLabel.text = [NSString stringWithFormat:@"ID:%d",giftNotifyInfo.roomErbanNo];
    } else {
        self.goLabel.hidden = YES;
        self.goImageView.hidden = YES;
    }
    
    if (giftNotifyInfo.roomUid == GetCore(RoomCoreV2).getCurrentRoomInfo.uid) {
        self.goLabel.hidden = YES;
        self.goImageView.hidden = YES;
    }
    
    [self.sendIconImg qn_setImageImageWithUrl:giftNotifyInfo.sendUserAvatar placeholderImage:@"" type:ImageTypeUserIcon];
    self.sendNameLabel.text = giftNotifyInfo.sendUserNick;
    [self.receiveIconImg qn_setImageImageWithUrl:giftNotifyInfo.recvUserAvatar placeholderImage:@"" type:ImageTypeUserIcon];
    self.receiveNameLabel.text = giftNotifyInfo.recvUserNick;
    [self.giftImageView qn_setImageImageWithUrl:giftNotifyInfo.giftUrl placeholderImage:@"" type:ImageTypeRoomGift];
    self.numLabel.text = [NSString stringWithFormat:@"x%d",giftNotifyInfo.giftNum];
    self.speakerLabel.text = giftNotifyInfo.msg;
    if (giftNotifyInfo.msg.length > 0) {
        CGSize textSize = [NSString sizeWithText:giftNotifyInfo.msg font:[UIFont systemFontOfSize:14.f] maxSize:CGSizeMake(KScreenWidth, 16)];
        [self.speakerBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textSize.width + 53);
        }];
    }
}

#pragma mark - private method
/// 全服年度公告富文本
- (NSAttributedString *)annualAttributedStringWithLayout:(MessageLayout *)layout {
    
    if (!layout || layout.contents.count == 0) {
        return nil;
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    
    for (LayoutParams *params in layout.contents) {
        NSMutableAttributedString *subAttr = [[NSMutableAttributedString alloc]initWithString:params.content];
        
        if (params.fontSize.length > 0) {
            [subAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[params.fontSize floatValue]] range:NSMakeRange(0, subAttr.length)];
        }
        
        if (params.fontColor.length > 0) {
            [subAttr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:params.fontColor] range:NSMakeRange(0, subAttr.length)];
        }
        
        [attr appendAttributedString:subAttr];
    }
    
    attr.yy_lineSpacing = 5;
    return attr;
}

- (void)moveOutAnimation:(GiftBoradCastView *)view stayTime:(CGFloat)stayTime{
    
    POPBasicAnimation *moveAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:view.center];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-KScreenWidth/2, view.center.y)];
    moveAnimation.beginTime = CACurrentMediaTime() + stayTime;
    moveAnimation.duration = 0.5;
    moveAnimation.repeatCount = 1;
    moveAnimation.removedOnCompletion = YES;
    @weakify(self);
    [moveAnimation setAnimationDidStartBlock:^(POPAnimation *anim) {
        @strongify(self);
        if (self.speakerBg) {
            [self.speakerBg removeFromSuperview];
            self.speakerBg = nil;
        }
        
    }];
    [moveAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self);
        if (finished) {
            if (self.block) {
                self.block(YES);
            }
            @autoreleasepool {
                [view removeFromSuperview];
                
            }
        }
    }];
    [view pop_addAnimation:moveAnimation forKey:@"moveOutAnimation"];
}

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

- (void)setupWithType:(GiftChannelNotifyType)displayType {
    [self setup];
    [self configSourceByDisplayType:displayType];
    switch (displayType) {
        case GiftChannelNotifyType_Normal: //第一级的全服通知
        {
            
        }
            break;
            
        case GiftChannelNotifyType_Middle: //第二级的全服通知
        {
            [self addSubview:self.goImageView];
            [self addSubview:self.goLabel];
            
            [self addSubview:self.speakerBg];
            [self.speakerBg addSubview:self.speakerLabel];
        }
            break;
            
        case GiftChannelNotifyType_Full: //第三级的全服通知
        {
            [self addSubview:self.goImageView];
            [self addSubview:self.goLabel];
            
            [self addSubview:self.speakerBg];
            [self.speakerBg addSubview:self.speakerLabel];
            
        }
            break;
        case GiftChannelNotifyType_NamePlate: //铭牌的全服通知
        {
            [self addSubview:self.namePlateLabel];
        }
            break;
        case GiftChannelNotifyType_Annual: //年度全服通知
        {
            [self addSubview:self.namePlateLabel];
        }
            break;
        default:
            break;
    }
}

- (void)setup {
    [self addSubview:self.bgImageView];
    [self addSubview:self.sendIconBorderImg];
    [self addSubview:self.receiveIconBorderImg];
    [self addSubview:self.sendIconImg];
    [self addSubview:self.receiveIconImg];
    [self addSubview:self.sendNameLabel];
    [self addSubview:self.tipImage];
    [self addSubview:self.receiveNameLabel];
    [self addSubview:self.giftImageView];
    [self addSubview:self.numLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.svgImageView];
}

- (void)configSourceByDisplayType:(GiftChannelNotifyType)displayType {
    GiftNotifyDisplayInfo *displayInfo = [GiftNotifySourceControl getSourceByType:displayType];
    
    self.bgImageView.image = displayInfo.notifyBg;
    self.sendIconBorderImg.image = displayInfo.headCycleBg;
    self.receiveIconBorderImg.image = displayInfo.headCycleBg;
    
    self.speakerBg.image = [self resizeWithImage:displayInfo.speakingBg];
    
    self.goImageView.image = displayInfo.goImageBg;
    
    self.tipImage.image = displayInfo.giveTypeBg;
    
    [self.closeButton setImage:displayInfo.closeBtnBg forState:UIControlStateNormal];
}

- (void)setupConstraintWithType:(GiftChannelNotifyType)disPlayType {
    switch (disPlayType) {
        case GiftChannelNotifyType_Normal:
        {
            [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(320);
                make.height.mas_equalTo(123);
            }];
            [self.sendIconBorderImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(45);
                make.leading.mas_equalTo(self.bgImageView.mas_leading).offset(37);
                make.top.mas_equalTo(self.bgImageView.mas_top).offset(42);
            }];
            [self.sendIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(32);
                make.center.mas_equalTo(self.sendIconBorderImg);
            }];
            [self.sendNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.sendIconBorderImg.mas_bottom);
                make.centerX.mas_equalTo(self.sendIconBorderImg.mas_centerX);
                make.width.mas_equalTo(50);
            }];
            [self.tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.sendIconImg.mas_centerY);
                make.width.mas_equalTo(32);
                make.height.mas_equalTo(23);
                make.leading.mas_equalTo(self.bgImageView).offset(79);
            }];
            [self.receiveIconBorderImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.top.mas_equalTo(self.sendIconBorderImg);
                make.leading.mas_equalTo(self.tipImage.mas_trailing);
            }];
            [self.receiveIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(self.sendIconImg);
                make.center.mas_equalTo(self.receiveIconBorderImg);
            }];
            [self.receiveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.receiveIconBorderImg.mas_centerX);
                make.width.top.mas_equalTo(self.sendNameLabel);
            }];
            
            [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bgImageView).offset(42);
                make.width.height.mas_equalTo(60);
                make.leading.mas_equalTo(self.bgImageView).offset(163);
            }];
            [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.giftImageView.mas_centerY);
                make.leading.mas_equalTo(self.giftImageView.mas_trailing).offset(5);
            }];
            
            [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.bgImageView).offset(-5);
                make.bottom.mas_equalTo(self.bgImageView).offset(30);
                make.height.width.mas_equalTo(35);
            }];
            self.sendIconImg.layer.cornerRadius = 16.0f;
            self.receiveIconImg.layer.cornerRadius = 16.0f;
        }
            break;
        case GiftChannelNotifyType_Middle:
        {
            [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.width.mas_equalTo(339);
                make.centerX.mas_equalTo(self.mas_centerX);
                make.height.mas_equalTo(159);
            }];
            [self.sendIconBorderImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(45);
                make.leading.mas_equalTo(self.bgImageView.mas_leading).offset(40);
                make.top.mas_equalTo(self.bgImageView.mas_top).offset(45);
            }];
            [self.sendIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(32);
                make.center.mas_equalTo(self.sendIconBorderImg);
            }];
            [self.sendNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.sendIconBorderImg.mas_bottom);
                make.centerX.mas_equalTo(self.sendIconBorderImg.mas_centerX);
                make.width.mas_equalTo(50);
            }];
            [self.tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.sendIconBorderImg.mas_centerY);
                make.width.mas_equalTo(33);
                make.height.mas_equalTo(23);
                make.leading.mas_equalTo(self.bgImageView).offset(82);
            }];
            [self.receiveIconBorderImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.top.mas_equalTo(self.sendIconBorderImg);
                make.leading.mas_equalTo(self.tipImage.mas_trailing);
            }];
            [self.receiveIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(self.sendIconImg);
                make.center.mas_equalTo(self.receiveIconBorderImg);
            }];
            [self.receiveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.receiveIconBorderImg.mas_bottom);
                make.centerX.mas_equalTo(self.receiveIconBorderImg.mas_centerX);
                make.width.mas_equalTo(50);
            }];
            [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bgImageView.mas_top).offset(46);
                make.width.height.mas_equalTo(60);
                make.leading.mas_equalTo(self.bgImageView).offset(165);
            }];
            [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.giftImageView.mas_centerY);
                make.leading.mas_equalTo(self.giftImageView.mas_trailing).offset(5);
            }];
            [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bgImageView).offset(81);
                make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(-1);
                make.height.mas_equalTo(41);
                make.width.mas_equalTo(169);
            }];
            [self.goLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.goImageView.mas_left).offset(48);
                make.centerY.mas_equalTo(self.goImageView.mas_centerY);
            }];
            [self.speakerBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.bgImageView.mas_trailing);
                make.top.mas_equalTo(self.bgImageView.mas_bottom);
                make.height.mas_equalTo(40);
                make.width.mas_equalTo(94);
            }];
            [self.speakerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.speakerBg.mas_leading).offset(28);
                make.centerY.mas_equalTo(self.speakerBg.mas_centerY).offset(-2);
                make.trailing.mas_equalTo(self.speakerBg.mas_trailing).offset(-24);
            }];
            
            [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.bgImageView).offset(-19);
                make.bottom.mas_equalTo(self.bgImageView).offset(-3);
                make.height.width.mas_equalTo(33);
            }];

            self.sendIconImg.layer.cornerRadius = 16.0f;
            self.receiveIconImg.layer.cornerRadius = 16.0f;
        }
            break;
        case GiftChannelNotifyType_Full:
        {
            [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self);
                make.width.mas_equalTo(321);
                make.height.mas_equalTo(167);
            }];
            
            [self.speakerBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(34);
                make.leading.mas_equalTo(self.bgImageView.mas_trailing);
                make.width.mas_equalTo(94);
                make.height.mas_equalTo(40);
            }];
            [self.speakerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.speakerBg.mas_leading).offset(28);
                make.centerY.mas_equalTo(self.speakerBg.mas_centerY).offset(-2);
                make.trailing.mas_equalTo(self.speakerBg.mas_trailing).offset(-24);
            }];
            [self.sendIconBorderImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(45);
                make.left.mas_equalTo(self.bgImageView).offset(38);
                make.top.mas_equalTo(self.bgImageView).offset(48);
            }];
            [self.sendIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(32);
                make.center.mas_equalTo(self.sendIconBorderImg);
            }];
            [self.sendNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.sendIconBorderImg.mas_bottom);
                make.centerX.mas_equalTo(self.sendIconBorderImg.mas_centerX);
                make.width.mas_equalTo(50);
            }];
            
            [self.tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.sendIconBorderImg);
                make.width.mas_equalTo(35);
                make.height.mas_equalTo(24);
                make.left.mas_equalTo(self.bgImageView.mas_left).offset(79);
            }];
            
            [self.receiveIconBorderImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.top.mas_equalTo(self.sendIconBorderImg);
                make.left.mas_equalTo(self.tipImage.mas_right);
            }];
            [self.receiveIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(self.sendIconImg);
                make.center.mas_equalTo(self.receiveIconBorderImg);
            }];
            [self.receiveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.receiveIconBorderImg.mas_bottom);
                make.centerX.mas_equalTo(self.receiveIconBorderImg.mas_centerX);
                make.width.mas_equalTo(50);
            }];
            [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bgImageView.mas_top).offset(48);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(60);
                make.left.mas_equalTo(self.bgImageView).offset(163);
            }];
            [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.giftImageView.mas_right).offset(5);
                make.centerY.mas_equalTo(self.giftImageView.mas_centerY);
            }];
            [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bgImageView).offset(79);
                make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(-7);
                make.height.mas_equalTo(39);
                make.width.mas_equalTo(167);
            }];
            [self.goLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.goImageView.mas_left).offset(48);
                make.centerY.mas_equalTo(self.goImageView.mas_centerY);
            }];
            [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.bgImageView).offset(-3);
                make.bottom.mas_equalTo(self.bgImageView).offset(-9);
                make.height.width.mas_equalTo(33);
            }];
            self.sendIconImg.layer.cornerRadius = 16;
            self.receiveIconImg.layer.cornerRadius = 16;
        }
            break;
        case GiftChannelNotifyType_NamePlate:{
            [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.top.mas_equalTo(self);
                make.height.equalTo(@24);
                make.width.equalTo(@(KScreenWidth));
            }];
            
            [self.namePlateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.bgImageView);
                make.left.right.equalTo(self.bgImageView).inset(20);
            }];
        
        }
            break;
        case GiftChannelNotifyType_Annual: //年度全服通知
        {
            [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.right.mas_equalTo(self).inset(10);
            }];
            
            [self.namePlateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self.bgImageView);
                make.left.mas_equalTo(70);
                make.right.mas_equalTo(-28);
            }];
            
            [self.svgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.bgImageView);
            }];
        }
            break;
        default:
            break;
    }
}

- (UILabel *)labelWithFont:(UIFont *)font color:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)closeNotify {
    [self moveOutAnimation:self stayTime:0];
}

- (void)goRoom {
    [[BaiduMobStat defaultStat]logEvent:@"full_gift_watching" eventLabel:@"前往围观"];
    if (self.giftNotifyInfo.roomUid == GetCore(ImPublicChatroomCore).publicChatroomUid) {//跳转公聊
       
        UIViewController *vc = [[XCMediator sharedInstance] TTMessageMoudle_HeadLineViewContoller:1];
        
        if ([[XCCurrentVCStackManager shareManager].getCurrentVC isKindOfClass:NSClassFromString(@"TTHeadLineContainerController")]){
            
            return;
            
        }else {
            if ([TTPopup hasShowPopup]) {
                
                [TTPopup dismiss];
                [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
                
            }else{
                [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
            }

        }
        return;
    }
    
    @weakify(self);
    if (self.hadOpenRoom) {
        [XCHUDTool showErrorWithMessage:@"已经入该房间"];
        return;
    }
    [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomOwnerUid:self.giftNotifyInfo.roomUid success:^(RoomInfo *roomInfo) {
        @strongify(self);
        if (roomInfo) {
            self.hadOpenRoom = YES;
            [self moveOutAnimation:self stayTime:0];
            [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomInfo:roomInfo];
        }
    } fail:^(NSString *errorMsg) {
        @strongify(self);
        self.hadOpenRoom = NO;
        [XCHUDTool showErrorWithMessage:errorMsg];
    }];
}

- (void)loadSvgaAnimation:(NSString *)matchStr {
    
    if (!matchStr) {
        return;
    }
    NSURL *matchUrl = [NSURL URLWithString:matchStr];
    
    @weakify(self)
    [self.svgManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @strongify(self)
        self.svgImageView.loops = INT_MAX;
        self.svgImageView.clearsAfterStop = NO;
        self.svgImageView.videoItem = videoItem;
        [self.svgImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        @strongify(self)
        [self.bgImageView qn_setImageImageWithUrl:@"" placeholderImage:@"broadcast_bg_annual" type:ImageTypeUserLibaryDetail];
    }];
}

#pragma mark - Getter & Setter
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        _bgImageView.userInteractionEnabled = NO;
    }
    return _bgImageView;
}

- (UIImageView *)sendIconImg{
    if (!_sendIconImg) {
        _sendIconImg = [[UIImageView alloc] init];
        _sendIconImg.layer.masksToBounds = YES;
    }
    return _sendIconImg;
}

- (UILabel *)sendNameLabel{
    if (!_sendNameLabel) {
        _sendNameLabel = [self labelWithFont:[UIFont systemFontOfSize:11] color:UIColorFromRGB(0xffffff)];
    }
    return _sendNameLabel;
}

- (UIImageView *)sendIconBorderImg {
    if (!_sendIconBorderImg) {
        _sendIconBorderImg = [[UIImageView alloc]init];
        _sendIconBorderImg.backgroundColor = [UIColor clearColor];
        _sendIconBorderImg.layer.masksToBounds = YES;
    }
    return _sendIconBorderImg;
}
- (UIImageView *)tipImage{
    if (!_tipImage) {
        _tipImage = [[UIImageView alloc]init];
    }
    return _tipImage;
}
- (UIImageView *)receiveIconBorderImg {
    if (!_receiveIconBorderImg) {
        _receiveIconBorderImg = [[UIImageView alloc]init];
        _receiveIconBorderImg.backgroundColor = [UIColor clearColor];
        _receiveIconBorderImg.layer.masksToBounds = YES;
    }
    return _receiveIconBorderImg;
}
- (UIImageView *)receiveIconImg{
    if (!_receiveIconImg) {
        _receiveIconImg = [[UIImageView alloc] init];
        _receiveIconImg.layer.masksToBounds = YES;
    }
    return _receiveIconImg;
}
- (UILabel *)receiveNameLabel{
    if (!_receiveNameLabel) {
        _receiveNameLabel = [self labelWithFont:[UIFont systemFontOfSize:11] color:UIColorFromRGB(0xffffff)];
    }
    return _receiveNameLabel;
}

- (UIImageView *)giftImageView{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] init];
    }
    return _giftImageView;
}
- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [self labelWithFont:[UIFont boldSystemFontOfSize:21] color:[XCTheme getTTMainColor]];
    }
    return _numLabel;
}
- (UILabel *)goLabel {
    if (!_goLabel) {
        _goLabel = [[UILabel alloc]init];
        _goLabel.font = [UIFont systemFontOfSize:10.f];
        _goLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _goLabel;
}
- (UIImageView *)goImageView {
    if (!_goImageView) {
        _goImageView = [[UIImageView alloc]init];
        _goImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goRoom)];
        [_goImageView addGestureRecognizer:tapGesture];
    }
    return _goImageView;
}
- (UIImageView *)speakerBg {
    if (!_speakerBg) {
        _speakerBg = [[UIImageView alloc]init];
        _speakerBg.hidden = YES;
    }
    return _speakerBg;
}
- (UILabel *)speakerLabel {
    if (!_speakerLabel) {
        _speakerLabel = [[UILabel alloc]init];
        _speakerLabel.textColor = UIColorFromRGB(0xffffff);
        _speakerLabel.font = [UIFont systemFontOfSize:14.f];
        _speakerLabel.hidden = YES;
    }
    return _speakerLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closeNotify) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (WBRollView *)namePlateLabel {
    if (!_namePlateLabel) {
        _namePlateLabel = [[WBRollView alloc] init];
        _namePlateLabel.marqueeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _namePlateLabel;
}

- (SVGAImageView *)svgImageView {
    if (_svgImageView == nil) {
        _svgImageView = [[SVGAImageView alloc]init];
        _svgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _svgImageView.userInteractionEnabled = NO;
        _svgImageView.hidden = YES;
    }
    return _svgImageView;
}

- (SVGAParserManager *)svgManager {
    if (_svgManager == nil) {
        _svgManager = [[SVGAParserManager alloc] init];
    }
    return _svgManager;
}

@end

@interface GiftBoradAdminCastView ()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *sendAvatarImageView;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIImageView *reciveAvatarImageView;
@property (nonatomic, strong) UIImageView *giftIamgeView;
@property (nonatomic, strong) UILabel *giftNumLabel;
@property (nonatomic, strong) GiftChannelNotifyInfo *giftNotifyInfo;
@property (nonatomic, assign) GiftChannelNotifyType displayType;
/** 弹幕背景 */
@property (nonatomic,strong) UIImageView *speakerBg;
/** 弹幕label */
@property (nonatomic,strong) UILabel *speakerLabel;

@end

@implementation GiftBoradAdminCastView

- (instancetype)initWithFrame:(CGRect)frame andDisplayType:(GiftChannelNotifyType)displayType {
    self = [super initWithFrame:frame];
    if (self) {
        _displayType = displayType;
        [self initViews];
        [self initContraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.sendAvatarImageView];
    [self.backImageView addSubview:self.sendLabel];
    [self.backImageView addSubview:self.reciveAvatarImageView];
    [self.backImageView addSubview:self.giftIamgeView];
    [self.backImageView addSubview:self.giftNumLabel];
    
    [self addSubview:self.speakerBg];
    [self.speakerBg addSubview:self.speakerLabel];
}

- (void)initContraints {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(345);
        make.height.mas_equalTo(60);
    }];
    
    [self.sendAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(110.5);
        make.centerY.mas_equalTo(self.backImageView);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sendAvatarImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.backImageView);
    }];
    
    [self.reciveAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sendLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.backImageView);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.giftIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reciveAvatarImageView.mas_right).offset(17.5);
        make.centerY.mas_equalTo(self.backImageView);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.giftNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giftIamgeView.mas_right).offset(1.5);
        make.centerY.mas_equalTo(self.backImageView);
    }];
    
    [self.speakerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KScreenWidth + 30);
        make.top.mas_equalTo(self.backImageView.mas_bottom);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(94);
    }];
    
    [self.speakerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.speakerBg.mas_leading).offset(28);
        make.centerY.mas_equalTo(self.speakerBg.mas_centerY).offset(-2);
        make.trailing.mas_equalTo(self.speakerBg.mas_trailing).offset(-24);
    }];
}

- (void)giftViewAnimateWithCompleteBlock:(completeBlock)completed {
    [self layoutIfNeeded];
    self.block = completed;
    CGFloat startTime = self.giftNotifyInfo.notifyStaySecond > 0 ? self.giftNotifyInfo.notifyStaySecond : 3.0;
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    springAnimation.springSpeed = 12;
    springAnimation.springBounciness = 10.f;
    springAnimation.fromValue = [NSValue valueWithCGPoint:self.center];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 + self.frame.size.width / 2, self.center.y)];
    @weakify(self);
    if (self.giftNotifyInfo.levelNum == GiftChannelNotifyType_Normal || self.giftNotifyInfo.levelNum == GiftChannelNotifyType_Full || self.giftNotifyInfo.levelNum == GiftChannelNotifyType_Middle) {
        if (self.giftNotifyInfo.msg.length > 0 && !self.giftNotifyInfo.mp4Gift) { // 自己房间，不是MP4礼物，并且有喊话文案
            [springAnimation setAnimationDidStartBlock:^(POPAnimation *anim) {
                @strongify(self);
                self.speakerBg.hidden = NO;
                self.speakerLabel.hidden = NO;
                POPBasicAnimation *moveAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
                moveAnimation.duration = startTime;
                moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                moveAnimation.fromValue = [NSValue valueWithCGPoint:self.speakerBg.center];
                moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 - self.speakerBg.frame.size.width, self.speakerBg.center.y)];
                [moveAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    [self.speakerBg removeFromSuperview];
                    self.speakerBg = nil;
                }];
                [self.speakerBg pop_addAnimation:moveAnimation forKey:@"moveAnimation"];
            }];
        }
    }
    [springAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self);
        if (finished) {
            [self moveOutAnimation:self stayTime:startTime];
        }
    }];
    [self pop_addAnimation:springAnimation forKey:@"spingOutAnimation"];
}
- (void)boradCastByGiftNotifyInfo:(GiftChannelNotifyInfo *)giftNotifyInfo {
    _giftNotifyInfo = giftNotifyInfo;
    switch (giftNotifyInfo.levelNum) {
        case GiftChannelNotifyType_Normal:
            self.backImageView.image = [UIImage imageNamed:@"broadcast_myRoom_l1"];
            break;
        case GiftChannelNotifyType_Middle:
            self.backImageView.image = [UIImage imageNamed:@"broadcast_myRoom_l2"];
            break;
        case GiftChannelNotifyType_Full:
            self.backImageView.image = [UIImage imageNamed:@"broadcast_myRoom_l3"];
            break;
        default:
            break;
    }
    [self.sendAvatarImageView qn_setImageImageWithUrl:giftNotifyInfo.sendUserAvatar placeholderImage:@"" type:ImageTypeUserIcon];
    self.sendLabel.text = @"赠送";
    [self.reciveAvatarImageView qn_setImageImageWithUrl:giftNotifyInfo.recvUserAvatar placeholderImage:@"" type:ImageTypeUserIcon];
    [self.giftIamgeView qn_setImageImageWithUrl:giftNotifyInfo.giftUrl placeholderImage:@"" type:ImageTypeRoomGift];
    self.giftNumLabel.text = [NSString stringWithFormat:@"x%d",giftNotifyInfo.giftNum];
    
    self.speakerBg.image = [self resizeWithImage:[UIImage imageNamed:@"broadcast_speak_l2"]];
    
    self.speakerLabel.text = giftNotifyInfo.msg;
    if (giftNotifyInfo.msg.length > 0) {
        CGSize textSize = [NSString sizeWithText:giftNotifyInfo.msg font:[UIFont systemFontOfSize:14.f] maxSize:CGSizeMake(KScreenWidth, 16)];
        [self.speakerBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textSize.width + 53);
        }];
    }
}

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

- (void)moveOutAnimation:(GiftBoradAdminCastView *)view stayTime:(CGFloat)stayTime{
    
    POPBasicAnimation *moveAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:view.center];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-KScreenWidth/2, view.center.y)];
    moveAnimation.beginTime = CACurrentMediaTime() + stayTime;
    moveAnimation.duration = 0.5;
    moveAnimation.repeatCount = 1;
    moveAnimation.removedOnCompletion = YES;
    [moveAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            if (self.block) {
                self.block(YES);
            }
            @autoreleasepool {
                [view removeFromSuperview];
                
            }
        }
    }];
    [view pop_addAnimation:moveAnimation forKey:@"moveOutAnimation"];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (UIImageView *)sendAvatarImageView {
    if (!_sendAvatarImageView) {
        _sendAvatarImageView = [[UIImageView alloc] init];
        _sendAvatarImageView.conrnerRadius(20).showVisual();
    }
    return _sendAvatarImageView;
}

- (UILabel *)sendLabel {
    if (!_sendLabel) {
        _sendLabel = [[UILabel alloc] init];
        _sendLabel.textColor = UIColorFromRGB(0xffffff);
        _sendLabel.font = [UIFont systemFontOfSize:12];
    }
    return _sendLabel;
}

- (UIImageView *)reciveAvatarImageView {
    if (!_reciveAvatarImageView) {
        _reciveAvatarImageView = [[UIImageView alloc] init];
        _reciveAvatarImageView.conrnerRadius(20).showVisual();
    }
    return _reciveAvatarImageView;
}

- (UIImageView *)giftIamgeView {
    if (!_giftIamgeView) {
        _giftIamgeView = [[UIImageView alloc] init];
    }
    return _giftIamgeView;
}

- (UILabel *)giftNumLabel {
    if (!_giftNumLabel) {
        _giftNumLabel = [[UILabel alloc] init];
        _giftNumLabel.textColor = UIColorFromRGB(0xFFEF30);
        _giftNumLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _giftNumLabel;
}

- (UIImageView *)speakerBg {
    if (!_speakerBg) {
        _speakerBg = [[UIImageView alloc]init];
        _speakerBg.hidden = YES;
    }
    return _speakerBg;
}
- (UILabel *)speakerLabel {
    if (!_speakerLabel) {
        _speakerLabel = [[UILabel alloc]init];
        _speakerLabel.textColor = UIColorFromRGB(0xffffff);
        _speakerLabel.font = [UIFont systemFontOfSize:14.f];
        _speakerLabel.hidden = YES;
    }
    return _speakerLabel;
}
@end

@interface GiftAnimOperation()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result);
@end

@implementation GiftAnimOperation
@synthesize finished = _finished;
@synthesize executing = _executing;


+ (instancetype)animOperationWithGiftBoradCastView:(GiftBoradCastView *)giftBoradCastView finishedBlock:(void (^)(BOOL))finishedBlock{
    GiftAnimOperation *op = [[GiftAnimOperation alloc] init];
    op.giftBoradCastView = giftBoradCastView;
    op.finishedBlock = finishedBlock;
    return op;
}

+ (instancetype)animOperationWithGiftBoradAdminView:(GiftBoradAdminCastView *)giftBoradAdminView isAdmin:(BOOL)isAdmin finishedBlock:(void (^)(BOOL))finishedBlock {
    GiftAnimOperation *op = [[GiftAnimOperation alloc] init];
    op.giftBoradAdminView = giftBoradAdminView;
    op.finishedBlock = finishedBlock;
    op.isAdmin = isAdmin;
    return op;
}

- (instancetype)init{
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
        
        if (self.isAdmin) {
            [self.giftBoradAdminView giftViewAnimateWithCompleteBlock:^(BOOL finished) {
                self.finished = finished;
                self.finishedBlock(finished);
            }];
        } else {
            [self.giftBoradCastView giftViewAnimateWithCompleteBlock:^(BOOL finished) {
                self.finished = finished;
                self.finishedBlock(finished);
            }];
        }
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


@interface GiftNotifySourceControl ()

@end


@implementation GiftNotifySourceControl
+ (GiftNotifyDisplayInfo *)getSourceByType:(GiftChannelNotifyType)displayType {
    GiftNotifyDisplayInfo *info = [[GiftNotifyDisplayInfo alloc]init];
    switch (displayType) {
        case GiftChannelNotifyType_Normal:
        {
            info.notifyBg = [UIImage imageNamed:@"broadcast_bg_l1"];
            info.speakingBg = nil;
            info.nameLabelBg = nil;
            info.goImageBg = nil;
            info.giveTypeBg = [UIImage imageNamed:@"broadcast_tip_l1"];
            info.headCycleBg = [UIImage imageNamed:@"broadcast_head_cycle_l1"];
            info.scaleBg = nil;
            info.closeBtnBg = [UIImage imageNamed:@"broadcast_bg_close_l1"];
            return info;
        }
            break;
        case GiftChannelNotifyType_Middle:
        {
            info.notifyBg = [UIImage imageNamed:@"broadcast_bg_l2"];
            info.speakingBg = [UIImage imageNamed:@"broadcast_speak_l2"];
            info.nameLabelBg = nil;
            info.goImageBg = [UIImage imageNamed:@"broadcast_go_btn_bg_l2"];
            info.giveTypeBg = [UIImage imageNamed:@"broadcast_tip_l2"];
            info.headCycleBg = [UIImage imageNamed:@"broadcast_head_cycle_l2"];
            info.scaleBg = nil;
            info.closeBtnBg = [UIImage imageNamed:@"broadcast_bg_close_l2"];
            return info;
        }
            break;
            
        case GiftChannelNotifyType_Full:
        {
            info.notifyBg = [UIImage imageNamed:@"broadcast_bg_l3"];
            info.speakingBg = [UIImage imageNamed:@"broadcast_speak_l2"];
            info.nameLabelBg = nil;
            info.goImageBg = [UIImage imageNamed:@"broadcast_go_btn_bg_l2"];
            info.giveTypeBg = [UIImage imageNamed:@"broadcast_tip_l2"];
            info.headCycleBg = [UIImage imageNamed:@"broadcast_head_cycle_l3"];
            info.scaleBg = nil;
            info.closeBtnBg = [UIImage imageNamed:@"broadcast_bg_close_l2"];
            return info;
        }
            break;
        case GiftChannelNotifyType_NamePlate:
        {
            info.notifyBg = [UIImage imageNamed:@"broadcast_nameplate_bg"];
            info.speakingBg = nil;
            info.nameLabelBg = nil;
            info.goImageBg = nil;
            info.giveTypeBg = nil;
            info.headCycleBg = nil;
            info.scaleBg = nil;
            info.closeBtnBg = nil;
            return info;
        }
            break;
        case GiftChannelNotifyType_Annual: //年度全服通知
        {
            info.notifyBg = [UIImage imageNamed:@"broadcast_bg_annual"];
            info.speakingBg = nil;
            info.nameLabelBg = nil;
            info.goImageBg = nil;
            info.giveTypeBg = nil;
            info.headCycleBg = nil;
            info.scaleBg = nil;
            info.closeBtnBg = nil;
            return info;
        }
            break;
        default:
            return info;
            break;
    }
    return nil;
}



@end
