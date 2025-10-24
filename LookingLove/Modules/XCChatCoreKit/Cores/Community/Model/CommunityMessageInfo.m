//
//  CommunityMessageInfo.m
//  AFNetworking
//
//  Created by zoey on 2019/2/28.
//

#import "CommunityMessageInfo.h"

@implementation CommunityMessageInfo

- (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"id":@"ID"};
}


- (NSDate *)createDate {
    if (!_createDate) {
        _createDate = [[NSDate alloc] initWithTimeIntervalSince1970:self.createTime.floatValue/1000];
    }
    return _createDate;
}

@end
