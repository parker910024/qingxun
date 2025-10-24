//
//  TTDressUpUIClient.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, TTDressUpPlaceType) {
    TTDressUpPlaceType_HeadwearShop = 0,
    TTDressUpPlaceType_HeadwearGarage,
    TTDressUpPlaceType_CarShop,
    TTDressUpPlaceType_CarGarage
};

@class UserCar,UserHeadWear,UserInfo;

@protocol TTDressUpUIClient<NSObject>

@optional

// 购买座驾失败
- (void)buyCarFailth:(UserCar *)car error:(NSError *)error;
//购买头饰失败
- (void)buyHeadwearFailth:(UserHeadWear *)headwear error:(NSError *)error;

//商城

//获取 限定 装扮方式
- (void)shopTogetLimitDressUpAdress:(NSString *)adress;
//选择 座驾
- (void)shopSelectCar:(UserCar *)userCar;
//选择 头饰
- (void)shopSelectHeadwear:(UserHeadWear *)headwear;
//购买 座驾
- (void)shopBuyCar:(UserCar *)userCar place:(TTDressUpPlaceType)type;
//购买 头饰
- (void)shopBuyHeadwear:(UserHeadWear *)headwear place:(TTDressUpPlaceType)type;
//预览座驾
- (void)showCar:(UserCar *)userCar;
// 购买头饰成功
- (void)buyHeadwearSuccess:(UserHeadWear *)headwear uid:(long long)uid;
// 购买座驾成功
- (void)buyCarSuccess:(UserCar *)userCar uid:(long long)uid;

// 赠送头饰座驾
- (void)shopPresentCar:(UserCar *)userCar headwear:(UserHeadWear *)headwear nick:(NSString *)nick userid:(long long)uid;
// 底部 操作 面板 赠送头饰座驾
- (void)shopBottomPresentCar:(UserCar *)userCar headwear:(UserHeadWear *)headwear;

//我的装扮

//使用头饰
- (void)mineUseHeadwear:(UserHeadWear *)headwear;
//取消使用头饰
- (void)mineCancelUseHeadwear;
//使用座驾
- (void)mineUseCar:(UserCar *)car;
//取消使用座驾
- (void)mineCancelCar;



@end
