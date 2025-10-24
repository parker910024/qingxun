//
//  CoreError.h

#import <Foundation/Foundation.h>

#define CORE_ERROR(d, c, m) [[CoreError alloc] initWithDomain:d code:c message:m]
#define CORE_API_ERROR(d, c, m) [[CoreError alloc] initWithDomain:d resCode:c resMessage:m]
#define CORE_SDK_ERROR(d, c) [[CoreError alloc] initWithDomain:d sdkCode:c]

static NSString * const LiveCoreErrorDomain = @"Live";
static NSString * const RoomCoreErrorDomain = @"Room";
static NSString * const UserCoreErrorDomain = @"User";
static NSString * const ImLoginCoreErrorDomain = @"ImLogin";
static NSString * const ImFriendCoreErrorDomain = @"ImFriend";

typedef NS_ENUM(NSInteger,CommonErrorCode){
    CommonErrorCodeAPI_Error                = 1000,
    CommonErrorCoreSDK_Error                = 1001,
    CommonErrorCodeDb_Error                 = 1002,
    CommonErrorCodeTimeout_Error            = 1003,
    CommonErrorCodeServer_Error             = 1004,
    CommonErrorCodeUnknown_Error            = 1005,
    CommonErrorNoToken_Error                = 1006,
    CommonErrorCodeDecodeToken_Error        = 1007,
    CommonErrorNoLogined_Error              = 1008,
    CommonErrorWrongParam_Error             = 1009
};

@interface CoreError : NSError

/// 错误信息
@property (nonatomic, strong) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger resCode;

//common
- (instancetype)initWithDomain:(NSErrorDomain)domain
                          code:(NSInteger)code
                       message:(NSString *)message;

//API
- (instancetype)initWithDomain:(NSErrorDomain)domain
                       resCode:(NSInteger)resCode
                    resMessage:(NSString *)resMessage;

//SDK
- (instancetype)initWithDomain:(NSErrorDomain)domain
                       sdkCode:(NSInteger)sdkCode;

@end

