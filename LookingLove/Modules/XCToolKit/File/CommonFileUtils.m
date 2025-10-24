//
//  CommonFileUtils.m
//  Commons
//
//  Created by 小城 on 14-6-5.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "CommonFileUtils.h"
#import <CommonCrypto/CommonDigest.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

@implementation CommonFileUtils

+ (NSString *)documentsDirectory
{
    static NSString *docsDir = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    });
    return docsDir;
}

+ (NSString *)cachesDirectory
{
    static NSString *cachesDir = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    });
    return cachesDir;
}

+ (BOOL)createDirForPath:(NSString *)path
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)createDirWithDirPath:(NSString *)dirPath
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

+ (BOOL)deleteFileWithFullPath:(NSString *)fullPath
{
    BOOL deleteSucc = NO;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:fullPath]) {
        deleteSucc = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
    }
    
    return deleteSucc;
}


/**UserDefault
 */
+ (BOOL)writeObject:(id)object toUserDefaultWithKey:(NSString*)key
{
    if (object == nil || key == nil) return NO;
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:key];
    return [defaults synchronize];
}

+ (id)readObjectFromUserDefaultWithKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:key];
    
    if (myEncodedObject == nil) {
        return nil;
    }
    
    @try {
        return [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    }
    @catch (NSException *e){
        return nil;
    }
}

+ (BOOL)deleteObjectFromUserDefaultWithKey:(NSString*)key
{
    if (!key) {
        return NO;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    return [defaults synchronize];
}

+ (BOOL)isFileExists:(NSString *)filePath
{
   	return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (BOOL)appendContent:(NSString *)content toFilePath:(NSString *)filePath
{
    if (![CommonFileUtils isFileExists:filePath]) {
        return NO;
    }
    
    BOOL appendSucc = YES;
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!fileHandle) {
        appendSucc = NO;
    } else {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    
    return appendSucc;
}


/**CachesPath
 */
+ (void)writeObject:(id)object toCachesPath:(NSString*)path
{
    if (object == nil || [path length] == 0)
        return;
    
    NSString *fullPath = [[CommonFileUtils cachesDirectory] stringByAppendingPathComponent:path];
    [CommonFileUtils _writeObject:object toPath:fullPath];
}

+ (id)readObjectFromCachesPath:(NSString*)path
{
    if ([path length] == 0)
        return nil;
    
    NSString *fullPath = [[CommonFileUtils cachesDirectory] stringByAppendingPathComponent:path];
    return [CommonFileUtils _readObjectFromPath:fullPath];
}

+ (BOOL)deleteFileFromCachesPath:(NSString *)path
{
    NSString *fullPath = [[CommonFileUtils cachesDirectory] stringByAppendingPathComponent:path];
    return [CommonFileUtils deleteFileWithFullPath:fullPath];
}

/**DocumentPath
 */
+ (void)writeObject:(id)object toDocumentPath:(NSString *)path
{
    if (object == nil || [path length] == 0)
        return;
    
    NSString *fullPath = [[CommonFileUtils documentsDirectory] stringByAppendingPathComponent:path];
    [CommonFileUtils _writeObject:object toPath:fullPath];

}

+ (id)readObjectFromDocumentPath:(NSString *)path
{
    if ([path length] == 0)
        return nil;
    
    NSString *fullPath = [[CommonFileUtils documentsDirectory] stringByAppendingPathComponent:path];
    return [CommonFileUtils _readObjectFromPath:fullPath];
}

+ (BOOL)deleteFileFromDocumentPath:(NSString *)path
{
    NSString *fullPath = [[CommonFileUtils documentsDirectory] stringByAppendingPathComponent:path];
    return [CommonFileUtils deleteFileWithFullPath:fullPath];
}

+ (BOOL)copyItem:(NSString *)destination toPath:(NSString *)toPath
{
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:destination toPath:toPath error:&error];
    return error != nil;
}

#pragma mark - private
static id getSemaphore(NSString *key)
{
    static NSMutableDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    });
    
    id obj = [dict objectForKey:key];
    if (!obj)
    {
        obj = [[NSObject alloc] init];
        [dict setObject:obj forKey:key];
    }
    return obj;
}

static dispatch_queue_t getFileQueue()
{
    static dispatch_queue_t queue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("FileQueue", NULL);
    });
    return queue;
}


+ (void)_writeObject:(id)obj toPath:(NSString *)fullPath
{
    if (obj == nil || [fullPath length] == 0)
        return;
    
    id newObj = obj;
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]])
    {
        //集合类型为了避免出现写的同时另一个线程在操作同一个集合可能导致崩溃，这里在主线程生成一个新的集合
        if ([obj isKindOfClass:[NSMutableArray class]])
            newObj = [NSMutableArray arrayWithArray:obj];
        else if ([obj isKindOfClass:[NSArray class]])
            newObj = [NSArray arrayWithArray:obj];
        else if ([obj isKindOfClass:[NSMutableDictionary class]])
            newObj = [NSMutableDictionary dictionaryWithDictionary:obj];
        else
            newObj = [NSDictionary dictionaryWithDictionary:obj];
    }
    
    id sema = getSemaphore(fullPath);
    
    //在queue中操作
    dispatch_async(getFileQueue(), ^{
        @synchronized(sema)
        {
            //必须先创建目录，否则archiveRootObject操作在没有目录的情况下会失败！
            if ([CommonFileUtils createDirForPath:fullPath])
            {
                [NSKeyedArchiver archiveRootObject:newObj toFile:fullPath];
            }
//            else
//            {
                
//            }
        }
    });
}

+ (id)_readObjectFromPath:(NSString *)fullPath
{
    id sema = getSemaphore(fullPath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        @try
        {
            @synchronized(sema)
            {
                return [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
            }
        }
        @catch (NSException *e)
        {
            return  nil;
        }
    }
    else
        return nil;
}

+(NSString*)getFileMD5WithPath:(NSString*)path
{
    return (__bridge  NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path,FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                      size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    
    CC_MD5_CTX hashObject;
    bool hasMoreData = true;
    bool didSucceed;
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1)break;
        if (readBytesCount == 0) {
            hasMoreData =false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 *sizeof(digest) + 1];
    for (size_t i =0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i),3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}


@end
