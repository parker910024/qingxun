//
//  CoreError.m

#import "CoreError.h"

@implementation CoreError

- (instancetype)initWithDomain:(NSErrorDomain)domain
                          code:(NSInteger)code
                       message:(NSString *)message
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
    return [super initWithDomain:domain code:code userInfo:userInfo];
}

- (instancetype)initWithDomain:(NSErrorDomain)domain
                       resCode:(NSInteger)resCode
                    resMessage:(NSString *)resMessage
{
//    NSString *errorMessage = [NSString stringWithFormat:@"resCode/msg %ld %@", (long)resCode, resMessage];
    self.resCode = resCode;
    self.message = resMessage;
    
        NSString *errorMessage = [NSString stringWithFormat:@"状态码/错误信息 %ld %@", (long)resCode, resMessage];

    return [self initWithDomain:domain code:CommonErrorCodeAPI_Error message:errorMessage];
}

- (instancetype)initWithDomain:(NSErrorDomain)domain
                       sdkCode:(NSInteger)sdkCode
{
    return [self initWithDomain:domain code:CommonErrorCoreSDK_Error message:nil];
}

- (NSString *)description
{
    NSDictionary *userInfo = self.userInfo;
    if (userInfo != nil) {
        return [userInfo objectForKey:NSLocalizedDescriptionKey];
    } else {
        return @"";
    }
}

@end
