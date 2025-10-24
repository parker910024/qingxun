//
//  TTGameRoomViewController+GuideView.m
//  AFNetworking
//
//  Created by apple on 2019/5/24.
//

#import "TTGameRoomViewController+GuideView.h"
#import "RoomCoreV2.h"
#import "TTNewbieGuideView.h"
#import "MissionCore.h"

// 房间页新手引导状态保存
static NSString *const kRoomGuideStatusStoreKey = @"TTRoomViewRoomGuideStatus";

@implementation TTGameRoomViewController (GuideView)

- (void)addGuideView {
    // 轻寻不展示新手引导
    if (projectType() == ProjectType_LookingLove) {
        return;
    }
    
    NSValue *pointValue = [GetCore(RoomCoreV2).positionArr lastObject];
    
    CGPoint point = [pointValue CGPointValue];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL hadGuide = [ud boolForKey:kRoomGuideStatusStoreKey];
    if (!hadGuide) {
        [ud setBool:YES forKey:kRoomGuideStatusStoreKey];
        [ud synchronize];
        CGRect rect = CGRectZero;
        NSInteger itemWidth = 75;
        rect = CGRectMake(point.x - 75 / 2, point.y - 75 / 2 + statusbarHeight + 57, 75, 75);
        
        if (![[UIApplication sharedApplication].keyWindow viewWithTag:2000]) {
            
            TTNewbieGuideView *guideView = [[TTNewbieGuideView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) withArcWithFrame:rect withSpace:YES withCorner:itemWidth / 2 withPage:TTGuideViewPage_Room];
            
            guideView.tag = 2000;
            
            __block TTNewbieGuideView *guideViewBlock = guideView;
            guideView.currentType = ^(NSInteger index) {
                
                [guideViewBlock addArcWithFrame:CGRectMake(KScreenWidth - 58, iPhoneXSeries ? KScreenHeight - 20 - 50 - 8 : KScreenHeight - 3 - 50, 58 + 50, 50) withCorner:25];
                
                [guideViewBlock initViewWithPageName:TTGuideViewPage_Room];
            };
            
            guideView.dismissingBlock = ^{
                // 是否是新用户
                [GetCore(MissionCore) requestMissionNewUser];
            };
            
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }
    }

}

@end
