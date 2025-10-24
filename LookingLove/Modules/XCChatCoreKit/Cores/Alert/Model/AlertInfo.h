//
//  AlertInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertInfo : NSObject

@property (copy, nonatomic) NSString *actName;
@property (assign, nonatomic) NSInteger actId;
@property (assign ,nonatomic) BOOL alertWin;
@property (copy, nonatomic) NSString *alertWinPic;
@property (copy, nonatomic) NSString *alertWinLoc;
@property (copy, nonatomic) NSString *skipType;
@property (copy, nonatomic) NSString *skipUrl;
@property (copy, nonatomic) NSString *actAlertVersion;



@end
