//
//  GiftReceiveInfo.h
//  BberryCore
//
//  Created by chenran on 2017/7/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "GiftInfo.h"

@interface GiftReceiveInfo : BaseObject

@property(nonatomic, assign)UserID uid;
@property(nonatomic, assign)UserID targetUid;
@property(nonatomic, strong)GiftInfo *giftInfo;
@property(nonatomic, assign)NSInteger giftId;
@property(nonatomic, strong)NSString *nick;
@property(nonatomic, strong)NSString *avatar;
@property (assign, nonatomic) NSInteger giftNum;
@property (copy, nonatomic) NSString *targetAvatar;
@property (copy, nonatomic) NSString *targetNick;
@property (nonatomic, strong) GiftInfo  *gift;//
@end
