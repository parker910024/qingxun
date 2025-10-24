//
//  CoreFactory.h


#import <Foundation/Foundation.h>

@interface CoreFactory : NSObject

+ (void)registerClass:(Class)cls forProtocol:(Protocol *)protocol;
+ (Class)classForProtocol:(Protocol *)protocol;
+ (BOOL)hasRegisteredProtocol:(Protocol *)protocol;


+ (id)getCoreFromClass:(Class)cls;//从map中取出指定core，没有则创建返回
+ (void)removeCoreByClass:(Class)cls;//从map中删除core
+ (id)getCoreFromProtocol:(Protocol *)protocol;

@end
