//
//  CoreManager.m


#import <AdSupport/AdSupport.h>

#import "CoreManager.h"
#import "CoreFactory.h"

@interface CoreManager()

@end

@implementation CoreManager

+ (void)initCore{
    
   
}

#pragma mark - core
+ (id)getCore:(Class)cls{
    
    return [CoreFactory getCoreFromClass:cls];
}

+ (id)getCoreFromProtocol:(Protocol *)protocol{
    
    return [CoreFactory getCoreFromProtocol:protocol];
}

+ (void)removeCore:(Class)cls{
    [CoreFactory removeCoreByClass:cls];
}

#pragma mark - client
+ (void)addClient:(id)obj for:(Protocol *)protocol{
    
    [[CommonServiceCenter defaultCenter] addServiceClient:obj withKey:protocol];
}

+ (void)removeClient:(id)obj for:(Protocol *)protocol{
    
    [[CommonServiceCenter defaultCenter] removeServiceClient:obj withKey:protocol];
}

+ (void)removeClient:(id)obj{
    
    [[CommonServiceCenter defaultCenter] removeServiceClient:obj];
}

#pragma mark - provide
+ (void)registServiceProvide:(id)provide forProtocol:(Protocol *)protocol {
  
    [[CommonServiceCenter defaultCenter] registServiceProvide:provide forProtocol:protocol];
}

+ (id)serviceProvideForProtocol:(Protocol *)protocol {
    return [[CommonServiceCenter defaultCenter] serviceProvideForProtocol:protocol];
}


@end

