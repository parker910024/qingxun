//
//  LookingLoveMain.m
//  LookingLoveManager
//
//  Created by KevinWang on 2019/10/29.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "LookingLoveMain.h"
#import "AnythingBoyThoughObject.h"
#import "ExplainRoadRegardObject.h"

#import "MorningPeaceEasyObject.h"
#import "OrganizeKindControlObject.h"

#import "ResponsibleNotePaintObject.h"
#import "StopEffortTodayObject.h"

#import "WishCommonSurfaceObject.h"
#import "YoungOrganizeLetterObject.h"

#import "AboveRoadAmountObject.h"
#import "BusinessSpendConcernObject.h"

#import "CenturyEnterMoneyObject.h"
#import "DeathBoyFutureObject.h"



@implementation LookingLoveMain

+ (void)lookingLoveDidFinishLaunchingWithOptions {
    
    NSInteger index = 12;
    
    AnythingBoyThoughObject *obj = [AnythingBoyThoughObject instance];
    if ([obj respondsToSelector:NSSelectorFromString(@"objsuggesttouchmoneyInfo:")]) {
        [obj performSelector:NSSelectorFromString(@"objsuggesttouchmoneyInfo:") withObject:@(index)];
    }
    
//    [[AnythingBoyThoughObject instance] objsuggesttouchmoneyInfo:index];
//    [[AnythingBoyThoughObject instance] objcoolsortcertainInfo:index];
//
//    [[ExplainRoadRegardObject instance] objrelatelosslatterInfo:index];
//    [[ExplainRoadRegardObject instance] objaddressshallyouInfo:index];
}

+ (void)lookingLoveApplicationWillResignActive {
    
    NSInteger index = 23;
    [[MorningPeaceEasyObject instance] objbubbletohowelseInfo:index];
    [[MorningPeaceEasyObject instance] objdeepdeitcharacterInfo:index];
    
    [[OrganizeKindControlObject instance] objcanbloodstockInfo:index];
    [[OrganizeKindControlObject instance] objquicklistendreamInfo:index];
}

+ (void)lookingLoveApplicationDidEnterBackground {
    
    NSInteger index = 34;
    [[ResponsibleNotePaintObject instance] objfillsmilemoreInfo:index];
    [[ResponsibleNotePaintObject instance] objchiefsupposebrotherInfo:index];
    
    [[StopEffortTodayObject instance] objflycherisheatInfo:index];
    [[StopEffortTodayObject instance] objthingsanimalownershipInfo:index];
}

+ (void)lookingLoveApplicationWillEnterForeground {
    
    NSInteger index = 45;
    [[WishCommonSurfaceObject instance] objbedunlessdoingInfo:index];
    [[WishCommonSurfaceObject instance] objdependcertaincuteInfo:index];
    
    [[YoungOrganizeLetterObject instance] objbluelosstreeInfo:index];
    [[YoungOrganizeLetterObject instance] objlengthexpresshangInfo:index];
}

+ (void)lookingLoveApplicationDidBecomeActive {
 
    NSInteger index = 56;
    [[AboveRoadAmountObject instance] objmarksuitpoetInfo:index];
    [[AboveRoadAmountObject instance] objpricewavebeingInfo:index];
    
    [[BusinessSpendConcernObject instance] objEnglishmattersongInfo:index];
    [[BusinessSpendConcernObject instance] objpolicecentsummerInfo:index];
}

+ (void)lookingLoveApplicationWillTerminate {
    
    NSInteger index = 67;
    [[CenturyEnterMoneyObject instance] objremainwertainpoolInfo:index];
    [[CenturyEnterMoneyObject instance] objexactproductwideInfo:index];
    
    [[DeathBoyFutureObject instance] objlengthexpresshangInfo:index];
    [[DeathBoyFutureObject instance] objdistancelibertymemoryInfo:index];
}

@end
