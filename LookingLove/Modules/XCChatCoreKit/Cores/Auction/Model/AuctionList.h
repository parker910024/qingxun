//
//  AuctionList.h
//  BberryCore
//
//  Created by gzlx on 2017/8/17.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfo.h"
#import "BaseObject.h"


//"roomUid":900502,
//"price":120,
//"uid":900405,
//"prodId":900182,
//"nick":"Simon",
//"avatar":"https://nos.netease.com/nim/NDI3OTA4NQ==/bmltYV82NTUwMTQzMDRfMTUwMDU2MDQ0NzU0MV83NmUyYmIwNC0xM2U5LTRhYTEtYTcxMy1kMjg4N2Y0MThlYjM=",
//"gender":1

@interface AuctionList : BaseObject

@property (copy, nonatomic) NSString *roomUid;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *prodId;
@property (copy, nonatomic) NSString *nick;
@property (copy, nonatomic) NSString *avatar;
@property (assign, nonatomic) UserGender gender;

@end
