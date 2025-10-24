//
//  TabBarConfig.m
//  LookingLove
//
//  Created by lvjunhang on 2020/12/4.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TabBarConfig.h"

@implementation TabBarConfigItem

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [self yy_modelEncodeWithCoder:coder];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    return [self yy_modelInitWithCoder:coder];
}

@end

@implementation TabBarConfig

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [self yy_modelEncodeWithCoder:coder];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    return [self yy_modelInitWithCoder:coder];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tabVos" : [TabBarConfigItem class],
             };
}

@end
