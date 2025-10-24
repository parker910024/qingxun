//
//  Target_TTPublicChatroomMoudle.m
//  TuTu
//
//  Created by 卫明 on 2018/11/9.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "Target_TTPublicChatroomMoudle.h"
#import "TTHeadLineContainerController.h"

@implementation Target_TTPublicChatroomMoudle

- (UIViewController *)Action_TTHeadLineVireController:(NSDictionary *)params {
    TTHeadLineContainerController *headLineVC = [[TTHeadLineContainerController alloc]init];
    headLineVC.currentPage = [[params objectForKey:@"page"] integerValue];
    return headLineVC;
}

@end
