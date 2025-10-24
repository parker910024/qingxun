//
//  BaseObject.m
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "BaseObject.h"
#import <YYModel/YYModel.h>

@implementation BaseObject

+ (NSArray *)modelsWithArray:(id)json{
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}

+ (instancetype)modelDictionary:(NSDictionary *)dictionary{
    
    return [self yy_modelWithDictionary:dictionary];
}

+ (instancetype)modelWithJSON:(id)json{
    
    return [self yy_modelWithJSON:json];
}

+ (NSDictionary<NSString *, id> *) modelCustomPropertyMapper {
    NSMutableDictionary<NSString *, id> * mapDictionary = [NSMutableDictionary dictionary];
    Class clazz = self;
    while ([clazz isSubclassOfClass:BaseObject.class]) {
        [mapDictionary addEntriesFromDictionary:[clazz propertyToKeyPair]];
        clazz = [clazz superclass];
    }
    return mapDictionary;
}

+ (NSDictionary<NSString *, id> *) propertyToKeyPair {
    return nil;
}

+ (NSDictionary<NSString *, id> *) modelContainerPropertyGenericClass {
    NSMutableDictionary<NSString *, id> * mapDictionary = [NSMutableDictionary dictionary];
    Class clazz = self;
    while ([clazz isSubclassOfClass:BaseObject.class]) {
        [mapDictionary addEntriesFromDictionary:[clazz propertyToClassPair]];
        clazz = [clazz superclass];
    }
    return mapDictionary;
}

+ (NSDictionary<NSString *, id> *) propertyToClassPair {
    return nil;
}

- (NSDictionary *)model2dictionary{
    id jsonData = [self yy_modelToJSONObject];
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)jsonData;
    }else{
        return nil;
    }
}

- (NSString *)description {
    return [self yy_modelDescription];
}


@end
