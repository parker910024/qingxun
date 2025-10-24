//
//  SouthFeedTownObject.h
//  TestConfusion

//  Created by KevinWang on 19/07/18.
//  Copyright ©  2019年 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocietyTypeCareObject;
@class WatchEffortSuccessObject;
@class IndustryFallFallObject;
@class TalkSendWithinObject;
@class SocietyReceiveAirObject;
@class ListTowardOftenObject;
@class FriendOperationOftenObject;
@class MileKindWhiteObject;
@class PartyDifferenceDesireObject;
@class HourSometimesLoveObject;
#import <Foundation/Foundation.h>


@interface SouthFeedTownObject:NSObject

@property(nonatomic,strong) SocietyTypeCareObject *SocietyTypeCarePerson;
@property(nonatomic,strong) WatchEffortSuccessObject *WatchEffortSuccessPerson;
@property(nonatomic,strong) IndustryFallFallObject *IndustryFallFallPerson;
@property(nonatomic,strong) TalkSendWithinObject *TalkSendWithinPerson;
@property(nonatomic,strong) SocietyReceiveAirObject *SocietyReceiveAirPerson;
@property(nonatomic,strong) ListTowardOftenObject *ListTowardOftenPerson;
@property(nonatomic,strong) FriendOperationOftenObject *FriendOperationOftenPerson;
@property(nonatomic,strong) MileKindWhiteObject *MileKindWhitePerson;
@property(nonatomic,strong) PartyDifferenceDesireObject *PartyDifferenceDesirePerson;
@property(nonatomic,strong) HourSometimesLoveObject *HourSometimesLovePerson;


+ (instancetype)instance;

- (void)objpoorarrivechanceInfo:(NSInteger )ObJCount;
- (void)objgunexpressparadoxInfo:(NSInteger )ObJCount;
- (void)objfitavoidcanInfo:(NSInteger )ObJCount;
- (void)objdeathcomparearmyInfo:(NSInteger )ObJCount;
- (void)objjoinworkcertainInfo:(NSInteger )ObJCount;
- (void)objhusbandrealizeyourselfInfo:(NSInteger )ObJCount;
- (void)objraceyourhangInfo:(NSInteger )ObJCount;
- (void)objdistanceeasttravelInfo:(NSInteger )ObJCount;
- (void)objimagineshipbananaInfo:(NSInteger )ObJCount;
- (void)objlikelyhotelsunshineInfo:(NSInteger )ObJCount;
- (void)objlistencountarrangeInfo:(NSInteger )ObJCount;
- (void)objopportunityfrequentsizeInfo:(NSInteger )ObJCount;
- (void)objoperateshallchiefInfo:(NSInteger )ObJCount;
- (void)objburndirectionmannerInfo:(NSInteger )ObJCount;
- (void)objalteredrepresentaccordInfo:(NSInteger )ObJCount;
- (void)objcanbloodstockInfo:(NSInteger )ObJCount;
- (void)objsupposeattemptsunflowerInfo:(NSInteger )ObJCount;
- (void)objexceptdeeppurposeInfo:(NSInteger )ObJCount;
- (void)objmotherexistsuddenInfo:(NSInteger )ObJCount;
- (void)objstaffglassshipInfo:(NSInteger )ObJCount;


@end