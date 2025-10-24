//

//  ZXCInfo.h
//
//  BberryCore
//
//  Created by gzlx on 2017/7/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface ZXCInfo : BaseObject



@property (copy, nonatomic)NSString *uid;
@property (copy, nonatomic)NSString *zxcAccount;
@property (copy, nonatomic)NSString *zxcAccountName;
@property (copy, nonatomic)NSString *diamondNum;
@property (assign, nonatomic) BOOL notBoundPhone;
@end
