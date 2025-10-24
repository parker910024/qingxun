//
//  Target_TTHomeMoudle.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "Target_TTHomeMoudle.h"

#import "TTHomeViewController.h"
#import "TTSearchRoomViewController.h"
#import "TTHomeFamilyViewController.h"

@implementation Target_TTHomeMoudle
- (UIViewController *)Action_TTHomeViewController {
    TTHomeViewController *homeVC = [[TTHomeViewController alloc] init];
    return homeVC;
}

- (UIViewController *)Action_TTHomeFamilyViewController {
    TTHomeFamilyViewController *familyVC = [[TTHomeFamilyViewController alloc] init];
    return familyVC;
}

- (UIViewController *)Action_TTSearchRoomViewController:(NSDictionary *)dict {
    TTSearchRoomViewController *searchVC = [[TTSearchRoomViewController alloc] init];
    if ([dict.allKeys containsObject:@"isPresent"]) {
        searchVC.isPresent = dict[@"isPresent"];
    }
    
    if ([dict.allKeys containsObject:@"isInvite"]) {
        searchVC.isInvite = dict[@"isInvite"];
    }
    
    if ([dict.allKeys containsObject:@"isHallSearch"]) {
        searchVC.isHallSearch = dict[@"isHallSearch"];
    }
    
    //允许显示历史记录
    if ([dict.allKeys containsObject:@"showHistoryRecord"]) {
        searchVC.showHistoryRecord = [dict[@"showHistoryRecord"] boolValue];
    }
    
    if ([dict.allKeys containsObject:@"block"]) {
        searchVC.searchPresentDidClickBlock = dict[@"block"];
    }
    
    if ([dict.allKeys containsObject:@"dismissBlock"]) {
        searchVC.dismissAndDidClickPersonBlcok = dict[@"dismissBlock"];
    }
    
    if ([dict.allKeys containsObject:@"enterRoomBlock"]) {
        searchVC.enterRoomHandler = dict[@"enterRoomBlock"];
    }
    
    return searchVC;
}
@end
