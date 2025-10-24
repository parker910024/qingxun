//
//  CTInputAtManager.h
//  CTKit
//
//  Created by chris on 2016/12/8.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CTInputAtStartChar  @"@"
#define CTInputAtEndChar    @"\u2004"

@interface CTInputAtItem : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,assign) NSRange range;

@end

@interface CTInputAtCache : NSObject

- (NSArray *)allAtUid:(NSString *)sendText;

- (void)clean;

- (void)addAtItem:(CTInputAtItem *)item;

- (CTInputAtItem *)item:(NSString *)name;

- (CTInputAtItem *)removeName:(NSString *)name;

@end
