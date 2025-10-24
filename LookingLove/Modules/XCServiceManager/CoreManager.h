//
//  CoreManager.h


#import <Foundation/Foundation.h>
#import "CommonServiceCenter.h"

//core
#define GetCore(className) ((className *)[CoreManager getCore:[className class]])
#define RemoveCore(className) ([CoreManager removeCore:[className class]])
#define GetCoreI(InterfaceName) ((id<InterfaceName>)[CoreManager getCoreFromProtocol:@protocol(InterfaceName)])

//client
#define AddCoreClient(protocolName, client) ([CoreManager addClient:client for:@protocol(protocolName)])
#define RemoveCoreClient(protocolName, client) ([CoreManager removeClient:client for:@protocol(protocolName)])
#define RemoveCoreClientAll(client) ([CoreManager removeClient:client])

//调用实现了protocolName的client的selector方法
#define NotifyCoreClient(protocolName, selector, func) NOTIFY_SERVICE_CLIENT(protocolName, selector, func)


//provide
#define RegisterServiceProvide(protocolName,provide) ([CoreManager registServiceProvide:provide forProtocol:@protocol(protocolName)])

#define GetServiceProvide(protocolName) ([CoreManager serviceProvideForProtocol:@protocol(protocolName)])


@interface CoreManager : NSObject

//初始化core
+ (void)initCore;

//core
+ (id)getCore:(Class)cls; //获取core
+ (void)removeCore:(Class)cls; //从CoreFactory中移除core
+ (id)getCoreFromProtocol:(Protocol *)protocol;

//client
+ (void)addClient:(id)obj for:(Protocol *)protocol;//client添加protocol
+ (void)removeClient:(id)obj for:(Protocol *)protocol;//client移除porotocal
+ (void)removeClient:(id)obj;//client移除所有protocol

//provide
+ (void)registServiceProvide:(id)provide forProtocol:(Protocol *)protocol;
+ (id)serviceProvideForProtocol:(Protocol *)protocol;



@end
