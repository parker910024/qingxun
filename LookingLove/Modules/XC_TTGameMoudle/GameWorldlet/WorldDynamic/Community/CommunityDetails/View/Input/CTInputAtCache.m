//
//  CTInputAtCache.m
//  CTKit
//
//  Created by chris on 2016/12/8.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "CTInputAtCache.h"

@interface CTInputAtCache()

@property (nonatomic,strong) NSMutableArray *items;

@end

@implementation CTInputAtCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allAtUid:(NSString *)sendText;
{
    NSArray *names = [self matchString:sendText];
    NSMutableArray *uids = [[NSMutableArray alloc] init];
    for (NSString *name in names) {
        CTInputAtItem *item = [self item:name];
        if (item)
        {
            [uids addObject:item.uid];
        }
    }
    return [NSArray arrayWithArray:uids];
}


- (void)clean
{
    [self.items removeAllObjects];
}

- (void)addAtItem:(CTInputAtItem *)item
{
    [_items addObject:item];
}

- (CTInputAtItem *)item:(NSString *)name
{    
    __block CTInputAtItem *item;
    [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CTInputAtItem *object = obj;
        if ([object.name isEqualToString:name])
        {
            item = object;
            *stop = YES;
        }
    }];
    return item;
}

- (CTInputAtItem *)removeName:(NSString *)name
{
    __block CTInputAtItem *item;
    [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CTInputAtItem *object = obj;
        if ([object.name isEqualToString:name]) {
            item = object;
            *stop = YES;
        }
    }];
    if (item) {
        [_items removeObject:item];
    }
    return item;
}

- (NSArray *)matchString:(NSString *)sendText
{
    NSString *pattern = [NSString stringWithFormat:@"%@([^%@]+)%@",CTInputAtStartChar,CTInputAtEndChar,CTInputAtEndChar];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *results = [regex matchesInString:sendText options:0 range:NSMakeRange(0, sendText.length)];
    NSMutableArray *matchs = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *result in results) {
        NSString *name = [sendText substringWithRange:result.range];
        name = [name substringFromIndex:1];
        name = [name substringToIndex:name.length -1];
        [matchs addObject:name];
    }
    return matchs;
}


@end


@implementation CTInputAtItem

@end
