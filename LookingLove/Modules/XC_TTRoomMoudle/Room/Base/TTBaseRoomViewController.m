//
//  TTBaseRoomViewController.m
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTBaseRoomViewController.h"
//core
#import "NobleCore.h"
#import "NobleCoreClient.h"

#import "ImRoomCoreV2.h"
#import "ImRoomCoreClientV2.h"

#import "CarCoreClient.h"
#import "RoomCoreClient.h"

//tool
#import "UIImageView+QiNiu.h"
#import "NSString+JsonToDic.h"
#import <Masonry/Masonry.h>
#import "XCHUDTool.h"
#import "TTNobleSourceHandler.h"
#import <POP.h>
#import "BaseAttrbutedStringHandler+TTRoomModule.h"
#import "TTMp4PlayerTool.h"
#import "XCAniImageView.h"
#import "NSString+JsonToDic.h"

//view
#import "TTWelcomeNobleView.h"
#import "XCAniImageView.h"

@interface TTBaseRoomViewController ()
<
NobleCoreClient,
ImRoomCoreClient,
RoomCoreClient,
SVGAPlayerDelegate,
CarCoreClient
>

@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *nobleInterChatroomQueue;
@property (nonatomic, strong) NSMutableArray *nobleOpenEffectQueue;
@property (nonatomic, strong) NSMutableArray<UserCar *> *carEffectQueue;
@end

@implementation TTBaseRoomViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AddCoreClient(ImRoomCoreClient, self);
    AddCoreClient(ImRoomCoreClientV2, self);
    AddCoreClient(NobleCoreClient, self);
    AddCoreClient(RoomCoreClient, self);
    AddCoreClient(CarCoreClient, self);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    RemoveCoreClientAll(self);
    //Remove Client Here
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - CarCoreClient

- (void)userEnterRoomWithDrivingCarEffect:(UserCar *)effect {

    if (self.carEffectQueue.count > 0) {
        [self.carEffectQueue addObject:effect];
    }else {
        [self.carEffectQueue addObject:effect];
        [self startCarEffectWith:self.carEffectQueue.firstObject];
    }
    
}
#pragma mark - SVGAPlayerDelegate

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    if (self.nobleOpenEffectView == player) {
        [self updateNobleOpenEffectQueue:player];
    }else if (self.svgaCarEffectView == player) {
        [self updateCarEffectQueue:player];
    }
}

#pragma mark - NobleCoreClient

- (void)onReceiveNobleBoardcast:(NobleBroadcastInfo *)nobleinfo {
    id open_effect = [GetCore(NobleCore).privilegeDict objectForKey:[NSString stringWithFormat:@"%d",nobleinfo.nobleInfo.id]].open_effect.values.firstObject;
    if (nobleinfo.type == NobleBroadcastType_Open) {
        if ([nobleinfo.roomErbanNo isEqualToString:GetCore(ImRoomCoreV2).roomOwnerInfo.erbanNo]) {
            if ([open_effect isKindOfClass:[NSURL class]]) {
                
                if (self.nobleOpenEffectQueue.count > 0) {
                    [self.nobleOpenEffectQueue addObject:nobleinfo];
                }else {
                    [self.nobleOpenEffectQueue addObject:nobleinfo];
                    [self startOpen_effectWith:self.nobleOpenEffectQueue.firstObject];
                }
                
            }
        }
    }
}

- (void)onNobleUserEnterChatRoomSuccess:(SingleNobleInfo *)nobleInfo andNick:(NSString *)nick {
    if (nobleInfo && !nobleInfo.enterHide) {
        NSMutableDictionary *welcomeParams = [NSMutableDictionary dictionary];
        [welcomeParams setObject:nobleInfo forKey:@"nobleInfo"];
        [welcomeParams setObject:nick forKey:@"nick"];
        
        if (self.nobleInterChatroomQueue.count == 0) {
            [self.nobleInterChatroomQueue addObject:welcomeParams];
            [self creatWelcomeAnimate];
        }else {
            [self.nobleInterChatroomQueue addObject:welcomeParams];
        }
        
    }
}

#pragma mark - public
- (void)updateCarEffectQueue:(SVGAPlayer *)player {
    if (player == self.svgaCarEffectView) {
        if (self.carEffectQueue.count > 0) {
            [self.carEffectQueue removeObjectAtIndex:0];
            if (self.carEffectQueue.count > 0) {
                [self startCarEffectWith:self.carEffectQueue.firstObject];
            }else if (self.carEffectQueue.count == 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.svgaCarEffectView.alpha = 0;
                }];
            }
        }else if (self.carEffectQueue.count == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.svgaCarEffectView.alpha = 0;
            }];
        }
    }
}

- (void)updateNobleOpenEffectQueue:(SVGAPlayer *)player {
    if (player == self.nobleOpenEffectView) {
        if (self.nobleOpenEffectQueue.count > 0) {
            [self.nobleOpenEffectQueue removeObjectAtIndex:0];
            if (self.nobleOpenEffectQueue.count > 0) {
                [self startOpen_effectWith:self.nobleOpenEffectQueue.firstObject];
            }else if (self.nobleOpenEffectQueue.count == 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.nobleOpenEffectView.alpha = 0;
                    self.nobleOpenTextLabel.hidden = YES;
                    self.nobleOpenCloseBtn.hidden = YES;
                }];
            }
        }else if (self.nobleOpenEffectQueue.count == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.nobleOpenEffectView.alpha = 0;
                self.nobleOpenTextLabel.hidden = YES;
                self.nobleOpenCloseBtn.hidden = YES;
            }];
        }
    }
}

- (void)updateRoomBg:(RoomInfo *)info andUserInfo:(UserInfo *)userInfo {
    
    if (info.backPic.length > 0) {
        ///MARK:更改图片拉伸策略 BY lvjunhang, 2018-12-03,原值为：UIViewContentModeScaleAspectFit
        self.roomBg.contentMode = UIViewContentModeScaleAspectFill;
        if ([info.backPic containsString:@".svga"]) { //房间背景是SVGA动态背景
            self.roomBg.hidden = YES;
            self.svgDisplayView.hidden = NO;
            @weakify(self);
            //@"https://img.erbanyy.com/Noble_OpenEffect_5.svga"  @xiaoxiao svga动画 主房间
            [self.parserManager loadSvgaWithURL:[NSURL URLWithString:info.backPic] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                @strongify(self);
                self.svgDisplayView.loops = INT_MAX;
                self.svgDisplayView.clearsAfterStop = NO;
                self.svgDisplayView.videoItem = videoItem;
                [self.svgDisplayView startAnimation];
            } failureBlock:^(NSError * _Nullable error) {
                [XCHUDTool showErrorWithMessage:@"贵族专属背景图加载失败"];
            }];
        } else { //房间背景是静态背景
            [self.svgDisplayView stopAnimation];
            self.svgDisplayView.hidden = YES;
            self.roomBg.hidden = NO;
            if (info.type == RoomType_CP) {
                if (!info.isOpenGame) {
                    [self.roomBg qn_setImageImageWithUrl:info.backPic placeholderImage:@"Room_GameBg" type:(ImageType)ImageTypeUserLibaryDetail];
                }else{
                    [self.roomBg qn_setImageImageWithUrl:info.backPic placeholderImage:@"room_cp_game_bg" type:(ImageType)ImageTypeUserLibaryDetail];
                }
            } else if (info.type == RoomType_Love) {
                [self.roomBg qn_setImageImageWithUrl:info.backPic placeholderImage:@"room_love_game_bg" type:(ImageType)ImageTypeUserLibaryDetail];
            } else{
                [self.roomBg qn_setImageImageWithUrl:info.backPic placeholderImage:@"room_bg" type:(ImageType)ImageTypeUserLibaryDetail];
            }
        }
    }else { //没有设置背景，显示默认背景加高斯模糊
        self.roomBg.contentMode = UIViewContentModeScaleAspectFill;
        if (info.type == RoomType_CP) {
            if (!info.isOpenGame) {
                self.roomBg.image = [UIImage imageNamed:@"Room_GameBg"];
            }else{
                self.roomBg.image = [UIImage imageNamed:@"room_cp_game_bg"];
            }
        } else if (info.type == RoomType_Love) {
            self.roomBg.image = [UIImage imageNamed:@"room_love_game_bg"];
        } else {
            self.roomBg.image = [UIImage imageNamed:@"room_bg"];
        }
    }
}

- (void)showRoomExitWithUid:(UserID)uid {
}

- (void)ttBeKicked:(NIMChatroomKickReason)reson {
}

#pragma mark - private method

- (void)creatWelcomeAnimate {
    
    NSDictionary *dict = self.nobleInterChatroomQueue.firstObject;
    SingleNobleInfo *nobleInfo = dict[@"nobleInfo"];
    NSString *nick = dict[@"nick"];
    
    TTWelcomeNobleView *welcomeView = [[TTWelcomeNobleView alloc] init];
    welcomeView.frame = CGRectMake(-300, 400, 259, 41);
    [self.view addSubview:welcomeView];
    NSMutableDictionary<NSNumber *,NobleSourceInfo *> *dic = [GetCore(NobleCore)singleNobleInfoByUserNoble:nobleInfo type:@[@(NobleSource_wingBadge),@(NobleSource_banner)]];
    [TTNobleSourceHandler handlerImageView:welcomeView.welcomeBgView soure:dic[@(NobleSource_banner)].source imageType:(ImageType)ImageTypeUserLibaryDetail];
    [TTNobleSourceHandler handlerImageView:welcomeView.badgeImageView soure:dic[@(NobleSource_wingBadge)].source imageType:(ImageType)ImageTypeUserLibaryDetail];
    welcomeView.title = [BaseAttrbutedStringHandler creatWelcomeAttributedByNick:nick];
    NSString *str = [NSString stringWithFormat:@"欢迎“%@”光临本房间",nick];
    CGSize size = [self sizeWithText:str font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 25)];
    [self creatSpringAnimate:welcomeView width:size.width];
    
}

- (void)creatSpringAnimate:(TTWelcomeNobleView *)view width:(CGFloat)width{
    
    POPBasicAnimation *springAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    springAnimation.delegate = self;
    springAnimation.duration = 0.5;
    springAnimation.fromValue = [NSValue valueWithCGPoint:view.center];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(view.frame.size.width / 2 + 15, view.center.y)];
    @weakify(self);
    [springAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self);
        if (finished) {
            [self creatWelcomeContentAnimation:view width:width];
        }
    }];
    [view pop_addAnimation:springAnimation forKey:@"springView"];
}


- (void)creatWelcomeContentAnimation:(TTWelcomeNobleView *)view width:(CGFloat)width{
    CGFloat duration = 2;
    if (width>180) {
        duration += (width-180)/40;
    }
    POPBasicAnimation *contentAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    contentAnimation.delegate = self;
    contentAnimation.duration = duration;
    contentAnimation.beginTime = 0.5;
    contentAnimation.clampMode = kPOPAnimationClampBoth;
    contentAnimation.removedOnCompletion = NO;
    contentAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    contentAnimation.fromValue = [NSValue valueWithCGRect:view.contentLabel.frame];
    if (width>180) {
        CGRect frame = view.contentLabel.frame;
        contentAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(170-width, frame.origin.y,frame.size.width, frame.size.height)];
    }else{
        contentAnimation.toValue = [NSValue valueWithCGRect:view.contentLabel.frame];
    }
    
    @weakify(self);
    [contentAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self);
        if (finished) {
            [self creatRemoveAnimate:view time:(duration+0.5)];
        }
    }];
    [view.contentLabel pop_addAnimation:contentAnimation forKey:@"contentView"];
}

- (void)creatRemoveAnimate:(TTWelcomeNobleView *)view time:(CGFloat)time{
    POPBasicAnimation *removeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    removeAnimation.delegate = self;
    removeAnimation.duration = 0.5;
    removeAnimation.beginTime = time;
    removeAnimation.removedOnCompletion = NO;
    removeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    removeAnimation.fromValue = [NSValue valueWithCGPoint:view.center];
    removeAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(- view.frame.size.width, view.center.y)];
    @weakify(self);
    [removeAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self);
        if (finished) {
            [view removeFromSuperview];
            [self.nobleInterChatroomQueue removeObjectAtIndex:0];
            if (self.nobleInterChatroomQueue.count > 0) {
                [self creatWelcomeAnimate];
            }
        }
    }];
    [view pop_addAnimation:removeAnimation forKey:@"removeView"];
}


- (void)clearOpenNobleEffect {
    self.nobleOpenEffectView.alpha = 0;
    [self.nobleOpenEffectView stopAnimation];
    [self.nobleOpenEffectQueue removeAllObjects];
}

- (void)startCarEffectWith:(UserCar *)effect {
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!GetCore(RoomCoreV2).hasAnimationEffect) {
            [self.carEffectQueue removeAllObjects];
            return;
        }
        if (effect.mp4Url.length > 0 ) {
            XCAniImageView *view = [[XCAniImageView alloc] initWithFrame:self.view.bounds];
//            view.height = self.view.height - kNavigationHeight;
            XCAniImageConfigurSvgaModel *svgaModel = [[XCAniImageConfigurSvgaModel alloc] init];
            NSDictionary *dic = [NSString dictionaryWithJsonString:effect.mp4Key];
            UserCarKey *carKey = [UserCarKey modelWithJSON:dic];
            NSString *nick = effect.nick;
            if (nick.length > 5) {
                nick = [nick substringToIndex:5];
                nick =  [nick stringByAppendingFormat:@"..."];

            }
            svgaModel.replaceNickKey = carKey.nick;//替换key
            svgaModel.replaceNickName = nick;//用户昵称
            svgaModel.replaceKey = carKey.avatar;
            svgaModel.replaceUrl = effect.avatar;
            svgaModel.playCount = 1;
            svgaModel.mp4Url = effect.mp4Url;
            svgaModel.rio = 150.0/75.0;

            @KWeakify(self)
            svgaModel.finshCallBack = ^(UIView * _Nonnull view) {
                [selfWeak updateCarEffectQueue:selfWeak.svgaCarEffectView];
                [view removeFromSuperview];
            };
            [view configureSvgaModel:svgaModel];
            [view xc_setImageWithURL:[NSURL URLWithString:effect.mp4Url] withType:XCAniMp4];
            [self.view addSubview:view];
        } else {
            [self.parserManager loadSvgaWithURL:[NSURL URLWithString:effect.effect] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                @strongify(self);
                dispatch_main_sync_safe(^{
                    [UIView animateWithDuration:0.3 animations:^{
                        self.svgaCarEffectView.alpha = 1;
                    }];
                    self.svgaCarEffectView.hidden = NO;
                    
                    self.svgaCarEffectView.loops = 1;
                    self.svgaCarEffectView.clearsAfterStop = YES;
                    self.svgaCarEffectView.videoItem = videoItem;
                    [self.svgaCarEffectView startAnimation];
                });
                
            } failureBlock:^(NSError * _Nullable error) {
                @strongify(self);
                [self updateCarEffectQueue:self.svgaCarEffectView];
            }];
        }
    });
       
    
    
}


- (void)startOpen_effectWith:(NobleBroadcastInfo *)nobleinfo {
    @weakify(self);
    id open_effect = [GetCore(NobleCore).privilegeDict objectForKey:[NSString stringWithFormat:@"%d",nobleinfo.nobleInfo.id]].open_effect.values.firstObject;
    if ([open_effect isKindOfClass:[NSURL class]]) {
        [self.parserManager loadSvgaWithURL:open_effect completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            @strongify(self);
            [UIView animateWithDuration:0.3 animations:^{
                self.nobleOpenEffectView.alpha = 1;
            }];
            self.nobleOpenCloseBtn.hidden = NO;
            self.nobleOpenTextLabel.hidden = NO;
            self.nobleOpenEffectView.hidden = NO;
            self.nobleOpenTextLabel.textColor = [UIColor whiteColor];
            self.nobleOpenTextLabel.attributedText = [BaseAttrbutedStringHandler creatOpenNobleAttrByNick:nobleinfo.nick nobleName:nobleinfo.nobleInfo.name];
            self.nobleOpenEffectView.loops = 1;
            self.nobleOpenEffectView.clearsAfterStop = YES;
            self.nobleOpenEffectView.videoItem = videoItem;
            [self.nobleOpenEffectView startAnimation];
        } failureBlock:^(NSError * _Nullable error) {
            @strongify(self);
            [self updateNobleOpenEffectQueue:self.nobleOpenEffectView];
        }];
    }
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - Getter & Setter

- (NSMutableArray *)nobleInterChatroomQueue {
    if (_nobleInterChatroomQueue == nil) {
        _nobleInterChatroomQueue = [[NSMutableArray alloc]init];
    }
    return _nobleInterChatroomQueue;
}

- (SVGAImageView *)svgDisplayView {
    if (_svgDisplayView == nil) {
        _svgDisplayView = [[SVGAImageView alloc]init];
        _svgDisplayView.contentMode = UIViewContentModeScaleToFill;
        _svgDisplayView.userInteractionEnabled = NO;
        _svgDisplayView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _svgDisplayView.hidden = YES;
        _svgDisplayView.backgroundColor = [UIColor clearColor];
        
    }
    return _svgDisplayView;
}

- (UIImageView *)roomBg {
    if (_roomBg == nil) {
        _roomBg = [[UIImageView alloc]init];
        _roomBg.contentMode = UIViewContentModeScaleAspectFill;
        _roomBg.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _roomBg.backgroundColor = [UIColor blackColor];
        _roomBg.image = [UIImage imageNamed:@"room_bg"];
        _roomBg.clipsToBounds = YES;
    }
    return _roomBg;
}

- (NSMutableArray *)nobleOpenEffectQueue {
    if (_nobleOpenEffectQueue == nil) {
        _nobleOpenEffectQueue = [[NSMutableArray alloc]init];
    }
    return _nobleOpenEffectQueue;
}

- (SVGAImageView *)nobleOpenEffectView {
    if (_nobleOpenEffectView == nil) {
        _nobleOpenEffectView = [[SVGAImageView alloc]init];
        _nobleOpenEffectView.delegate = self;
        _nobleOpenEffectView.contentMode = UIViewContentModeScaleAspectFit;
        _nobleOpenEffectView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _nobleOpenEffectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _nobleOpenEffectView.alpha = 0;
        _nobleOpenEffectView.hidden = YES;
        _nobleOpenEffectView.userInteractionEnabled = NO;
    }
    return _nobleOpenEffectView;
}

- (SVGAImageView *)svgaCarEffectView {
    if (_svgaCarEffectView == nil) {
        _svgaCarEffectView = [[SVGAImageView alloc]init];
        _svgaCarEffectView.delegate = self;
        _svgaCarEffectView.contentMode = UIViewContentModeScaleAspectFit;
        _svgaCarEffectView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _svgaCarEffectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _svgaCarEffectView.alpha = 0;
        _svgaCarEffectView.hidden = YES;
        _svgaCarEffectView.userInteractionEnabled = NO;
    }
    return _svgaCarEffectView;
}

- (NSMutableArray<UserCar *> *)carEffectQueue {
    if (_carEffectQueue == nil) {
        _carEffectQueue = [NSMutableArray array];
    }
    return _carEffectQueue;
}

- (UIButton *)nobleOpenCloseBtn {
    if (_nobleOpenCloseBtn == nil) {
        _nobleOpenCloseBtn = [[UIButton alloc]init];
        [_nobleOpenCloseBtn setImage:[UIImage imageNamed:@"room_noble_close"] forState:UIControlStateNormal];
        [_nobleOpenCloseBtn setImage:[UIImage imageNamed:@"room_noble_close"] forState:UIControlStateHighlighted];
        [_nobleOpenCloseBtn addTarget:self action:@selector(clearOpenNobleEffect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nobleOpenCloseBtn;
}

- (UILabel *)nobleOpenTextLabel {
    if (_nobleOpenTextLabel == nil) {
        _nobleOpenTextLabel = [[UILabel alloc]init];
        _nobleOpenTextLabel.numberOfLines = 0;
        _nobleOpenTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nobleOpenTextLabel;
}

- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc]init];
    }
    return _parserManager;
}


@end
