//
//  XCFloatView.m
//  XCChatViewKit
//
//  Created by Macx on 2018/9/6.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "XCFloatView.h"

//core
#import "RoomCoreV2.h"
#import "ImRoomCoreClientV2.h"
#import "UserCore.h"
#import "AuthCore.h"
//manager
#import "XCTheme.h"
#import "Masonry.h"
#import "UIImageView+QiNiu.h"
#import "UIButton+EnlargeTouchArea.h"
#import "XCMacros.h"

//m
#import "RoomInfo.h"

//view
#import "UIView+XCToast.h"
#import "LXSEQView.h"

@interface XCFloatView () <ImRoomCoreClientV2>

@property (nonatomic, strong) UIView *containerView;//覆盖+
@property (nonatomic, strong) UIImageView *closeRoomAvatar;//+上房间图片
@property (nonatomic, strong) UIImageView *scaleMaskLayer;//+上关闭
@property (nonatomic, strong) LXSEQView *seqView;
@property (nonatomic, strong) UIView *scaleView;

// ------------------------------------------
@property (nonatomic, strong) UIButton *msExitButton;//退出按钮
@property (nonatomic, strong) UIImageView *msPlayBGImageView;//播放的背景图片
@property (nonatomic, strong) UIImageView *msAvatarBgImageView;//播放的头像背景图片
/** 头像 */
@property (nonatomic, strong) UIImageView *msAvatarImageView;

/** vkiss view */

@property (nonatomic, strong) UIButton *vkExitButton;//退出按钮
@property (nonatomic, strong) UIImageView *vkBGImageView;//背景图片

// --------- TuTu view
@property (nonatomic, strong) UIButton *ttExitButton;//退出按钮
@property (nonatomic, strong) UIImageView *ttBgImageView;//背景图片

@end

@implementation XCFloatView

#pragma mark - Life Cycle

- (void)dealloc {
    RemoveCoreClientAll(self);
}

+ (instancetype)shareFloatView {
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
            
        if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) { // meng sheng
            instance = [[self alloc] initWithFrame:CGRectMake(KScreenWidth - 102, KScreenHeight - kSafeAreaTopHeight - 49 - 102 - 40, 102, 102)];
        } else if (projectType() == ProjectType_Haha) {
            instance = [[self alloc] initWithFrame:CGRectMake(KScreenWidth - 80, KScreenHeight - kSafeAreaTopHeight - 49 - 80 - 40, 80, 80)];
        } else if (projectType() == ProjectType_TuTu ||
                   projectType() == ProjectType_Pudding ||
                   projectType() == ProjectType_LookingLove ||
                   projectType() == ProjectType_Planet ||
                   projectType() == ProjectType_CeEr) { // tutu
            instance = [[self alloc] initWithFrame:CGRectMake(KScreenWidth - 80 - 15, KScreenHeight - kSafeAreaTopHeight - 49 - 80 - 28 - 80 - 13 , 80, 80)];
        } else if (projectType() == ProjectType_VKiss) { // vkiss
            instance = [[self alloc] initWithFrame:CGRectMake(KScreenWidth - 92, KScreenHeight - kSafeAreaTopHeight - 49 - 80 - 24, 92, 80)];
        } else { // 其他, 此逻辑一般不走
            instance = [[self alloc] initWithFrame:CGRectMake(KScreenWidth - 80, KScreenHeight - kSafeAreaTopHeight - 49 - 80 - 40, 80, 80)];
        }
    });
    
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 确保可以识别各种与用户进行交互的手势
        self.userInteractionEnabled = YES;
        self.alpha = 1;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeLocation:)];
        
        if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) { // 萌声
            pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPlayViewAction:)];
            
        } else if (projectType() == ProjectType_Haha) {
            pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeLocation:)];
        }
        
        // 这里的delaysTouchesBegan属性很明显就是对touchBegin方法是否进行延迟,
        // YES表示延迟,即在系统未识别出来手势为什么手势时先不要调用touchesBegan 方法;
        // NO表示不延迟,即在系统未识别出来手势为什么手势时会先调用touchesBegan 方法;
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        [self setupSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<XCFloatViewDelegate>)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - event response
// 哈哈使用
- (void)changeLocation:(UIPanGestureRecognizer*)p {
    // 就是悬浮小球底下的那个的window,就是APPdelegete里面的那个window属性
    // 获取正在显示的那个界面的Window,http://www.jianshu.com/p/d23763e60e94
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    
    CGPoint panPoint = [p locationInView:appWindow];
    
    if (p.state == UIGestureRecognizerStateBegan) {
        self.alpha = 1;
    } else if(p.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    } else if(p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
        self.alpha = 1;
        CGFloat touchWidth = self.frame.size.width;
        CGFloat touchHeight = self.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        // fabs 是取绝对值的意思
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        CGFloat bottom = fabs(screenHeight - top);
        CGFloat minSpace = 0;
        if (self.leanType == XCSuspensionViewLeanTypeHorizontal) {
            minSpace = MIN(left, right);
        }else{
            minSpace = MIN(MIN(MIN(top, left), bottom), right);
        }
        CGPoint newCenter;
        CGFloat targetY = 0;
        //校正Y
        if (panPoint.y < 15 + touchHeight / 2.0) {
            targetY = 15 + touchHeight / 2.0;
        }else if (panPoint.y > (screenHeight - touchHeight / 2.0 - 15)) {
            targetY = screenHeight - touchHeight / 2.0 - 15;
        }else{
            targetY = panPoint.y;
        }
        
        if (minSpace == left) {
            newCenter = CGPointMake(touchHeight / 3 + 10, targetY);
            if (projectType() == ProjectType_VKiss) {
                newCenter = CGPointMake(screenWidth - touchHeight / 3 - 10, targetY);
            } else if (projectType() == ProjectType_TuTu ||
                       projectType() == ProjectType_Pudding ||
                       projectType() == ProjectType_LookingLove ||
                       projectType() == ProjectType_Planet ||
                       projectType() == ProjectType_CeEr) {
                newCenter = CGPointMake(15+touchHeight/2.0, targetY);
            }
        }else if (minSpace == right) {
            newCenter = CGPointMake(screenWidth - touchHeight / 3 - 10, targetY);
            if (projectType() == ProjectType_TuTu ||
                projectType() == ProjectType_Pudding ||
                projectType() == ProjectType_LookingLove ||
                projectType() == ProjectType_Planet ||
                projectType() == ProjectType_CeEr) {
                newCenter = CGPointMake(screenWidth - touchHeight/2.0 - 15, targetY);
            }
            
        }else if (minSpace == top) {
            newCenter = CGPointMake(panPoint.x, touchWidth / 3);
        }else if (minSpace == bottom) {
            newCenter = CGPointMake(panPoint.x, screenHeight - touchWidth / 3);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            if (newCenter.y + self.frame.size.height / 2 > KScreenHeight - kSafeAreaBottomHeight - 44) {
                self.center = CGPointMake(newCenter.x, KScreenHeight - self.frame.size.height / 2 - kSafeAreaBottomHeight - 44);
            }else {
                self.center = newCenter;
            }
            
        }];
        
    } else {
        NSLog(@"pan state : %zd", p.state);
    }
}

// 萌声使用
- (void)panPlayViewAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    //移动状态
    UIGestureRecognizerState recState =  panGestureRecognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGestureRecognizer translationInView:self.superview];
            panGestureRecognizer.view.center = CGPointMake(panGestureRecognizer.view.center.x + translation.x, panGestureRecognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0, screenHeight / 2.0);
            
            if (panGestureRecognizer.view.center.x < screenWidth / 2.0) {
                stopPoint = CGPointMake(self.frame.size.width/2.0, panGestureRecognizer.view.center.y);
                
            }else{
                stopPoint = CGPointMake(screenWidth - self.frame.size.width/2.0,panGestureRecognizer.view.center.y);
                
            }
            
            CGFloat topDistance = statusbarHeight + 44;
            
            if (stopPoint.x - self.frame.size.width/2.0 <= 0) {
                stopPoint = CGPointMake(self.frame.size.width/2.0, stopPoint.y);
            }
            
            if (stopPoint.x + self.frame.size.width/2.0 >= screenWidth) {
                stopPoint = CGPointMake(screenWidth - self.frame.size.width/2.0, stopPoint.y);
            }
            
            
            if (stopPoint.y - self.frame.size.height/2.0 - topDistance <= 0) {
                stopPoint = CGPointMake(stopPoint.x, self.frame.size.height/2.0 + topDistance);
            }
            
            if (stopPoint.y + self.frame.size.height/2.0 >= screenHeight - kSafeAreaBottomHeight - 49) {
                stopPoint = CGPointMake(stopPoint.x, screenHeight - self.frame.size.height/2.0 - kSafeAreaBottomHeight - 49);
            }
            
            
//            self.playFloatingViewNewRect = CGRectMake(stopPoint.x - kSuspendBtnWidth/2.0, stopPoint.y - kSuspendBtnHeight/2.0, kSuspendBtnWidth, kSuspendBtnHeight);
            
            
            [UIView animateWithDuration:0.25 animations:^{
                panGestureRecognizer.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
    
}

//最小化后进入房间
- (void)onRoomOwnnerAvatarClicked:(UITapGestureRecognizer *)tap {
    RoomInfo *roomInfo = [GetCore(RoomCoreV2) getCurrentRoomInfo];
    if (roomInfo != nil) {
//        [[XCRoomViewControllerCenter defaultCenter] presentRoomViewWithRoomInfo:roomInfo];
        if (self.delegate && [self.delegate respondsToSelector:@selector(floatViewDidClick:roomInfo:)]) {
            [self.delegate floatViewDidClick:self roomInfo:roomInfo];
        }
    }
}

// 关闭按钮的点击
- (void)exitButtonAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(floatView:didClickCloseButton:)]) {
        [self.delegate floatView:self didClickCloseButton:btn];
    }
    
    //此处不执行隐藏操作，隐藏逻辑由后续弹窗处理
    if (projectType() == ProjectType_TuTu ||
        projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet ||
        projectType() == ProjectType_CeEr) {
        return;
    }
    
    [self hideFloatingView];
}

#pragma mark - ImRoomCoreClientV2
- (void)onCurrentRoomInfoChanged {
    RoomInfo *roomInfo = [GetCore(RoomCoreV2) getCurrentRoomInfo];
    if (roomInfo != nil && roomInfo.valid) {
        [self showFloatingView:roomInfo];
    } else {
        [self hideFloatingView];
    }
}

#pragma mark - private method
- (void)setupSubView{
    AddCoreClient(ImRoomCoreClientV2, self);

    if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) { // MengSheng
        [self addSubview:self.msPlayBGImageView];
        [self.msPlayBGImageView addSubview:self.msAvatarBgImageView];
        [self.msPlayBGImageView addSubview:self.msExitButton];
        [self.msAvatarBgImageView addSubview:self.msAvatarImageView];
        [self addAnimationWithView:self.msAvatarBgImageView];
        
        [self msInitLayout];
    } else if (projectType() == ProjectType_Haha) {
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.scaleMaskLayer];
        [self.containerView addSubview:self.closeRoomAvatar];
        [self.containerView addSubview:self.scaleView];
        [self.containerView addSubview:self.seqView];
        [self addAnimationWithView:self.closeRoomAvatar];
        
        [self initLayout];
        
    }else if (projectType() == ProjectType_VKiss){
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.vkBGImageView];
        [self.containerView addSubview:self.vkExitButton];
        [self.containerView addSubview:self.scaleMaskLayer];
        [self.containerView addSubview:self.closeRoomAvatar];
//        [self.containerView addSubview:self.scaleView];
        [self addAnimationWithView:self.closeRoomAvatar];
        [self vkInitLayout];
        
    } else if (projectType() == ProjectType_TuTu ||
               projectType() == ProjectType_Pudding ||
               projectType() == ProjectType_LookingLove ||
               projectType() == ProjectType_Planet ||
               projectType() == ProjectType_CeEr) {
        
        [self addSubview:self.ttBgImageView];
        [self.ttBgImageView addSubview:self.closeRoomAvatar];
        [self.ttBgImageView addSubview:self.ttExitButton];
        [self.ttBgImageView addSubview:self.seqView];
        
        self.closeRoomAvatar.layer.cornerRadius = 28;
        [self addAnimationWithView:self.closeRoomAvatar];
        
        [self ttInitLayout];
    }
}

- (void)addAnimationWithView:(UIView *)view {
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: 2 * M_PI];
    
    if (projectType() == ProjectType_MengSheng) { // MengSheng
        animation.duration = 5;
    } else {
        animation.duration = 10;
    }
    
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    animation.removedOnCompletion = NO;
    [view.layer addAnimation:animation forKey:nil];
}

- (void)msInitLayout {
    [self.msPlayBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.msAvatarBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.msPlayBGImageView);
        make.width.height.mas_equalTo(61);
    }];
    
    [self.msAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.msAvatarBgImageView);
        make.width.height.mas_equalTo(34);
    }];
    
    [self.msExitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.right.mas_equalTo(-8);
        make.width.height.mas_equalTo(29);
    }];
}

- (void)initLayout {
    @weakify(self)
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self);
    }];
    
    [self.closeRoomAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.width.height.equalTo(@(60));
        make.center.equalTo(self.containerView);
    }];
    [self.scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.center.equalTo(self.containerView);
    }];
    [self.seqView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(20));
        make.height.mas_equalTo(15);
        make.center.equalTo(self.containerView);
    }];
    [self.scaleMaskLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.center.equalTo(self.containerView);
        make.width.height.equalTo(@(64));
    }];
}

- (void)ttInitLayout {
    @weakify(self)
    [self.ttBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self);
    }];
    
    [self.ttExitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.ttBgImageView).inset(5);
        make.width.height.mas_equalTo(21);
    }];
    
    [self.closeRoomAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.width.height.equalTo(@(56));
        make.centerY.equalTo(self.ttBgImageView);
        make.centerX.equalTo(self.ttBgImageView).offset(0.5);
    }];
    
    [self.seqView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.width.equalTo(@(20));
        make.height.equalTo(@(15));
        make.center.equalTo(self.ttBgImageView);
    }];
}

- (void)vkInitLayout {
    @weakify(self)
    [self.vkBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self);
    }];
    [self.vkExitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.mas_equalTo(self.containerView);
        make.right.mas_equalTo(self.containerView).offset(-20);
        make.width.height.mas_equalTo(20);
        
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self);
    }];
    self.scaleMaskLayer.hidden = YES;
    [self.closeRoomAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.width.height.equalTo(@(60));
        make.left.equalTo(self.containerView).offset(8);
        make.top.equalTo(self.containerView).offset(6);

    }];
    [self.scaleMaskLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.center.equalTo(self.containerView);
        make.width.height.equalTo(@(64));
    }];
}
- (void)showFloatingView:(RoomInfo *)roomInfo {
    @weakify(self)
    [GetCore(UserCore) getUserInfo:roomInfo.uid refresh:YES success:^(UserInfo *info) {
        @strongify(self)
        
        if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) { // MengSheng
            
            [self.msAvatarImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
            
        } else if (projectType() == ProjectType_Haha ||
                   projectType() == ProjectType_TuTu ||
                   projectType() == ProjectType_Pudding ||
                   projectType() == ProjectType_LookingLove ||
                   projectType() == ProjectType_Planet ||
                   projectType() == ProjectType_CeEr) {
            [self.closeRoomAvatar qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
        }else if (projectType() == ProjectType_VKiss) {
            if (projectType() == ProjectType_VKiss) {
                if (roomInfo.type == RoomType_Game) {
                    @weakify(self)
                    [GetCore(UserCore) getUserInfo:GetCore(AuthCore).getUid.userIDValue refresh:YES success:^(UserInfo *info) {
                        [GetCore(UserCore) getUserInfo:info.cpUid refresh:YES success:^(UserInfo *cpinfo) {
                            @strongify(self)
                            [self.closeRoomAvatar qn_setImageImageWithUrl:cpinfo.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
                        } failure:^(NSError *error) {
                        }];
                    } failure:^(NSError *error) {
                        
                    }];
                }else{
                    [self.closeRoomAvatar qn_setImageImageWithUrl:info.communityAvatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) { // MengSheng
        
    } else if (projectType() == ProjectType_Haha ||
               projectType() == ProjectType_TuTu ||
               projectType() == ProjectType_Pudding ||
               projectType() == ProjectType_LookingLove ||
               projectType() == ProjectType_Planet ||
               projectType() == ProjectType_CeEr) {
        [self.seqView startAnimation];
    }
    
    self.hidden = NO;
    if ((roomInfo.type == RoomType_RingUp)){
        self.hidden = YES;
        self.alpha = 0;
    }
}

- (void)hideFloatingView {
    if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) { // MengSheng
        
    } else if (projectType() == ProjectType_Haha ||
               projectType() == ProjectType_TuTu ||
               projectType() == ProjectType_Pudding ||
               projectType() == ProjectType_LookingLove ||
               projectType() == ProjectType_Planet ||
               projectType() == ProjectType_CeEr) {
        [self.seqView stopAnimation];
    }
    self.hidden = YES;
}

#pragma mark - Getter & Setter

- (UIView *)scaleView {
    if (!_scaleView) {
        _scaleView = [[UIView alloc]init];
        _scaleView.layer.cornerRadius = 30;
        _scaleView.layer.masksToBounds = YES;
        _scaleView.userInteractionEnabled = NO;
        _scaleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return _scaleView;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.userInteractionEnabled = YES;
    }
    return _containerView;
}

- (UIImageView *)scaleMaskLayer{
    if (!_scaleMaskLayer) {
//        _scaleMaskLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_float_btn_bg"]];
        _scaleMaskLayer = [[UIImageView alloc] init];
        _scaleMaskLayer.userInteractionEnabled = YES;
        _scaleMaskLayer.contentMode = UIViewContentModeScaleToFill;
        _scaleMaskLayer.backgroundColor = [UIColor whiteColor];
        _scaleMaskLayer.layer.cornerRadius = 32;
//        _scaleMaskLayer.layer.masksToBounds = YES;
        _scaleMaskLayer.layer.shadowColor = [[UIColor blackColor] CGColor];
        _scaleMaskLayer.layer.shadowOpacity = 0.3;
        _scaleMaskLayer.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _scaleMaskLayer;
}

- (UIImageView *)closeRoomAvatar {
    if (!_closeRoomAvatar) {
        _closeRoomAvatar = [[UIImageView alloc] init];
        _closeRoomAvatar.image = [UIImage imageNamed:[XCTheme defaultTheme].default_avatar];
        _closeRoomAvatar.userInteractionEnabled = YES;
        _closeRoomAvatar.layer.cornerRadius = 30;
        _closeRoomAvatar.layer.masksToBounds = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRoomOwnnerAvatarClicked:)];
        [_closeRoomAvatar addGestureRecognizer:recognizer];
    }
    return _closeRoomAvatar;
}

- (LXSEQView *)seqView {
    if (!_seqView) {
        _seqView = [[LXSEQView alloc] init];
        _seqView.pillarWidth = 3;
        _seqView.pillarColor = [UIColor whiteColor];
        _seqView.userInteractionEnabled = NO;
    }
    return _seqView;
}

// ------------------

- (UIImageView *)msPlayBGImageView {
    if (!_msPlayBGImageView) {
        _msPlayBGImageView = [[UIImageView alloc] init];
        _msPlayBGImageView.image = [UIImage imageNamed:@"floatView_bg"];
        _msPlayBGImageView.userInteractionEnabled = YES;
    }
    return _msPlayBGImageView;
}

- (UIImageView *)msAvatarBgImageView {
    if (!_msAvatarBgImageView) {
        _msAvatarBgImageView = [[UIImageView alloc] init];
        _msAvatarBgImageView.image = [UIImage imageNamed:@"floatView_avatar_bg"];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRoomOwnnerAvatarClicked:)];
        [_msAvatarBgImageView addGestureRecognizer:recognizer];
        _msAvatarBgImageView.userInteractionEnabled = YES;
    }
    return _msAvatarBgImageView;
}

- (UIImageView *)msAvatarImageView {
    if (!_msAvatarImageView) {
        _msAvatarImageView = [[UIImageView alloc] init];
        _msAvatarImageView.layer.cornerRadius = 17;
        _msAvatarImageView.layer.masksToBounds = YES;
    }
    return _msAvatarImageView;
}

- (UIButton *)msExitButton {
    if (!_msExitButton) {
        _msExitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msExitButton setImage:[UIImage imageNamed:@"floatView_close"] forState:UIControlStateNormal];
        [_msExitButton addTarget:self action:@selector(exitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _msExitButton;
}

- (UIButton *)vkExitButton{
    if (!_vkExitButton) {
        _vkExitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vkExitButton setImage:[UIImage imageNamed:@"window_ room_entrance_close"] forState:UIControlStateNormal];
        [_vkExitButton addTarget:self action:@selector(exitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _vkExitButton.contentEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, -5);
    }
    return _vkExitButton;
}

- (UIImageView *)vkBGImageView {
    if (!_vkBGImageView) {
        _vkBGImageView = [[UIImageView alloc] init];
        _vkBGImageView.image = [UIImage imageNamed:@"window_ room_entrance_bg"];
    }
    return _vkBGImageView;
}

- (UIButton *)ttExitButton {
    if (!_ttExitButton) {
        _ttExitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ttExitButton addTarget:self action:@selector(exitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_ttExitButton setEnlargeEdgeWithTop:5 right:5 bottom:3 left:3];
    }
    return _ttExitButton;
}

- (UIImageView *)ttBgImageView {
    if (!_ttBgImageView) {
        _ttBgImageView = [[UIImageView alloc] init];
        _ttBgImageView.image = [UIImage imageNamed:@"float_room_entrance_bg"];
        _ttBgImageView.contentMode = UIViewContentModeCenter;
        _ttBgImageView.userInteractionEnabled = YES;
    }
    return _ttBgImageView;
}
@end
