//
//  TTGameMatchingViewController.m
//  TuTu
//
//  Created by new on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameMatchingViewController.h"
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "XCMacros.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "UIView+NTES.h"
#import <YYLabel.h>
#import <YYText.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "CPGameCore.h"
#import "APNSCore.h"
#import "APNSCoreClient.h"
#import "RoomCoreClient.h"

#import "CPGameListModel.h"
#import "XCHUDTool.h"
#import "TTGameStaticTypeCore.h"
#import "TTPopup.h"
#import "XCMediator+TTRoomMoudleBridge.h"

@interface TTGameMatchingViewController (){
    NSInteger  matchNumber; // 匹配超时
    NSInteger timerNumber;
}
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *titleLabel;
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIImageView *vsImageView;
@property (nonatomic, strong) UIImageView *youImageView;
@property (nonatomic, strong) YYLabel *myNickLabel;
@property (nonatomic, strong) YYLabel *youNickLabel;
@property (nonatomic, strong) UILabel *matchLabel;
@property (nonatomic, strong) UIImageView *matchImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) NSTimer *matchTimer; // 匹配超时
@property (nonatomic, strong) NSTimer *matchFailertimer;  // 匹配到人之后，进房间失败，停留在了匹配界面

@property (nonatomic, assign) NSInteger checkNumber;  // 审核中状态
@property (nonatomic, strong) NSTimer *checkTimer; // 匹配超时
@property (nonatomic, strong) NSString *robotID;
@end

@implementation TTGameMatchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    
    [self addCore];
    
    self.checkNumber = 2;
    
#ifdef DEBUG
    self.robotID = idWithRobotId(GetCore(AuthCore).getUid.userIDValue, YES);
#else
    self.robotID = idWithRobotId(GetCore(AuthCore).getUid.userIDValue, NO);
#endif
    
    if (self.robotID) { // 审核中状态
        GetCore(TTGameStaticTypeCore).checkType = YES;
        [[NSUserDefaults standardUserDefaults] setObject:self.robotID forKey:@"Robot"];
        [[NSUserDefaults standardUserDefaults] setObject:[self.model model2dictionary] forKey:@"matchGameData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTimerAciton:) userInfo:nil repeats:YES];

    } else {
        @KWeakify(self);
        [[GetCore(CPGameCore) requestGameList:GetCore(AuthCore).getUid.userIDValue GameId:self.model.gameId] subscribeError:^(NSError *error) {
            @KStrongify(self);
            
            // 青少年模式下。游戏匹配错误 code = 3000 时，弹窗警告
            if (error.code == 30000) {
                NotifyCoreClient(RoomCoreClient, @selector(roomOnLineTimsMaxWithMessage:), roomOnLineTimsMaxWithMessage:error.domain);
                [self.navigationController popViewControllerAnimated:YES];
            }
            if ([GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole == XCUserInfoPlatformRoleSuperAdmin) {
                [self closeClickAction:nil];
            }
        }];
        
        matchNumber = 0;
        timerNumber = 0;
        self.matchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(matchPropleAction) userInfo:nil repeats:YES];
    }
    
}

- (void)initView{
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.centerView];
    [self.centerView addSubview:self.vsImageView];
    [self.centerView addSubview:self.myImageView];
    [self.centerView addSubview:self.youImageView];
    [self.centerView addSubview:self.titleLabel];
    [self.centerView addSubview:self.myNickLabel];
    [self.centerView addSubview:self.youNickLabel];
    [self.centerView addSubview:self.matchLabel];
    
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.matchImageView];
    [self.view addSubview:self.closeButton];
    self.closeButton.hidden = NO;
}

- (void)addCore{
    AddCoreClient(APNSCoreClient, self);
}

- (void)checkTimerAciton:(NSTimer *)timer {
    self.checkNumber--;
    
    if (self.checkNumber <= 0) {
        [timer invalidate];
        timer = nil;
        
        [self.youImageView stopAnimating];
        
        [[GetCore(UserCore) getUserInfoByRac:self.robotID.userIDValue refresh:NO] subscribeNext:^(id x) {
            UserInfo *info = (UserInfo *)x;
            [self.youImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[[XCTheme defaultTheme] placeholder_image_cycle] type:ImageTypeUserIcon];
            
            self.youNickLabel.attributedText = [self createNickAttributeString:info.nick Gender:info.gender];
            [self.youNickLabel sizeToFit];
            self.youNickLabel.centerX = self.youImageView.centerX;
            
            self.matchLabel.hidden = YES;
            self.tipsLabel.hidden = YES;
            self.closeButton.hidden = YES;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[XCMediator sharedInstance] ttRoomMoudle_openMyRoomByType:5];
            
            NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
            for (UIViewController *VC in array) {
                if (VC.class == TTGameMatchingViewController.class) {
                    [array removeObject:VC];
                }
            }
            [self.navigationController setViewControllers:array animated:NO];
        });
    }
}

#pragma mark -- 匹配超时 ---
- (void)matchPropleAction{
    matchNumber++;
    if (matchNumber % 20 == 0) {
        [XCHUDTool showErrorWithMessage:@"匹配超时，请重新匹配" inView:self.view];
        @KWeakify(self);
        [[GetCore(CPGameCore) requestCancelGameMatch:GetCore(AuthCore).getUid.userIDValue GameId:self.model.gameId] subscribeError:^(NSError *error) {
            @KStrongify(self);
            [XCHUDTool showErrorWithMessage:error.domain inView:self.view];
        }];
        
        if (self.matchTimer) {
            [self.matchTimer invalidate];
            self.matchTimer = nil;
        }
        
        if (self.matchFailertimer) {
            [self.matchFailertimer invalidate];
            self.matchFailertimer = nil;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onMatchingPeopleFailed{
    
    if (self.matchTimer) {
        [self.matchTimer invalidate];
        self.matchTimer = nil;
    }
    
    if (self.matchFailertimer) {
        [self.matchFailertimer invalidate];
        self.matchFailertimer = nil;
    }
    
    [XCHUDTool showErrorWithMessage:@"发生未知错误，请重新匹配" inView:self.view];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onMatchingPeopleAndData:(NSDictionary *)dict{
    @KWeakify(self);
    [[GetCore(CPGameCore) requestCancelGameMatch:GetCore(AuthCore).getUid.userIDValue GameId:self.model.gameId] subscribeError:^(NSError *error) {
        @KStrongify(self);
        [XCHUDTool showErrorWithMessage:error.domain inView:self.view];
    }];
    
    NSDictionary *dataDict = dict[@"data"];
    if (self.matchTimer) { // 匹配到了人，要销毁记录匹配超时的计时器
        [self.matchTimer invalidate];
        self.matchTimer = nil;
    }
    if (![dataDict isKindOfClass:[NSDictionary class]]) {
        [XCHUDTool showErrorWithMessage:@"发生未知错误，请重新匹配" inView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // 用于匹配到人之后，进房间失败，依然停留在本页面的定时器判断
    self.matchFailertimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerWithStayThisPage) userInfo:nil repeats:YES];
    
    _matchLabel.hidden = YES;
    _tipsLabel.hidden = YES;
    
    _matchImageView.image = [UIImage imageNamed:@"game_suited_font2"];
    
    [_youImageView stopAnimating];
    
    if ([dataDict[@"player2"][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
        [self.youImageView qn_setImageImageWithUrl:dataDict[@"player1"][@"avatar"] placeholderImage:[[XCTheme defaultTheme] placeholder_image_cycle] type:ImageTypeUserIcon];
        
        UserGender gender = UserInfo_Male;
        if ([dataDict[@"player1"][@"gender"] integerValue] == 1) {
            gender = UserInfo_Male;
        }else{
            gender = UserInfo_Female;
        }
        self.youNickLabel.attributedText = [self createNickAttributeString:dataDict[@"player1"][@"nick"] Gender:gender];
        [self.youNickLabel sizeToFit];
        self.youNickLabel.centerX = self.youImageView.centerX;
    }else{
        [self.youImageView qn_setImageImageWithUrl:dataDict[@"player2"][@"avatar"] placeholderImage:[[XCTheme defaultTheme] placeholder_image_cycle] type:ImageTypeUserIcon];
        
        UserGender gender = UserInfo_Male;
        if ([dataDict[@"player2"][@"gender"] integerValue] == 1) {
            gender = UserInfo_Male;
        }else{
            gender = UserInfo_Female;
        }
        self.youNickLabel.attributedText = [self createNickAttributeString:dataDict[@"player2"][@"nick"] Gender:gender];
        [self.youNickLabel sizeToFit];
        self.youNickLabel.centerX = self.youImageView.centerX;
    }
    
    
    self.closeButton.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",dict[@"second"]] forKey:@"matchType"];
        [[NSUserDefaults standardUserDefaults] setObject:[self.model model2dictionary] forKey:@"matchGameData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([dataDict[@"aiUid"] integerValue] > 0) {
            NSLog(@"匹配到机器人");
            [[NSUserDefaults standardUserDefaults] setObject:dataDict[@"aiUid"] forKey:@"Robot"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Robot"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if ([dataDict[@"roomUid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
            
            [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"outOfMatchEnterMyRoom"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [TTPopup dismiss];
            
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[dataDict[@"roomUid"] userIDValue]];
            
            NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
            for (UIViewController *VC in array) {
                if (VC.class == TTGameMatchingViewController.class) {
                    [array removeObject:VC];
                }
            }
            [self.navigationController setViewControllers:array animated:NO];
        }else{
            
            //  两个人都是外部匹配。对方的方法
            
            //  这个方法要尤其注意。因为不管是两个房间外的匹配。还是一个房间内的匹配，都要做云信自定义消息的发送
            
            [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"outOfMatchEnterYouRoom"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [TTPopup dismiss];
            
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[dataDict[@"roomUid"] userIDValue]];
            NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
            for (UIViewController *VC in array) {
                if (VC.class == TTGameMatchingViewController.class) {
                    [array removeObject:VC];
                }
            }
            [self.navigationController setViewControllers:array animated:NO];
        }
        
    });
}

#pragma mark --- 退出匹配 ---
- (void)closeClickAction:(UIButton *)sender{
    
    [[BaiduMobStat defaultStat]logEvent:@"gamematching_close_click" eventLabel:@"关闭按钮"];
    
    [[GetCore(CPGameCore) requestCancelGameMatch:GetCore(AuthCore).getUid.userIDValue GameId:self.model.gameId] subscribeError:^(NSError *error) {
    }];
    
    if (self.matchTimer) {
        [self.matchTimer invalidate];
        self.matchTimer = nil;
    }
    
    if (self.matchFailertimer) {
        [self.matchFailertimer invalidate];
        self.matchFailertimer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//create mic+nick+gender
- (NSMutableAttributedString *)createNickAttributeString:(NSString *)nickString Gender:(UserGender )gender{
    CGFloat fontSize = 14.0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    //nick
    NSMutableAttributedString *nickLabelString = [self createNickLabel:nickString fontSize:fontSize];
    
    //gender
    NSMutableAttributedString *genderString = [self createGenderAttr:gender];
    
    
    [attributedString appendAttributedString:nickLabelString];
    [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    [attributedString appendAttributedString:genderString];
    
    return attributedString;
}

- (NSMutableAttributedString *)createNickLabel:(NSString *)userNick fontSize:(CGFloat)fontSize{
    
    UILabel *nickLabel = [[UILabel alloc]init];
    //text
    NSString *nick = userNick;
    
    nickLabel.text = nick;
    
    nickLabel.font = [UIFont systemFontOfSize:fontSize];
    
    nickLabel.textColor = UIColorRGBAlpha(0x333333, 1.0);
    
    //width
    CGFloat nickWidth = [self sizeWithText:nick font:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(KScreenWidth , KScreenHeight)].width;
    CGFloat maxWidth = 72;
    if (nickWidth > maxWidth) {
        nickLabel.bounds = CGRectMake(0, 0, maxWidth, 14);
    }else {
        nickLabel.bounds = CGRectMake(0, 0, nickWidth+3, 14);
    }
    
    NSMutableAttributedString * nickString = [NSMutableAttributedString yy_attachmentStringWithContent:nickLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nickLabel.frame.size.width, nickLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:fontSize] alignment:YYTextVerticalAlignmentCenter];
    return nickString;
}

//create gender
- (NSMutableAttributedString *)createGenderAttr:(UserGender )gender{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.bounds = CGRectMake(0, 0, 14, 14);;
    imageView.contentMode = UIViewContentModeScaleToFill;
    NSString *imageName = @"";
    if (gender == 1) {
        imageName = @"game_gender_boy";
    }else{
        imageName = @"game_gender_girl";
    }
    imageView.image = [UIImage imageNamed:imageName];
    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
    return imageString;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark --- 懒加载 ---
-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.size = CGSizeMake(KScreenWidth, KScreenHeight);
        _backImageView.left = 0;
        _backImageView.top = 0;
        _backImageView.image = [UIImage imageNamed:@"game_suited_bg"];
    }
    return _backImageView;
}

-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = UIColor.whiteColor;
        _centerView.layer.cornerRadius = 20;
        _centerView.layer.masksToBounds = YES;
        _centerView.size = CGSizeMake(320, 200);
        _centerView.centerX = KScreenWidth / 2;
        _centerView.centerY = KScreenHeight / 2 - 43;
        _centerView.clipsToBounds = NO;
    }
    return _centerView;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"匹配玩家默认取消进房限制";
        _tipsLabel.textColor = UIColorRGBAlpha(0xffffff, 0.5);
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        [_tipsLabel sizeToFit];
        _tipsLabel.hidden = NO;
        _tipsLabel.top = _centerView.bottom + 13;
        _tipsLabel.centerX = KScreenWidth / 2;
    }
    return _tipsLabel;
}

-(UIImageView *)matchImageView{
    if (!_matchImageView) {
        _matchImageView = [[UIImageView alloc] init];
        _matchImageView.size = CGSizeMake(93, 23);
        _matchImageView.image = [UIImage imageNamed:@"game_suited_font"];
        _matchImageView.bottom = _centerView.top - 30 - 17;
        _matchImageView.centerX = KScreenWidth / 2;
        _matchImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _matchImageView;
}

-(UIButton *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleLabel.size = CGSizeMake(100, 34);
        _titleLabel.centerX = self.centerView.width / 2;
        _titleLabel.bottom = 17;
        [_titleLabel setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_titleLabel setTitle:self.model.gameName forState:UIControlStateNormal];
        
        _titleLabel.backgroundColor = UIColorFromRGB(0xFFB606);
        _titleLabel.titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.layer.cornerRadius = 17;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}

-(UIImageView *)vsImageView{
    if (!_vsImageView) {
        _vsImageView = [[UIImageView alloc] init];
        _vsImageView.image = [UIImage imageNamed:@"VS"];
        _vsImageView.size = CGSizeMake(27, 18);
        _vsImageView.centerX = self.centerView.width / 2;
        _vsImageView.centerY = self.centerView.height / 2 - 15 / 2;
    }
    return _vsImageView;
}

-(UIImageView *)myImageView{
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] init];
        _myImageView.size = CGSizeMake(90, 90);
        _myImageView.centerY = _vsImageView.centerY;
        _myImageView.layer.cornerRadius = _myImageView.width / 2;
        _myImageView.layer.masksToBounds = YES;
        _myImageView.right = _vsImageView.left - 23;
        [_myImageView qn_setImageImageWithUrl:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    }
    return _myImageView;
}

-(YYLabel *)myNickLabel{
    if (!_myNickLabel) {
        _myNickLabel = [[YYLabel alloc] init];
        _myNickLabel.attributedText = [self createNickAttributeString:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick Gender:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].gender];
        _myNickLabel.font = [UIFont systemFontOfSize:14];
        [_myNickLabel sizeToFit];
        _myNickLabel.top = _myImageView.bottom + 10;
        _myNickLabel.centerX = _myImageView.centerX;
        _myNickLabel.height = 15;
        
    }
    return _myNickLabel;
}

-(UIImageView *)youImageView{
    if (!_youImageView) {
        _youImageView = [[UIImageView alloc] init];
        _youImageView.size = CGSizeMake(90, 90);
        _youImageView.centerY = _vsImageView.centerY;
        _youImageView.layer.cornerRadius = _youImageView.width / 2;
        _youImageView.layer.masksToBounds = YES;
        _youImageView.left = _vsImageView.right + 23;
        NSArray *imageArray = @[@"game_suited_ing",@"game_suited_ing2",@"game_suited_ing3"];
        NSMutableArray *addImageArray = [NSMutableArray array];
        for (int i = 0; i < imageArray.count; i++) {
            UIImage *image = [UIImage imageNamed:imageArray[i]];
            [addImageArray addObject:image];
        }
        _youImageView.animationImages = addImageArray;
        _youImageView.animationRepeatCount = NSIntegerMax;
        _youImageView.animationDuration = 0.5;
        [_youImageView startAnimating];
    }
    return _youImageView;
}

- (YYLabel *)youNickLabel{
    if (!_youNickLabel) {
        _youNickLabel = [[YYLabel alloc] init];
        _youNickLabel.top = _youImageView.bottom + 10;
        _youNickLabel.centerX = _youImageView.centerX;
        _youNickLabel.height = 15;
        _youNickLabel.font = [UIFont systemFontOfSize:14];
    }
    return _youNickLabel;
}

- (UILabel *)matchLabel{
    if (!_matchLabel) {
        _matchLabel = [[UILabel alloc] init];
        _matchLabel.text = @"匹配对手中";
        _matchLabel.textColor = UIColorFromRGB(0x999999);
        _matchLabel.font = [UIFont systemFontOfSize:14];
        [_matchLabel sizeToFit];
        _matchLabel.top = _youImageView.bottom + 10;
        _matchLabel.centerX = _youImageView.centerX;
    }
    return _matchLabel;
}

-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.size = CGSizeMake(51, 51);
        [_closeButton setImage:[UIImage imageNamed:@"game_suited_close"] forState:UIControlStateNormal];
        _closeButton.centerX = KScreenWidth / 2;
        _closeButton.bottom = KScreenHeight - 105;
        [_closeButton addTarget:self action:@selector(closeClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark --- 匹配成功，但是进房间失败。依然停留在了匹配界面 此时用定时器去跑一下停留时间 ---
- (void)timerWithStayThisPage{
    timerNumber++;
    if (timerNumber == 6) {
        if (self.matchTimer) {
            [self.matchTimer invalidate];
            self.matchTimer = nil;
        }
        
        if (self.matchFailertimer) {
            [self.matchFailertimer invalidate];
            self.matchFailertimer = nil;
        }
        [XCHUDTool showErrorWithMessage:@"发生未知错误，请重新匹配" inView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    RemoveCoreClientAll(self);
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
    
    if (self.matchFailertimer) { // 匹配成功，进入房间成功。销毁当前计时器
        [self.matchFailertimer invalidate];
        self.matchFailertimer = nil;
    }
    
    if (self.checkTimer) {
        [self.checkTimer invalidate];
        self.checkTimer = nil;
    }
}

- (void)dealloc{
    RemoveCoreClientAll(self);
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
