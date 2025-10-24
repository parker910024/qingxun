//
//  LayoutParams.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "P2PInteractiveAttachment.h"

@interface LayoutParams : BaseObject
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *fontSize;
@property (strong, nonatomic) NSString *fontColor;
@property (nonatomic,assign) BOOL fontBold;
@property (assign, nonatomic) P2PInteractive_SkipType routertype;
@property (strong, nonatomic) NSString *routerValue;
@end
