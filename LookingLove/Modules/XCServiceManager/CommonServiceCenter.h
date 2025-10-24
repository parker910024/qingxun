//
//  ServiceCenter.h
//  
//

#import <Foundation/Foundation.h>

#if defined(HAS_COMMON_LOG) && HAS_COMMON_LOG

#import "YYLogger.h"
#define LOG_FRAMEWORK_DEBUG(format, arg...) [YYLogger debug:TBase message:format, ##arg]
#define LOG_FRAMEWORK_INFO(format, arg...) [YYLogger info:TBase message:format, ##arg]
#define LOG_FRAMEWORK_WARN(format, arg...) [YYLogger warn:TBase message:format, ##arg]
#define LOG_FRAMEWORK_ERROR(format, arg...) [YYLogger error:TBase message:format, ##arg]

#else

#define LOG_FRAMEWORK(level, format, arg...) { NSString *s = [NSString stringWithFormat:format, ##arg]; NSLog(@"[Framework][%@] %@",  level, s);}
#define LOG_FRAMEWORK_DEBUG(format, arg...) LOG_FRAMEWORK(@"Debug", format, ##arg)
#define LOG_FRAMEWORK_INFO(format, arg...) LOG_FRAMEWORK(@"Info", format, ##arg)
#define LOG_FRAMEWORK_WARN(format, arg...) LOG_FRAMEWORK(@"Warn", format, ##arg)
#define LOG_FRAMEWORK_ERROR(format, arg...) LOG_FRAMEWORK(@"Error", format, ##arg)

#endif



//#define GET_SERVICE(obj) (obj *)[[CommonServiceCenter defaultCenter] getService:[obj class]]

//#define REMOVE_SERVICE(obj) [[CommonServiceCenter defaultCenter] removeService:[obj class]]


#define NOTIFY_SERVICE_CLIENT(protocolName, selector, func) \
{ \
NSAssert(![[CommonServiceCenter defaultCenter] isNotifyingClientsWithKey:@protocol(protocolName)], @"recusively call the same service clients."); \
[[CommonServiceCenter defaultCenter] setNotifyingClientsWithKey:@protocol(protocolName) isNotifying:YES]; \
NSArray *__clients__ = [[CommonServiceCenter defaultCenter] serviceClientsWithKey:@protocol(protocolName)]; \
for (CommonServiceClient *client in __clients__) \
{ \
id obj = client.object; \
if ([obj respondsToSelector:selector]) \
{ \
[obj func]; \
} \
} \
[[CommonServiceCenter defaultCenter] setNotifyingClientsWithKey:@protocol(protocolName) isNotifying:NO]; \
}



typedef Protocol * CommonServiceClientKey;


// 持久对象中心。 用来存放为全局服务的对象。
@interface CommonServiceCenter : NSObject

+ (CommonServiceCenter *)defaultCenter;

//- (id)getService:(Class) cls;
//- (void)removeService:(Class) cls;

//获取当前service的所有clients
- (NSArray *)serviceClientsWithKey:(CommonServiceClientKey)key;

//校验是否在执行protocolName的selector
- (void)setNotifyingClientsWithKey:(CommonServiceClientKey)key isNotifying:(BOOL)isNotifying;
- (BOOL)isNotifyingClientsWithKey:(CommonServiceClientKey)key;

//client
- (void)addServiceClient:(id)client withKey:(CommonServiceClientKey)key;
- (void)removeServiceClient:(id)client withKey:(CommonServiceClientKey)key;
- (void)removeServiceClient:(id)client;

//provide
- (void)registServiceProvide:(id)provide forProtocol:(CommonServiceClientKey)key;
- (id)serviceProvideForProtocol:(CommonServiceClientKey)key;

@end



// 为了client不被增加引用计数，引入一个包装类。
@interface CommonServiceClient : NSObject

@property (nonatomic, weak) id object;

- (id)initWithObject:(id)object;

@end


