//
//  MSHomeRecommendData.m
//  AFNetworking
//
//  Created by lvjunhang on 2018/12/21.
//

#import "MSHomeRecommendData.h"
#import "MSHomeRecommendDetailData.h"

@implementation MSHomeRecommendData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data" : MSHomeRecommendDetailData.class,
             };
}
@end
