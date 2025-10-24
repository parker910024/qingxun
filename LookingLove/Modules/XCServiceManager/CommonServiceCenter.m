//
//  ServiceCenter.m
//  
//
//  //

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CommonServiceCenter.h"

#import <objc/runtime.h>

#define MULTI_THREAD_SAFE       0

static CommonServiceCenter *_serviceCenter = nil;

@interface CommonServiceCenter ()
{
//    NSMutableDictionary *_serviceDictionary;
    /*记录所有实现了client的实体
     {
        APNSCoreClient =     (
            "<CommonServiceClient: 0x608000018210>",
            "<CommonServiceClient: 0x6000000187d0>"
        );
        ActivityCoreClient =     (
            "<CommonServiceClient: 0x600000017560>"
        );
     }
     */
    NSMutableDictionary *_clientDictionary;
    //用于纪录当前正在遍历中的service
    NSMutableDictionary *_notifyingKeys;
    //存放组件化的provide
    NSMutableDictionary *_searviceProvideSource;
}

@end

@implementation CommonServiceCenter
#pragma mark - life cycle
- (id)init{
    
	if(self = [super init])	{
        
		LOG_FRAMEWORK_DEBUG(@"Create service center");
//        _serviceDictionary = [[NSMutableDictionary alloc] init];
        
        _clientDictionary = [[NSMutableDictionary alloc] init];
        _notifyingKeys = [[NSMutableDictionary alloc] init];
        _searviceProvideSource = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc{
    
//    if (_serviceDictionary != nil)    {
//
//        LOG_FRAMEWORK_DEBUG(@"dealloc service center");
//#if MULTI_THREAD_SAFE
//        @synchronized(self)
//#endif
//        {
//            [_serviceDictionary removeAllObjects];
//        }
//    }
//
//    _serviceCenter = nil;
}

+ (CommonServiceCenter *)defaultCenter{
    
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serviceCenter = [[CommonServiceCenter alloc] init];
    });
	return _serviceCenter;
}


#pragma mark - service
//- (id)getService:(Class)cls{
//
//    NSString *key = [NSString stringWithUTF8String:class_getName(cls)];
//
//    id obj = nil;
//#if MULTI_THREAD_SAFE
//    @synchronized(self)
//#endif
//    {
//        obj = [_serviceDictionary objectForKey:key];
//
//        if (obj == nil){
//            // 将init放在alloc之后， 防止在init里面做了啥有影响的东西。
//            obj = [[cls alloc] init];
//
//            [_serviceDictionary setObject:obj forKey:key];
//
//            LOG_FRAMEWORK_DEBUG(@"Create service object: %@", obj);
//        }
//    }
//
//    return obj;
//}
//
//- (void)removeService:(Class) cls{
//
//    NSString *key = [NSString stringWithUTF8String:class_getName(cls)];
//#if MULTI_THREAD_SAFE
//    @synchronized(self)
//#endif
//    {
//        LOG_FRAMEWORK_DEBUG(@"Remove service object %@", key);
//        [_serviceDictionary removeObjectForKey:key];
//    }
//}


#pragma mark - client
//获取当前service的所有clients
- (NSArray *)serviceClientsWithKey:(CommonServiceClientKey)key{
    
    NSMutableArray *result = [self _getClientsWithKey:key];
    
    return [NSArray arrayWithArray:result];
}
//给指定service注册client
- (void)addServiceClient:(id)client withKey:(CommonServiceClientKey)key{
    
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        LOG_FRAMEWORK_ERROR(@"add service client protocol for %p for key %@ in the other thread", client,NSStringFromProtocol(key));
    }
    
    if (client){
        //client实现了key?
        if (![client conformsToProtocol:key]){
            
            LOG_FRAMEWORK_ERROR(@"client doesn’t conforms to protocol: %@", NSStringFromProtocol(key));
        }
#if MULTI_THREAD_SAFE
        @synchronized(self)
#endif
        {
            NSMutableArray *clients = [self _getClientsWithKey:key];
            //判断该obj是否已经注册存在
            for (CommonServiceClient *obj in clients) {
                if (obj.object == client){
                    return;
                }
            }
            LOG_FRAMEWORK_DEBUG(@"add client %@ for protocol %@", client, NSStringFromProtocol(key));
            //obj还没有注册，则包装成CommonServiceClient
            [clients addObject:[[CommonServiceClient alloc] initWithObject:client]];
        }
    }
}
//移除service指定的client
- (void)removeServiceClient:(id)client withKey:(CommonServiceClientKey)key{
    
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        LOG_FRAMEWORK_ERROR(@"remove service client protocol for %p for key %@ in the other thread", client,NSStringFromProtocol(key));
    }
    
    if (client){
        
#if MULTI_THREAD_SAFE
        @synchronized(self)
#endif
        {
            NSMutableArray *clients = [self _getClientsWithKey:key];
            CommonServiceClient *found = nil;
            for (CommonServiceClient *clientObj in clients){
                
                if (clientObj.object == client){
                    
                    found = clientObj;
                    break;
                }
            }
            if (found){
                
                LOG_FRAMEWORK_DEBUG(@"remove client %p for protocol %@", client, NSStringFromProtocol(key));
                found.object = nil;
                [clients removeObject:found];
            }
            
            //检查为空的，因为dealloc的时候weak已经被置空
            NSArray *temp = [NSArray arrayWithArray:clients];
            for (CommonServiceClient *clientObj in temp){
                
                if (clientObj && clientObj.object == nil){
                    
                    [clients removeObject:clientObj];
                }
            }
        }
    }
}
//移除service所有client
- (void)removeServiceClient:(id)client{
    
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        LOG_FRAMEWORK_ERROR(@"remove service client protocol for %p in the other thread", client);
    }
    LOG_FRAMEWORK_DEBUG(@"remove all client protocol for %p", client);
    if (client)
    {
#if MULTI_THREAD_SAFE
        @synchronized(self)
#endif
        {
            for (NSMutableArray *clients in [_clientDictionary allValues]){
                
                CommonServiceClient *found = nil;
                for (CommonServiceClient *clientObj in clients){
                    
                    if (clientObj.object == client){
                        
                        found = clientObj;
                        break;
                    }
                }
                if (found){
                    
                    found.object = nil;
                    [clients removeObject:found];
                }
                
                //检查为空的，因为dealloc的时候weak已经被置空(你好，黑科技)
                NSArray *temp = [NSArray arrayWithArray:clients];
                for (CommonServiceClient *clientObj in temp){
                    
                    if (clientObj && clientObj.object == nil){
                        
                        [clients removeObject:clientObj];
                    }
                }
            }
        }
    }
}


#pragma mark - check
//保存当前正在遍历的service
- (void)setNotifyingClientsWithKey:(CommonServiceClientKey)key isNotifying:(BOOL)isNotifying{
    
    NSString *strKey = NSStringFromProtocol(key);
    if (isNotifying)
        [_notifyingKeys setObject:strKey forKey:strKey];
    else
        [_notifyingKeys removeObjectForKey:strKey];
}
//判断当前的service是否正在遍历
- (BOOL)isNotifyingClientsWithKey:(CommonServiceClientKey)key{
    
    NSString *strKey = NSStringFromProtocol(key);
    return ([_notifyingKeys objectForKey:strKey] != nil);
}


#pragma mark - provide
- (void)registServiceProvide:(id)provide forProtocol:(CommonServiceClientKey)key {
    if (provide == nil || key == nil) {
        NSParameterAssert(@"provide or key 不能为空");
        return;
    }
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        LOG_FRAMEWORK_ERROR(@"regist service provide  %p for key %@ in the other thread", provide,NSStringFromProtocol(key));
    }
    
    if (provide){
        //provide实现了key?
        if (![provide conformsToProtocol:key]){
            
            LOG_FRAMEWORK_ERROR(@"provide doesn’t conforms to protocol: %@", NSStringFromProtocol(key));
        }
#if MULTI_THREAD_SAFE
        @synchronized(self)
#endif
        {
            //判断该provide是否已经注册存在
            CommonServiceClient *provideObj = [_searviceProvideSource objectForKey:NSStringFromProtocol(key)];
            if (provideObj){
                NSParameterAssert(@"provide 不能重复添加");
                return;
            }
            LOG_FRAMEWORK_DEBUG(@"add provide %@ for protocol %@", provide, NSStringFromProtocol(key));
            //provide还没有注册，则包装成CommonServiceClient
            [_searviceProvideSource setObject:provide forKey:NSStringFromProtocol(key)];
        }
    }
}


- (id)serviceProvideForProtocol:(CommonServiceClientKey)key{
    
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        LOG_FRAMEWORK_ERROR(@"get provide for key %@ in the other thread",NSStringFromProtocol(key));
    }
    
    NSString *strKey = NSStringFromProtocol(key);
    id provide = nil;
#if MULTI_THREAD_SAFE
    @synchronized(self)
#endif
    {
        provide = [_searviceProvideSource objectForKey:strKey];
    }
    return provide;
}

#pragma mark - private method
- (NSMutableArray *)_getClientsWithKey:(CommonServiceClientKey)key{
    
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        LOG_FRAMEWORK_ERROR(@"get client protocol for key %@ in the other thread",NSStringFromProtocol(key));
    }
    
    NSString *strKey = NSStringFromProtocol(key);
    NSMutableArray *clients = nil;
#if MULTI_THREAD_SAFE
    @synchronized(self)
#endif
    {
        clients = [_clientDictionary objectForKey:strKey];
        //不存在则创建一个数组，key作为Key放入_clientDictionary字典中
        if (!clients){
            
            clients = [[NSMutableArray alloc] init];
            [_clientDictionary setObject:clients forKey:strKey];
        }
    }
    return clients;
}


@end




#pragma mark - CommonServiceClient

@implementation CommonServiceClient

- (id)initWithObject:(id)object{
    
    if (self = [super init]) {
        self.object = object;
    }
    return self;
}
@end


