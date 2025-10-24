//
//  TTMineCarDressUpViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMineCarDressUpViewController.h"
//view
#import "TTMineDressUpCell.h"
//core
#import "CarCore.h"
#import "AuthCore.h"
#import "UserCoreClient.h"

//model
#import "UserCar.h"
//cate
#import "UIView+XCToast.h"
//tool
#import "XCTheme.h"

@interface TTMineCarDressUpViewController ()

@end

@implementation TTMineCarDressUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)reloadData {
    [GetCore(CarCore) requestUserCar:UserCarPlaceTypeCarPort uid:[GetCore(AuthCore)getUid]];
}
//使用座驾
- (void)mineUseCar:(UserCar *)car {
    if (car.status == Car_Status_ok) {
        [GetCore(CarCore)userCarByCarId:car.carID];
    }
    
}
//取消使用座驾
- (void)mineCancelCar {
    [GetCore(CarCore)userCarByCarId:@"0"];
}

#pragma mark - UserCoreClient

- (void)onUseCarSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNeedRefreshUserInfoNotification object:nil];
    [self reloadData];
}

- (void)onUseCarFailth:(NSString *)message {
    
}

//获取车库座驾列表成功
- (void)onGetOwnCarList:(UserCarPlaceType)placeType success:(NSArray *)list {
    
    if (placeType != UserCarPlaceTypeCarPort) {
        return;
    }
    if (list.count > 0) {
        self.data = [list mutableCopy];
        [self.tableView hideToastView];
    }else {
        [self.tableView showEmptyContentToastWithTitle:@"亲爱的用户，你还没有座驾噢！" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    }
    [self.tableView reloadData];
}

//获取车库座驾列表失败
- (void)onGetOwnCarList:(UserCarPlaceType)placeType failth:(NSString *)message {
    if (placeType != UserCarPlaceTypeCarPort) {
        return;
    }
    [self.tableView showEmptyContentToastWithTitle:@"亲爱的用户，你还没有座驾噢！" andImage:[UIImage imageNamed:@"common_noData_empty"]];
}


@end
