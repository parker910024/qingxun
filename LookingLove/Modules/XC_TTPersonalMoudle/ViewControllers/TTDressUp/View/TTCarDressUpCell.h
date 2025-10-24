//
//  TTCarDressUpCell.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDressUpUIClient.h"

@interface TTCarDressUpCell : UICollectionViewCell
@property (nonatomic, strong) UserCar *car;
@property (nonatomic, assign) BOOL isSelected;//
@property (nonatomic, assign) BOOL isPerson;//是否 个人主页
@end
