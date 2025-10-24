//
//  XCApplicationSharement.h
//  BberryCore
//
//  Created by gzlx on 2018/6/13.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "Attachment.h"
#import "P2PInteractiveAttachment.h"

@interface XCApplicationSharement : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>

@property (nonatomic, strong) id infor;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * actionName;
@property (nonatomic, strong) NSString * routerValue;
@property (nonatomic, assign) P2PInteractive_SkipType routerType;



@end
