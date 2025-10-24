//
//  TTHomeRecommendData.m
//  AFNetworking
//
//  Created by lvjunhang on 2018/11/13.
//

#import "TTHomeRecommendData.h"
#import "TTHomeRecommendDetailData.h"

@implementation TTHomeRecommendData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data" : TTHomeRecommendDetailData.class,
             };
}
@end
