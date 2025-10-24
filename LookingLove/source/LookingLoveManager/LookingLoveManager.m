//
//  LookingLoveManager.m
//  LookingLoveManager
//
//  Created by KevinWang on 2019/10/29.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "LookingLoveManager.h"

#import "AnythingBoyThoughObject.h"
#import "PlayerListIHaveLiveViewController.h"
#import "ExplainSignStartObject.h"
#import "DeityRichManPrayViewController.h"

#import "BreakSeveralNecessaryObject.h"
#import "FoolManListCustomerViewController.h"
#import "KindWithinBelieveObject.h"
#import "RoughRailroadFootballViewController.h"

#import "MpanyAcrossClaimObject.h"
#import "MatchSpeechAlgebraViewController.h"
#import "RiseRecordDepartmentObject.h"
#import "InvitedCookTestedViewController.h"

#import "StrongClassLeastObject.h"
#import "PresenceDepthPhilosophiesViewController.h"
#import "WhyAlongFootObject.h"
#import "MembershipAndBearsCommonViewController.h"

@implementation LookingLoveManager

//首页
+ (void)lookingLoveHomeWillShow:(NSInteger)showIndex {
    
    [[AnythingBoyThoughObject instance] objoncemustpopularInfo:showIndex];
    [[AnythingBoyThoughObject instance] objcurrentgracemarkInfo:showIndex];
    
    PlayerListIHaveLiveViewController *playerVC = [[PlayerListIHaveLiveViewController alloc] init];
    [playerVC comeTowhilepermitthrowMethodAction:showIndex];
    [playerVC comeTofailattentionquietMethodAction:showIndex];
}
+ (void)lookingLoveHomeDidShow:(NSInteger)showIndex {
 
    [[ExplainSignStartObject instance] objonemarrysmileInfo:showIndex];
    [[ExplainSignStartObject instance] objwhilebluedollarInfo:showIndex];
    
    DeityRichManPrayViewController *deityVC = [[DeityRichManPrayViewController alloc] init];
    [deityVC comeTotohowsondropMethodAction:showIndex];
    [deityVC comeToupondrycharacterMethodAction:showIndex];
}

//发现
+ (void)lookingLoveDiscoverWillShow:(NSInteger)showIndex {
    
    [[BreakSeveralNecessaryObject instance] objavoideatyesInfo:showIndex];
    [[BreakSeveralNecessaryObject instance] objpeoplegunmodelInfo:showIndex];
    
    FoolManListCustomerViewController *foolVC = [[FoolManListCustomerViewController alloc] init];
    [foolVC comeTotheysellwinMethodAction:showIndex];
    [foolVC comeTosuggestcertainfitMethodAction:showIndex];
}
+ (void)lookingLoveDiscoverDidShow:(NSInteger)showIndex {
    
    [[KindWithinBelieveObject instance] objtwocanpatternInfo:showIndex];
    [[KindWithinBelieveObject instance] objlullabyblueonceInfo:showIndex];
    
    RoughRailroadFootballViewController *roughVC = [[RoughRailroadFootballViewController alloc] init];
    [roughVC comeTooperateshallchiefMethodAction:showIndex];
    [roughVC comeTopopularthanbumblebeeMethodAction:showIndex];
}

//消息
+ (void)lookingLoveMessageWillShow:(NSInteger)showIndex {
    
    [[MpanyAcrossClaimObject instance] objfromworkdeepInfo:showIndex];
    [[MpanyAcrossClaimObject instance] objgetwearbananaInfo:showIndex];
    
    MatchSpeechAlgebraViewController *matchVC = [[MatchSpeechAlgebraViewController alloc] init];
    [matchVC comeToheavypeaceburnMethodAction:showIndex];
    [matchVC comeTodelicacyinchlibertyMethodAction:showIndex];
}
+ (void)lookingLoveMessageDidShow:(NSInteger)showIndex {
    
    [[RiseRecordDepartmentObject instance] objbuysunlibertyInfo:showIndex];
    [[RiseRecordDepartmentObject instance] objwidefloorbananaInfo:showIndex];
    
    InvitedCookTestedViewController *invitedVC = [[InvitedCookTestedViewController alloc] init];
    [invitedVC comeTobananawhetheruponMethodAction:showIndex];
    [invitedVC comeToskillwillprinceMethodAction:showIndex];
}

//我的
+ (void)lookingLovePersonalWillShow:(NSInteger)showIndex {
    
    [[StrongClassLeastObject instance] objyesenjoygetInfo:showIndex];
    [[StrongClassLeastObject instance] objbankparadoxcanInfo:showIndex];
    
    PresenceDepthPhilosophiesViewController *presenceVC = [[PresenceDepthPhilosophiesViewController alloc] init];
    [presenceVC comeTodryfinishframeMethodAction:showIndex];
    [presenceVC comeToandlanguagechooseMethodAction:showIndex];
}
+ (void)lookingLovePersonalDidShow:(NSInteger)showIndex {
    
    [[WhyAlongFootObject instance] objbluebelowdryInfo:showIndex];
    [[WhyAlongFootObject instance] objsoulmatesortwinInfo:showIndex];
    
    MembershipAndBearsCommonViewController *memberVC = [[MembershipAndBearsCommonViewController alloc] init];
    [memberVC comeTowhosmilereduceMethodAction:showIndex];
    [memberVC comeToanimalmorefrequentMethodAction:showIndex];
}

@end
