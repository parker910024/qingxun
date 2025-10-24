//
//  GuildHallManagerInfo.m
//  AFNetworking
//
//  Created by lee on 2019/1/16.
//

#import "GuildHallManagerInfo.h"

@implementation GuildHallManagerInfo

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}
@end
