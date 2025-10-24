//
//  TTMineHeadwearDressUpViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMineHeadwearDressUpViewController.h"
//model
#import "UserHeadWear.h"
//core
#import "HeadWearCore.h"
#import "AuthCore.h"
#import "TTMineGameTagCore.h"

//cate
#import "UIView+XCToast.h"
//t
#import "XCTheme.h"

@interface TTMineHeadwearDressUpViewController ()

@end

@implementation TTMineHeadwearDressUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)reloadData {
    [GetCore(HeadWearCore) requestUserHeadwear:UserHeadwearPlaceTypeHeadwearPort uid:[GetCore(AuthCore)getUid]];
}

//使用头饰
- (void)mineUseHeadwear:(UserHeadWear *)headwear {
    if (headwear.status == Headwear_Status_ok) {
        [GetCore(HeadWearCore) userHeadwearByHeadwearId:headwear.headwearId];
    }
}
//取消使用头饰
- (void)mineCancelUseHeadwear {
    [GetCore(HeadWearCore) userHeadwearByHeadwearId:@"0"];
}

#pragma mark - UserCoreClient
- (void)onUseHeadwearSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNeedRefreshUserInfoNotification object:nil];
    [self reloadData];
    [GetCore(TTMineGameTagCore) userUpdateHeadWear];
}

- (void)onUseHeadwearFailth:(NSString *)message {
    
}

//获取头饰库列表成功
- (void)onGetOwnHeadwearList:(UserHeadwearPlaceType)placeType success:(NSArray *)list{
    if (placeType != UserHeadwearPlaceTypeHeadwearPort) {
        return;
    }
    if (list.count > 0) {
        self.data = [list mutableCopy];
        [self.tableView hideToastView];
    }else {
        [self.tableView showEmptyContentToastWithTitle:@"亲爱的用户，你还没有头饰噢！" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    }
    [self.tableView reloadData];
}
//获取头饰库列表失败
- (void)onGetOwnHeadwearList:(UserHeadwearPlaceType)placeType failth:(NSString *)message {
    if (placeType != UserHeadwearPlaceTypeHeadwearPort) {
        return;
    }
    [self.tableView showEmptyContentToastWithTitle:@"亲爱的用户，你还没有头饰噢！" andImage:[UIImage imageNamed:@"common_noData_empty"]];
}


@end
