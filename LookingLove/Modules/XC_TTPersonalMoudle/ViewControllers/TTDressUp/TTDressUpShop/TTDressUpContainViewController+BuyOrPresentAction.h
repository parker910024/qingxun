//
//  TTDressUpContainViewController+BuyOrPresentAction.h
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDressUpContainViewController.h"

@class UserInfo,UserCar,UserHeadWear;
@interface TTDressUpContainViewController (BuyOrPresentAction)
//赠送
- (void)presenterActionWithUserInfo:(UserInfo *)userinfo car:(UserCar *)car headwear:(UserHeadWear *)headwear isPresent:(BOOL)isPresent;
//购买或是 赠送
- (void)ensurePresenter:(UserInfo *)info isPresent:(BOOL)isPresent car:(UserCar *)car headwear:(UserHeadWear *)headwear;
//选择赠送
- (void)selectPresenterPersonWithCar:(UserCar *)car Headwear:(UserHeadWear *)hearwear;

@end
