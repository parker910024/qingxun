//
//  AppDelegate+Features.m
//  TTPlay
//
//  Created by lee on 2019/2/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "AppDelegate+Features.h"
#import "TTFamilyBaseAlertController.h"
#import "XCCurrentVCStackManager.h"
#import "NSString+Utils.h"
#import "XCTheme.h"
#import "GuildEmojiCode.h"
#import "GuildCheckEmojiCode.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import "AuthCore.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTGuildGroupManageConst.h"

#import "TTStatisticsService.h"

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

static NSString *const kCacheEmojiCodeName = @"kCacheEmojiCodeName";
static NSString *const kEmojiCodeCacheKey = @"kEmojiCodeCacheKey";
static NSString *const kEmojiCodeUserIDKey = @"kEmojiCodeUserIDKey";

@implementation AppDelegate (Features)

#pragma mark -
#pragma mark analysis
/** 解析暗号 */
- (void)analysisSecretCodeKey {
    
    if (![GetCore(AuthCore) isLogin]) {
        return;
    }
    // 从粘贴板里获取复制内容
    NSString *secretCodeStr = [UIPasteboard generalPasteboard].string;
    if (!secretCodeStr || secretCodeStr.length == 0) {
        // 如果没有数据，就停止
        return;
    }
    
    if (![NSString stringContainsEmoji:secretCodeStr]) {
        // 如果内容不是暗号内容，也停止。仅仅是个模糊判断匹配，拦截能力不强
        return;
    }
    
    // 如果不是符合公会暗号的格式
    if (![self isOrNotGuildSecretCodeStyle:secretCodeStr]) {
        return;
    }

    // 如果是自己分享出去的暗号
    if ([self isSelfEmojiCode:secretCodeStr]) {
        return;
    }
    
    // 如果内容是暗号就进行请求
    [GetCore(GuildCore) requestGuildCheckEmojiCode:secretCodeStr];
}


/**
 判断是否是公会格式的暗号
 @param string 暗号
 @return 是否
 */
- (BOOL)isOrNotGuildSecretCodeStyle:(NSString *)string {
    BOOL isGuildStyle = NO;
    NSString *regulaStr = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f]{5}";
    NSString *contions = @"[\\n]{1}";
    NSString *realPattern = [NSString stringWithFormat:@"%@%@%@", regulaStr, contions, regulaStr];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:realPattern
                                                                           options:NSRegularExpressionUseUnixLineSeparators error:nil];
    // 匹配到符合规则的数量大于 0 就暂且认为是暗号邀请码，可以调用接口
    NSInteger nums = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];

    if (nums >= 1) {
        isGuildStyle = YES;
    }

    return isGuildStyle;
}

#pragma mark -
#pragma mark coreClient

/**
 检测暗号邀请码结果

 @param guildCheckEmojiCode 检测结果模型
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildCheckEmojiCode:(GuildCheckEmojiCode *)guildCheckEmojiCode errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (!guildCheckEmojiCode) {
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    // 展示弹窗
    [self showAnalysisSecretCodeAlertWithEmojiModel:guildCheckEmojiCode];
}

/**
 根据邀请码加入模厅

 @param isSuccess 加入成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildJoinByEmojiCode:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (isSuccess) {
        [TTStatisticsService trackEvent:TTStatisticsServiceHallJoinFromPwdClick eventDescribe:@"通过暗号加入厅"];
        //当用户的公会入厅状态发生改变时，发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TTGuildGroupManageMayUpdateHallJoinStatusNoti object:nil];
        // 更新一下用户数据，获取公会模厅 ID
        [self updateUserInfoHandler];
    } else {
        [XCHUDTool hideHUD];
    }
}

#pragma mark -
#pragma mark alert

/**
 显示验证暗号邀请码的弹窗结果

 @param emojiModel 验证结果模型
 */

- (void)showAnalysisSecretCodeAlertWithEmojiModel:(GuildCheckEmojiCode *)emojiModel {
    
    // 如果是不显示 alert 状态，就直接返回。不做任何操作
    if (emojiModel.showDialog == CheckEmojiCodeAlertStatusClose) {
        return;
    }
    
    // alert 配置模型
    TTFamilyAlertModel *model = [[TTFamilyAlertModel alloc] init];
    
    switch (emojiModel.type) {
        case CheckEmojiCodeResultTypeInvalid:
        {   // 暗号失效 or 不存在
            model.content = emojiModel.msg;
        }
            break;
        case CheckEmojiCodeResultTypeGuild:
        {   // 公会暗号处理
            [self setUpGuildEmojiCodeAlert:emojiModel alertModel:model];
        }
            break;
            
        default:
            model.content = @"版本过旧，请下载最新版本哦";
            break;
    }
    // 显示弹窗
    [self showAlertView:emojiModel alertModel:model];
}

/** 处理公会暗号邀请码操作 */
- (void)setUpGuildEmojiCodeAlert:(GuildCheckEmojiCode *)emojiModel alertModel:(TTFamilyAlertModel *)alertModel {
    alertModel.changeColor = [XCTheme getTTMainColor];
    alertModel.moreChangeColor = [XCTheme getTTMainColor];
    alertModel.changeColorString = emojiModel.nick;
    alertModel.moreChangeColorStr = emojiModel.hallName;
    alertModel.rightConfigDic = @{@"text" : @"确定"};
    NSString *text = emojiModel.msg;
    if (emojiModel.emojiCode) {
        alertModel.rightConfigDic = @{@"text" : @"立即加入"};
        text = @"你终于来啦，等你很久咯~";
    }
    
    alertModel.content = [NSString stringWithFormat:@"%@邀请你加入%@\n%@", emojiModel.nick, emojiModel.hallName, text];
}

/**
 展示alert

 @param alertModel alert配置
 */
- (void)showAlertView:(GuildCheckEmojiCode *)emojiModel alertModel:(TTFamilyAlertModel *)alertModel {
    [[TTFamilyBaseAlertController defaultCenter] showAlertViewWith:[XCCurrentVCStackManager shareManager].getCurrentVC alertConfig:alertModel sure:^{
        if (emojiModel.emojiCode) {
            // 可以加入公会
            switch (emojiModel.type) {
                case CheckEmojiCodeResultTypeGuild:
                {
                    // 加入公会
                    [self joinGuildByEmojiCode:emojiModel];
                }
                    break;
                    
                default:
                    break;
            }
        }
    } canle:nil];
    // 显示之后，清空粘贴板
    [[UIPasteboard generalPasteboard] setString:@""];
}

/**
 加入公会

 @param emojiModel 暗号模型
 */
- (void)joinGuildByEmojiCode:(GuildCheckEmojiCode *)emojiModel {
    [GetCore(GuildCore) requestGuildJoinByEmojiCode:emojiModel.emojiCode];
    [XCHUDTool showGIFLoading];
}

#pragma mark -
#pragma mark update UserInfo

/// 更新用户数据
- (void)updateUserInfoHandler {
    @weakify(self)
    UserExtensionRequest *requese = [[UserExtensionRequest alloc] init];
    requese.type = QueryUserInfoExtension_Full;
    requese.needRefresh = YES;
    [[GetCore(UserCore) queryExtensionUserInfoByWithUserID:GetCore(AuthCore).getUid.longLongValue requests:@[requese]] subscribeNext:^(id x) {
        @strongify(self)
        // 跳转公会
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTGuildViewController];
            UINavigationController *currentVC = [[XCCurrentVCStackManager shareManager] currentNavigationController];
            [currentVC pushViewController:vc animated:YES];
            [XCHUDTool hideHUD];
        });
    }];
}
#pragma mark -
#pragma mark private methods
/**
 判断是否是自己分享的暗号邀请码
 
 @param emojiCodeStr 暗号邀请码
 @return 是否
 */
- (BOOL)isSelfEmojiCode:(NSString *)emojiCodeStr {
    // 暗号邀请码模型
    GuildEmojiCode *shareEmojiCode = [[GuildEmojiCode alloc] init];
    // 从本地缓存中获取
    YYCache *emojiCodeCache = [YYCache cacheWithName:kCacheEmojiCodeName];
    if ([emojiCodeCache containsObjectForKey:kEmojiCodeCacheKey]) {
        shareEmojiCode = (GuildEmojiCode *)[emojiCodeCache objectForKey:kEmojiCodeCacheKey];
    }
    // 判断是否可以是自己发出去的
    NSString *currentUserID = [GetCore(AuthCore) getUid];
    NSString *cacheUserID = (NSString *)[emojiCodeCache objectForKey:kEmojiCodeUserIDKey];
    if (![currentUserID isEqualToString:cacheUserID]) {
        // 如果缓存中的 UserID 和当前用户不是同一个，就清空缓存数据
        [emojiCodeCache removeAllObjects];
        return NO;
    }
    
    if (shareEmojiCode.emojiCode) {
        if ([emojiCodeStr containsString:shareEmojiCode.emojiCode]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 高德定位
/** 获取用户地理信息 */
- (void)locationWithCompletionBlock {
    
    if (!GetCore(AuthCore).isLogin) {
        return;
    }
    
    @weakify(self)
    [GetCore(UserCore)getUserInfo:[GetCore(AuthCore) getUid].userIDValue refresh:YES success:^(UserInfo *info) {
        
        @strongify(self)
        if (!info.nick.length || !info.avatar.length) {
            //未完善资料？
            return;
        }
                
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            //手机定位权限拒绝
            
            BOOL showLocation = info.userExpand==nil || info.userExpand.showLocation;
            if (showLocation) {
                //如果拒绝手机定位权限，将“地理位置展示权限”关闭
                [GetCore(UserCore) updateUserInfoLocationSwitch:NO];
            }
            return;
        }
        
        //尝试开始定位
        [self startConfigLocation];
        
    } failure:nil];
}

/** 开始获取获取用户地理信息 */
- (void)startConfigLocation {
    [self configLocationManager];
    [self initCompleteBlock];
    [self reGeocodeAction];
}

/**
 初始化定位
 */
- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)cleanUpAction {
    //停止定位
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
}

- (void)reGeocodeAction {
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction {
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

#pragma mark - Initialization
// 定位成功回调
- (void)initCompleteBlock {
    @weakify(self);
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        if (error != nil && error.code == AMapLocationErrorLocateFailed) {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        } else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost)) {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        } else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation) {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        } else {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //修改label显示内容
        if (regeocode) {
            // 获取成功后，上传
            [GetCore(ClientCore) uploadUserLocationAddress:regeocode.formattedAddress adcode:regeocode.adcode longitude:location.coordinate.longitude latitude:location.coordinate.latitude];
            
            //store last update date
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastUpdateLocationDateStoreKey];
            
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]);
        }
    };
}

#pragma mark - AMapLocationManagerDelegate
/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        //如果拒绝定位权限，将“地理位置展示权限”关闭
        [GetCore(UserCore) updateUserInfoLocationSwitch:NO];
    }
}

@end

