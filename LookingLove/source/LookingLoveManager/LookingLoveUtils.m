//
//  LookingLoveUtils.m
//  LookingLoveManager
//
//  Created by KevinWang on 2019/10/29.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "LookingLoveUtils.h"
#import "AcrossClearAppearObject.h"
#import "DanceSpendSpaceObject.h"
#import "LetterRememberCutObject.h"
#import "ShortPastSoonObject.h"

#import "AgreePieceHeartObject.h"
#import "EasyFieldPropertyObject.h"
#import "QuiteBoardCareObject.h"
#import "SocialMindReachObject.h"

#import "BelieveIncludeFullObject.h"
#import "FreeKindSecondObject.h"
#import "ReadEducationAlongObject.h"
#import "TaxTalkNecessaryObject.h"

#import "CauseAnythingLearnObject.h"
#import "HourSometimesLoveObject.h"
#import "RecordClassTotalObject.h"
#import "VisitTypeTopObject.h"

@implementation LookingLoveUtils

//开房
+ (void)lookingLoveWillShowRoom:(NSInteger)roomType {
    
    [[AcrossClearAppearObject instance] objdangerwealthytheyInfo:roomType];
    [[DanceSpendSpaceObject instance] objwideeventbeInfo:roomType];
    [[LetterRememberCutObject instance] objloggedsquarestoreInfo:roomType];
    [[ShortPastSoonObject instance] objmuststationfaithInfo:roomType];
}

//私聊
+ (void)lookingLoveWillShowP2PChat:(NSInteger)sessionID {
    
    [[AgreePieceHeartObject instance] objseetreethanInfo:sessionID];
    [[EasyFieldPropertyObject instance] objexactridebarInfo:sessionID];
    [[QuiteBoardCareObject instance] objbankparadoxcanInfo:sessionID];
    [[SocialMindReachObject instance] objfailpoetskillInfo:sessionID];
}

//个人信息
+ (void)lookingLoveWillShowMyInfo:(NSInteger)userID {
    
    [[BelieveIncludeFullObject instance] objsavetheypermitInfo:userID];
    [[FreeKindSecondObject instance] objdivisionbadclubInfo:userID];
    [[ReadEducationAlongObject instance] objwidejoinpromiseInfo:userID];
    [[TaxTalkNecessaryObject instance] objhangimprovedollarInfo:userID];
}

//充值
+ (void)lookingLoveWillShowRecharge:(NSInteger)userID {
    
    [[CauseAnythingLearnObject instance] objbeforwinInfo:userID];
    [[HourSometimesLoveObject instance] objsizechancedogInfo:userID];
    [[RecordClassTotalObject instance] objofdangershootInfo:userID];
    [[VisitTypeTopObject instance] objprincehotelsingInfo:userID];
}

@end
