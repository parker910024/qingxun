

#import <Foundation/Foundation.h>

@interface HttpUtility : NSObject

+ (NSString *)urlEncode:(NSString *)urlString;
+ (NSString *)urlDecode:(NSString *)urlString;

@end
