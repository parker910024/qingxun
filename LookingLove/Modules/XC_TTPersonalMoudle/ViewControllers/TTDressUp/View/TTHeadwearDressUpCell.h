//
//  TTHeadwearDressUpCell.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDressUpUIClient.h"

@interface TTHeadwearDressUpCell : UICollectionViewCell
//需要在 headwear 赋值前设置
@property (nonatomic, strong) UserHeadWear *headwear;//头饰
@property (nonatomic, assign) BOOL isSelect;//
@end
