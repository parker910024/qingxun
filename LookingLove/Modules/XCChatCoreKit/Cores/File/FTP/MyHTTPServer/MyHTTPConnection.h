
#import "HTTPConnection.h"

@class MultipartFormDataParser;
@class MyHTTPConnection;

@protocol MyHTTPConnectionDelegate <NSObject>
@required

/**
 设置目标地址

 @param server 服务器 ftp self
 @return 目标地址str
 */
- (NSString *)onSetDestinationPathHttpFileTranSportDestination:(MyHTTPConnection *)server;
@optional

/**
 文件传输并存储成功

 @param server 服务器 ftp self
 @param filePath 文件路径（含文件名）
 */
- (void)onHttpFileTranSportServer:(MyHTTPConnection *)server successWithPath:(NSString *)filePath;

/**
 文件判断

 @param server 服务器 ftp self
 @param filePath 文件路径（含文件名）
 @return 如果是重复文件，就返回NO
 */
- (BOOL)onHttpFileDataEstimateDuplicateCanPassTranSportServer:(MyHTTPConnection *)server withPath:(NSString *)filePath andFileName:(NSString *)fileName;

@end

@interface MyHTTPConnection : HTTPConnection  {
    MultipartFormDataParser*        parser;
	NSFileHandle*					storeFile;
	NSMutableArray*					uploadedFiles;
}

/**
 文件路径（含文件名）
 */
@property (nonatomic, strong) NSString *filePath;

/**
 文件夹路径（不含文件名）
 */
@property (strong, nonatomic) NSString *destinationPath;

/**
 delegate:MyHTTPConnectionDelegate
 */
@property (nonatomic, weak) id <MyHTTPConnectionDelegate> delegate;
@end
