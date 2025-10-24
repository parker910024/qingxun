//
//  MessageLayout.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "LayoutParams.h"

@interface MessageLayout : BaseObject
@property (strong, nonatomic) LayoutParams *title;
@property (strong, nonatomic) LayoutParams *time;
@property (strong, nonatomic) NSArray<LayoutParams *> *contents;
@end
