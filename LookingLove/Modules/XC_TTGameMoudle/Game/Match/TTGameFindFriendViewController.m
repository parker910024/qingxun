//
//  TTGameFindFriendViewController.m
//  TTPlay
//
//  Created by new on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameFindFriendViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCMacros.h"
#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"
#import "XCHUDTool.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "TTGameStaticTypeCore.h"
#import "CPGameCore.h"
#import "APNSCoreClient.h"
#import "RoomCoreClient.h"
// SVG动画
#import "SVGA.h"
#import "SVGAParserManager.h"

// frame
#import "UIView+NTES.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "TTGameAlertViewController.h"
#import "TTCustomMatchView.h"

@interface TTGameFindFriendViewController (){
    NSInteger matchNumber;
}
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) SVGAImageView *matchAniImageView;
@property (nonatomic, strong) SVGAParserManager *parserManager;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) TTCustomMatchView *myImageView;
@property (nonatomic, strong) TTCustomMatchView *youImageView;
@property (nonatomic, strong) UIButton *screenBtn;
@property (nonatomic, strong) UIButton *beginMatchBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *waitTimeLabel;
@property (nonatomic, strong) NSTimer *matchTimer;
@property (nonatomic, assign) NSInteger genderIndex;

@property (nonatomic, strong) UIView *outsideView;
@property (nonatomic, strong) UIView *insideView;

@end

@implementation TTGameFindFriendViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    // 移出匹配池
    [GetCore(CPGameCore) removeFindFriendMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue WithFindType:self.genderIndex];
    [self removeMatchBtnAnimation];
    [self invativeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstraint];
    [self addCore];
    
    matchNumber = 0;
    
    NSString *genderIndexType = [[NSUserDefaults standardUserDefaults] objectForKey:@"genderIndexSex"];
    if (genderIndexType.length <= 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"genderIndexSex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.genderIndex = 3;
    }else{
        self.genderIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"genderIndexSex"] integerValue];
    }
}

- (void)initView {
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.titleImageView];
    [self.view addSubview:self.screenBtn];
    [self.view addSubview:self.beginMatchBtn];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.waitTimeLabel];
    [self.view addSubview:self.matchAniImageView];
    [self.view addSubview:self.youImageView];
    [self.view addSubview:self.myImageView];
    [self initSvgaAnimation];
    [self beginMatchBtnAnimation];
}

- (void)initSvgaAnimation{
    [self loadSvgaAnimation:@"matchPage"];
}

- (void)addCore{
    AddCoreClient(APNSCoreClient, self);
}

- (void)loadSvgaAnimation:(NSString *)matchStr{
    
    NSString *matchString = [[NSBundle mainBundle] pathForResource:matchStr ofType:@"svga"];
    if (!matchString) {
        return;
    }
    NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
    
    @KWeakify(self);
    [self.parserManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.matchAniImageView.loops = INT_MAX;
        self.matchAniImageView.clearsAfterStop = NO;
        self.matchAniImageView.videoItem = videoItem;
        [self.matchAniImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)initConstraint{
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(statusbarHeight + 12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(36);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.waitTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleImageView.mas_bottom).offset(11);
        make.centerX.mas_equalTo(self.titleImageView);
        make.size.mas_equalTo(CGSizeMake(100, 13));
    }];
    
}

#pragma mark --- button Action ---
- (void)backCurrentPageAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)screenBtnAction:(UIButton *)sender{
    [[BaiduMobStat defaultStat] logEvent:@"game_player_choice" eventLabel:@"玩友匹配页-筛选条件"];
#ifdef DEBUG
    NSLog(@"game_player_choice");
#else
    
#endif
    TTGameAlertViewController *alertVC = [[TTGameAlertViewController alloc] init];
    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)beginMatchAction:(UIButton *)sender{
    if (sender.selected) { // 取消匹配
        
        [self beginMatchBtnAnimation];
        
        [[BaiduMobStat defaultStat] logEvent:@"game_player_finishmatch" eventLabel:@"玩友匹配页-停止匹配按钮"];
#ifdef DEBUG
        NSLog(@"game_player_finishmatch");
#else
        
#endif
        [GetCore(CPGameCore) removeFindFriendMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue WithFindType:self.genderIndex];
        sender.selected = NO;
        sender.backgroundColor = UIColorRGBAlpha(0x4FC4FF, 1);
        sender.layer.borderWidth = 0;
        _tipLabel.hidden = YES;
        _screenBtn.hidden = NO;
        _waitTimeLabel.hidden = YES;
        _titleImageView.image = [UIImage imageNamed:@"game_FindFriend_fly"];
        [self loadSvgaAnimation:@"matchPage"];
        [self invativeTimer];
    }else{  // 开始匹配
        [self removeMatchBtnAnimation];
        [[BaiduMobStat defaultStat] logEvent:@"game_player_beginmatch" eventLabel:@"开始匹配"];
#ifdef DEBUG
        NSLog(@"game_player_beginmatch");
#else
        
#endif
        @weakify(self);
        [[GetCore(CPGameCore) rac_addFindFriendMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue findType:self.genderIndex] subscribeNext:^(id x) {
            @strongify(self);
            // 如果加入匹配池成功
            if ([x boolValue]) {
                [self createTimer];
                sender.selected = YES;
                sender.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
                sender.layer.borderWidth = 1;
                sender.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
                self.tipLabel.hidden = NO;
                self.screenBtn.hidden = YES;
                self.waitTimeLabel.hidden = NO;
                self.titleImageView.image = [UIImage imageNamed:@"game_FindFriend_findIng"];
                [self loadSvgaAnimation:@"matchIng"];
            }
        } error:^(NSError *error) {
            [self showTeenagerAlertView:error];
        }];
    }
}

/**
 * 青少年模式下，显示无法进入房间警告 ⚠️
 * @param error 错误信息
 */
- (void)showTeenagerAlertView:(NSError *)error {
    [XCHUDTool hideHUDInView:self.view];
    if ([error isKindOfClass:[CoreError class]]) {
        CoreError *coreError = (CoreError *) error;
        if (coreError.resCode == 30000) {
            NotifyCoreClient(RoomCoreClient, @selector(roomOnLineTimsMaxWithMessage:), roomOnLineTimsMaxWithMessage:
                             coreError.message);
        } else {
            [XCHUDTool showErrorWithMessage:coreError.message inView:self.view];
        }
    }
}

- (void)createTimer{
    self.matchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(matchTimerNumber:) userInfo:nil repeats:YES];
}
- (void)matchTimerNumber:(NSTimer *)timer{
    matchNumber += 1;
    self.waitTimeLabel.text = [NSString stringWithFormat:@"等候时长 %ld 秒",matchNumber];
    if (matchNumber > 20) {
        [XCHUDTool showErrorWithMessage:@"匹配超时，请重新匹配" inView:self.view];
        [self invativeTimer];
        self.waitTimeLabel.hidden = YES;
        [self beginMatchAction:self.beginMatchBtn];
    }
}

- (void)invativeTimer{
    matchNumber = 0;
    self.waitTimeLabel.text = @"等候时长 0 秒";
    if (self.matchTimer) {
        [self.matchTimer invalidate];
        self.matchTimer = nil;
    }
}

#pragma mark -- 匹配成功 --
- (void)onFindFriendMatchingWithData:(NSDictionary *)dict{
    [self invativeTimer];
    [UIView animateWithDuration:0.5 animations:^{
        self.matchAniImageView.transform =  CGAffineTransformScale(self.matchAniImageView.transform, 0.2, 0.2);
        self.matchAniImageView.layer.anchorPoint = CGPointMake(0.5, 0.58);
        self.titleImageView.alpha = 0;
        self.waitTimeLabel.alpha = 0;
        self.beginMatchBtn.alpha = 0;
        self.tipLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.matchAniImageView.hidden = YES;
        self.matchAniImageView.transform = CGAffineTransformIdentity;
        [self.matchAniImageView stopAnimation];
        [self matchPeopleSuccess:dict];
    }];
}

- (void)matchPeopleSuccess:(NSDictionary *)dict{
    self.waitTimeLabel.text = @"请开始你的表演";
    self.titleImageView.image = [UIImage imageNamed:@"game_FindFriend_findSuccess"];
    
    NSString *imageUrlStr;
    NSString *idString;
    if ([dict[@"data"][@"player1"][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
        idString = [NSString stringWithFormat:@"%@",dict[@"data"][@"player2"][@"uid"]];
        imageUrlStr = dict[@"data"][@"player2"][@"avatar"];
    }else{
        idString = [NSString stringWithFormat:@"%@",dict[@"data"][@"player1"][@"uid"]];
        imageUrlStr = dict[@"data"][@"player1"][@"avatar"];
    }
    self.youImageView.imageUrlString = imageUrlStr;
    self.youImageView.hidden = NO;
    
    self.myImageView.userID = GetCore(AuthCore).getUid.userIDValue;
    self.youImageView.userID = idString.userIDValue;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.waitTimeLabel.alpha = 1;
        self.titleImageView.alpha = 1;
        
        self.myImageView.left = KScreenWidth / 2 - 120;
        self.youImageView.right = KScreenWidth / 2 + 120;
    } completion:^(BOOL finished) {
        [self.myImageView startAnimation];
        [self.youImageView startAnimation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *sessionVC = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:idString.userIDValue sessectionType:NIMSessionTypeP2P];
            [sessionVC setValue:@(YES) forKey:@"isMatchMessage"];
            [self.navigationController pushViewController:sessionVC animated:YES];
            
            NSArray *array = self.navigationController.viewControllers;
            NSMutableArray *vcArray = [NSMutableArray arrayWithArray:array];
            for (UIViewController *vc in array) {
                if ([vc isKindOfClass:TTGameFindFriendViewController.class] || [vc isKindOfClass:NSClassFromString(@"TTCompleteGameListViewController")]) {
                    [vcArray removeObject:vc];
                }
            }
            [self.navigationController setViewControllers:vcArray animated:NO];
        });
    }];
}

- (void)beginMatchBtnAnimation {

    [self removeMatchBtnAnimation];
    
    self.outsideView = [[UIView alloc] init];
    self.outsideView.frame = self.beginMatchBtn.frame;
    self.outsideView.layer.cornerRadius = 45 / 2;
    self.outsideView.backgroundColor = [UIColor clearColor];
    self.outsideView.userInteractionEnabled = NO;
    self.outsideView.layer.borderWidth = 1;
    self.outsideView.layer.borderColor = UIColorFromRGB(0x4FC4FF).CGColor;
    [self.view addSubview:self.outsideView];
    
    self.insideView = [[UIView alloc] init];
    self.insideView.frame = self.beginMatchBtn.frame;
    self.insideView.layer.cornerRadius = 45 / 2;
    self.insideView.backgroundColor = [UIColor clearColor];
    self.insideView.userInteractionEnabled = NO;
    self.insideView.layer.borderWidth = 1;
    self.insideView.layer.borderColor = UIColorFromRGB(0x4FC4FF).CGColor;
    [self.view addSubview:self.insideView];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.fromValue = @(1);
    animation.toValue = @(1.15);
    animation.autoreverses = NO;
    animation.repeatCount = INT_MAX;
    
    CABasicAnimation *animationY = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animationY.fromValue = @(1);
    animationY.toValue = @(1.5);
    animationY.autoreverses = NO;
    animationY.repeatCount = INT_MAX;
    
    CABasicAnimation * opcAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opcAni.fromValue = [NSNumber numberWithFloat:0.5];
    opcAni.toValue = [NSNumber numberWithFloat:0];
    
    CAAnimationGroup * groupAni = [CAAnimationGroup animation];
    groupAni.animations = @[animation,animationY, opcAni];
    groupAni.duration = 1.5;
    groupAni.fillMode = kCAFillModeForwards;
    groupAni.removedOnCompletion = NO;
    groupAni.repeatCount = INT_MAX;
    groupAni.autoreverses = NO;
    groupAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.outsideView.layer addAnimation:groupAni forKey:@"groupAni"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.insideView.layer addAnimation:groupAni forKey:@"groupAni"];
    });
    
}

- (void)removeMatchBtnAnimation {
    
    [self.outsideView.layer removeAllAnimations];
    [self.insideView.layer removeAllAnimations];
    [self.outsideView removeFromSuperview];
    [self.insideView removeFromSuperview];
    
}

#pragma mark --- setter ---
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"game_Complete_bg"];
    }
    return _backImageView;
}

- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.image = [UIImage imageNamed:@"game_FindFriend_fly"];
    }
    return _titleImageView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"game_Complete_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backCurrentPageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)screenBtn{
    if (!_screenBtn) {
        _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _screenBtn.size = CGSizeMake(70, 13);
        _screenBtn.centerX = KScreenWidth / 2;
        _screenBtn.bottom = KScreenHeight - kSafeAreaBottomHeight - 42;
        _screenBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_screenBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_screenBtn setTitle:@"筛选条件" forState:UIControlStateNormal];
        [_screenBtn setImage:[UIImage imageNamed:@"game_Complete_up"] forState:UIControlStateNormal];
        _screenBtn.imageFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, 13, 13)];
        _screenBtn.titleFrame = [NSValue valueWithCGRect:CGRectMake(16, 0, _screenBtn.width - 16, 13)];
        [_screenBtn addTarget:self action:@selector(screenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenBtn;
}

- (UIButton *)beginMatchBtn{
    if (!_beginMatchBtn) {
        _beginMatchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beginMatchBtn setTitle:@"开始匹配" forState:UIControlStateNormal];
        [_beginMatchBtn setTitle:@"停止" forState:UIControlStateSelected];
        [_beginMatchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _beginMatchBtn.backgroundColor = UIColorFromRGB(0x4FC4FF);
        _beginMatchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _beginMatchBtn.size = CGSizeMake(180, 45);
        _beginMatchBtn.layer.cornerRadius = _beginMatchBtn.height / 2;
        _beginMatchBtn.centerX = KScreenWidth / 2;
        _beginMatchBtn.bottom = _screenBtn.top - 38;
        [_beginMatchBtn addTarget:self action:@selector(beginMatchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beginMatchBtn;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"小提示：加入好友可随时约战";
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textColor = UIColorRGBAlpha(0xffffff, 0.5);
        [_tipLabel sizeToFit];
        _tipLabel.centerX = KScreenWidth / 2;
        _tipLabel.bottom = KScreenHeight - kSafeAreaBottomHeight - 41;
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (UILabel *)waitTimeLabel{
    if (!_waitTimeLabel) {
        _waitTimeLabel = [[UILabel alloc] init];
        _waitTimeLabel.text = @"等候时长 0 秒";
        _waitTimeLabel.font = [UIFont systemFontOfSize:13];
        _waitTimeLabel.textColor = UIColorRGBAlpha(0xffffff, 1);
        _waitTimeLabel.textAlignment = NSTextAlignmentCenter;
        _waitTimeLabel.hidden = YES;
    }
    return _waitTimeLabel;
}

- (TTCustomMatchView *)myImageView{
    if (!_myImageView) {
        _myImageView = [[TTCustomMatchView alloc] init];
        _myImageView.size = CGSizeMake(120, 120);
        _myImageView.centerX = KScreenWidth / 2;
        _myImageView.centerY = KScreenHeight / 2 - 30;
        _myImageView.imageUrlString = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].avatar;
    }
    return _myImageView;
}

- (TTCustomMatchView *)youImageView {
    if (!_youImageView) {
        _youImageView = [[TTCustomMatchView alloc] init];
        _youImageView.size = CGSizeMake(120, 120);
        _youImageView.centerX = KScreenWidth / 2;
        _youImageView.centerY = KScreenHeight / 2 - 30;
        _youImageView.hidden = YES;
    }
    return _youImageView;
}

- (SVGAImageView *)matchAniImageView {
    if (_matchAniImageView == nil) {
        _matchAniImageView = [[SVGAImageView alloc] init];
        _matchAniImageView.contentMode = UIViewContentModeScaleAspectFill;
        _matchAniImageView.userInteractionEnabled = NO;
        if (KScreenWidth >= 375) {
            _matchAniImageView.size = CGSizeMake(375, 667);
        }else{
            _matchAniImageView.size = CGSizeMake(KScreenWidth, KScreenHeight);
        }
        _matchAniImageView.centerX = KScreenWidth / 2;
        _matchAniImageView.centerY = KScreenHeight / 2;
        _matchAniImageView.backgroundColor = [UIColor clearColor];
    }
    return _matchAniImageView;
}


- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
