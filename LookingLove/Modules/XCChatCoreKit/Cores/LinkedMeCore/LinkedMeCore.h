//
//  LinkedMeCore.h
//  BberryCore
//
//  Created by gzlx on 2017/7/17.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "LinkMEModel.h"

@interface LinkedMeCore : BaseCore

@property (strong, nonatomic) LinkMEModel *linkme;
@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) NSString *H5URL;
@property (strong, nonatomic) NSString *linkedmeChannel;

- (BOOL)judgeDeepLinkWith:(NSURL *)url;
- (BOOL)judgeDeepLinkWithUniversal:(NSUserActivity *)userActivity;
- (void)initLinkedMEWithLaunchOptions:(NSDictionary *)launchOptions;

@end
