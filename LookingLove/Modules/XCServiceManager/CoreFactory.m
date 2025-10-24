//
//  CoreFactory.m


#import "CoreFactory.h"

static NSMapTable *coreClassMap() {
    static NSMapTable *table = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    });
    return table;
}

static NSMapTable *coresMap() {
    static NSMapTable *table = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    });
    return table;
}

@implementation CoreFactory

#pragma mark - CoreClass

+ (void)registerClass:(Class)cls forProtocol:(Protocol *)protocol
{
    if (![cls conformsToProtocol:protocol]) {
        NSParameterAssert(0);   // class未实现protocol
        return;
    }
    
    [coreClassMap() setObject:cls forKey:protocol];
}

+ (Class)classForProtocol:(Protocol *)protocol
{
    return [coreClassMap() objectForKey:protocol];
}

+ (BOOL)hasRegisteredProtocol:(Protocol *)protocol
{
    NSParameterAssert(protocol);
    return [coreClassMap() objectForKey:protocol] != nil;
}



#pragma mark - Core

+ (id)getCoreFromClass:(Class)cls
{
    id obj = [coresMap() objectForKey:cls];
    if (nil == obj) {
        obj = [[cls alloc] init];
        [coresMap() setObject:obj forKey:cls];
    }
    
    return obj;
}
+ (void)removeCoreByClass:(Class)cls{
    id obj = [coresMap() objectForKey:cls];
    if (obj) {
        [coresMap() removeObjectForKey:cls];
    }
}

+ (id)getCoreFromProtocol:(Protocol *)protocol
{
    id obj;
    Class impClass = [coreClassMap() objectForKey:protocol];
    if (impClass) {
        obj = [coresMap() objectForKey:impClass];
        if (nil == obj) {
            obj = [[impClass alloc] init];
            [coresMap() setObject:obj forKey:impClass];
        }
    }
    return obj;
}

@end
