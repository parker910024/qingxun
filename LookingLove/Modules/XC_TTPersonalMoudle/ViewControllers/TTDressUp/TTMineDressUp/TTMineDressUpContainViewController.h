//
//  TTMineDressUpContainViewController.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TTDressUpContainViewController.h"
@interface TTMineDressUpContainViewController : BaseUIViewController
@property (nonatomic, assign) int place;//0.头饰  1.座驾
@property (nonatomic, weak) TTDressUpContainViewController  *presentVC;//
@end
