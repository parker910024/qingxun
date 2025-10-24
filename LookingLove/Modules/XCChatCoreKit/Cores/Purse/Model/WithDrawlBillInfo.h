//
//  WithDrawlBillInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/20.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface WithDrawlBillInfo : BaseObject

@property (assign, nonatomic) NSInteger diamondNum;
@property (strong, nonatomic) NSString *money;
@property (assign, nonatomic) double recordTime;
//@property (assign, nonatomic) NSInteger gainType;
@end
