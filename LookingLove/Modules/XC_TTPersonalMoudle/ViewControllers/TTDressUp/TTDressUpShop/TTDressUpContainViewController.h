//
//  TTDressUpContainViewController.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

//view
#import "TTDressUpContainHeadView.h"
//model
#import "UserInfo.h"

@interface TTDressUpContainViewController : BaseUIViewController
/** 座驾商城上面的header*/
@property (nonatomic, strong) TTDressUpContainHeadView  *headView;//

@property (nonatomic, assign) int place;//0.头饰 1 座驾
@property (nonatomic, assign) UserID  userID;//用户id

@property (nonatomic, strong) UserInfo  *userInfo;//

@end
