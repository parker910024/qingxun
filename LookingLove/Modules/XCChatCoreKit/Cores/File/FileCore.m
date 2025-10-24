//
//  FileCore.m
//  BberryCore
//
//  Created by chenran on 2017/5/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "FileCore.h"
#import "FileCoreClient.h"
#import "HttpRequestHelper+File.h"
#import "UserCore.h"
#import "MusicCache.h"

#import <NIMSDK/NIMSDK.h>
#import <AVFoundation/AVFoundation.h>

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import "XCMacros.h"
#import "UIImage+Resize.h"
#import "CommonFileUtils.h"
#import "GTMBase64.h"

@interface FileCore ()
<
    MyHTTPConnectionDelegate
>
@end

@implementation FileCore

- (void)setDelegate:(MyHTTPConnection *)connection {
    connection.delegate = GetCore(FileCore);
}

- (void) uploadAvatar:(UIImage *)avatar
{
    if (avatar == nil) {
        return;
    }
    
    UIImage *resizedImage = [avatar resizedImageWithRestrictSize:CGSizeMake(640, 640)];
    // 本地沙盒目录
    NSString *path = [CommonFileUtils cachesDirectory];
    NSString *fileName = [NSString stringWithFormat:@"avatar_%@", [self stringFromDate:[NSDate new]]];
    NSString *imageFilePath = [path stringByAppendingPathComponent:fileName];
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    BOOL success = [UIImageJPEGRepresentation(resizedImage, 1.0) writeToFile:imageFilePath  atomically:YES];
    if (success){
        [[NIMSDK sharedSDK].resourceManager upload:imageFilePath progress:^(float progress) {
            NotifyCoreClient(FileCoreClient, @selector(onUploadProgress:), onUploadProgress:progress);
        } completion:^(NSString * _Nullable urlString, NSError * _Nullable error) {
            if (error == nil) {
                NotifyCoreClient(FileCoreClient, @selector(onUploadSuccess:), onUploadSuccess:urlString);
            } else {
                NotifyCoreClient(FileCoreClient, @selector(onUploadFailth:), onUploadFailth:error);
            }
        }];
    } else {
        NotifyCoreClient(FileCoreClient, @selector(onUploadFailth:), onUploadFailth:nil);
    }
}

- (void)uploadCover:(UIImage *)image
{
    if (image == nil) {
        return;
    }
    UIImage *resizedImage = [image resizedImageWithRestrictSize:CGSizeMake(720, 1280)];
    // 本地沙盒目录
    NSString *path = [CommonFileUtils cachesDirectory];
    NSString *fileName = [NSString stringWithFormat:@"cover_%@", [self stringFromDate:[NSDate new]]];
    NSString *imageFilePath = [path stringByAppendingPathComponent:fileName];
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    BOOL success = [UIImageJPEGRepresentation(resizedImage, 0.7) writeToFile:imageFilePath  atomically:YES];
    
    if (success){
        [[NIMSDK sharedSDK].resourceManager upload:imageFilePath progress:^(float progress) {
            NotifyCoreClient(FileCoreClient, @selector(onUploadProgress:), onUploadProgress:progress);
        } completion:^(NSString * _Nullable urlString, NSError * _Nullable error) {
            if (error == nil) {
                NotifyCoreClient(FileCoreClient, @selector(onUploadCoverSuccess:), onUploadCoverSuccess:urlString);
            } else {
                NotifyCoreClient(FileCoreClient, @selector(onUploadCoverFailth:), onUploadCoverFailth:error);
            }
        }];
    } else {
        NotifyCoreClient(FileCoreClient, @selector(onUploadCoverFailth:), onUploadCoverFailth:nil);
    }
}

- (void) downloadVoice:(NSString *)urlString
{
    if (urlString.length <= 0) {
        return;
    }
    
    NSString *voiceFilePath = [self read:urlString];
    if (voiceFilePath.length > 0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:voiceFilePath]) {
            self.filePath = voiceFilePath;
            NotifyCoreClient(FileCoreClient, @selector(onDownloadVoiceSuccess:), onDownloadVoiceSuccess:voiceFilePath);
            return;
        }
    }
    
    NSString *path = [CommonFileUtils cachesDirectory];
    NSString *fileName = [NSString stringWithFormat:@"voice_%@.aac", [self stringFromDate:[NSDate new]]];
    voiceFilePath = [path stringByAppendingPathComponent:fileName];
    
    [[NIMSDK sharedSDK].resourceManager download:urlString filepath:voiceFilePath progress:^(float progress) {
        
    } completion:^(NSError * _Nullable error) {
        if (error == nil) {
            [self save:urlString value:voiceFilePath];
            NotifyCoreClient(FileCoreClient, @selector(onDownloadVoiceSuccess:), onDownloadVoiceSuccess:voiceFilePath);
        } else {
            NotifyCoreClient(FileCoreClient, @selector(onDownloadVoiceFailth:), onDownloadVoiceSuccess:voiceFilePath);
        }
    }];
}

- (void)save:(NSString *)key value:(NSString *)value
{
    if (key.length <= 0 || value.length <= 0) {
        return;
    }
    
    NSUserDefaults *useDefaults = [NSUserDefaults standardUserDefaults];
    [useDefaults setObject:value forKey:key];
}

- (NSString *)read:(NSString *)key
{
    if (key.length <= 0) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)uploadVoice:(NSString *)filePath
{
    if (filePath.length <= 0) {
        return;
    }
    
    [[NIMSDK sharedSDK].resourceManager upload:filePath progress:^(float progress) {
        NotifyCoreClient(FileCoreClient, @selector(onUploadProgress:), onUploadProgress:progress);
    } completion:^(NSString * _Nullable urlString, NSError * _Nullable error) {
        if (error == nil) {
            NotifyCoreClient(FileCoreClient, @selector(onUploadVoiceSuccess:), onUploadVoiceSuccess:urlString);
        } else {
            NotifyCoreClient(FileCoreClient, @selector(onUploadVoiceFailth:), onUploadVoiceFailth:error);
        }
    }];
}

//上传图片
- (void)uploadImage:(UIImage *)image {
    //本地沙盒目录
//    UIImage *resizedImage = [image resizedImageWithRestrictSize:CGSizeMake(720, 1280)];
    NSString *path = [CommonFileUtils cachesDirectory];
    NSString *fileName = [NSString stringWithFormat:@"userPhoto_%@", [self stringFromDate:[NSDate new]]];
    NSString *imageFilePath = [path stringByAppendingPathComponent:fileName];
    
    [UIImageJPEGRepresentation(image, 0.6) writeToFile:imageFilePath atomically:YES];
    
    [[NIMSDK sharedSDK].resourceManager upload:imageFilePath progress:^(float progress) {
        
    } completion:^(NSString * _Nullable urlString, NSError * _Nullable error) {
        if (error == nil) {
            [GetCore(UserCore)uploadImageUrlToServer:urlString];
            NotifyCoreClient(FileCoreClient, @selector(onUploadImageSuccess), onUploadImageSuccess);
        }else {
            NotifyCoreClient(FileCoreClient, @selector(onUploadImageFailth:), onUploadImageFailth:error.description);
        }
        
    }];
    
}


- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}


#pragma mark - Qiniu

- (void)qiNiuUploadFile:(NSData *)file  uploadType:(UploadImageType)uploadType{
    NSString *token = [self token];
    [HttpRequestHelper uploadFile:file named:nil token:token success:^(NSString *key, NSDictionary *resp) {
        NSString *imageKey = resp[@"key"];
        switch (uploadType) {
            case UploadImageTypeWKWeb:
                NotifyCoreClient(FileCoreClient, @selector(onUploadRecodeFileSuccess:), onUploadRecodeFileSuccess:imageKey);
                break;
            case UploadDataTypeCommunityAudio:
                NotifyCoreClient(FileCoreClient, @selector(didUploadCommunityAudioSuccess:), didUploadCommunityAudioSuccess:imageKey);
                break;
            case UploadDataTypeVoiceBottle:
                NotifyCoreClient(FileCoreClient, @selector(didUploadTTVoiceBottleSuccess:), didUploadTTVoiceBottleSuccess:imageKey);
                break;
            default:
                break;
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        switch (uploadType) {
            case UploadImageTypeWKWeb:
                NotifyCoreClient(FileCoreClient, @selector(onUploadRecodeFileFailth:), onUploadRecodeFileFailth:message);
                break;
            case UploadDataTypeCommunityAudio:
                NotifyCoreClient(FileCoreClient, @selector(didUploadCommunityAudioFailth:), didUploadCommunityAudioFailth:message);
                break;
            case UploadDataTypeVoiceBottle:
                NotifyCoreClient(FileCoreClient, @selector(didUploadTTVoiceBottleFailth:), didUploadTTVoiceBottleFailth:message);
                break;
            default:
                break;
        }
    }];
    
}

- (void)qiNiuUploadSoundDataFile:(NSString *)filePath uploadType:(UploadImageType)uploadType {
    NSString *token = [self token];
    [HttpRequestHelper uploadSoundDataFile:filePath token:token success:^(NSString *key, NSDictionary *resp) {
        NSString *dataKey = resp[@"key"];
        if (uploadType == UploadDataTypeNightSong) {
            NotifyCoreClient(FileCoreClient, @selector(didUploadNightSongFileSuccess:), didUploadNightSongFileSuccess:dataKey);
        }
        if (uploadType == UploadDataTypeDynamicVoice) {
            NotifyCoreClient(FileCoreClient, @selector(didUploadDynamicVoiceFileSuccess:), didUploadDynamicVoiceFileSuccess:dataKey);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (uploadType == UploadDataTypeNightSong) {
             NotifyCoreClient(FileCoreClient, @selector(didUploadNightSongFileFailth:), didUploadNightSongFileFailth:message);
        }
        if (uploadType == UploadDataTypeDynamicVoice) {
            NotifyCoreClient(FileCoreClient, @selector(didUploadDynamicVoiceFileFailth:), didUploadDynamicVoiceFileFailth:message);
        }
    }];
}

- (void)qiNiuUploadImage:(UIImage *)image  uploadType:(UploadImageType)uploadType {

    HttpRequestHelperUploadBizType bizType = HttpRequestHelperUploadBizTypeUserAvatar;
    switch (uploadType) {
        case UploadImageTypeAvtor:
        case UploadImageTypeUserInfo:
        case UploadImageTypeFamilyIcon:
        {
            bizType = HttpRequestHelperUploadBizTypeUserAvatar;
        }
            break;
        case UploadImageTypeLibary:
        {
            bizType = HttpRequestHelperUploadBizTypeUserAlbum;
        }
            break;
        case UploadDataTypeLittleWorld:
        {
            bizType = HttpRequestHelperUploadBizTypeLittleWorld;
        }
            break;
        case UploadDataTypeDynamicVoice:
        {
            bizType = HttpRequestHelperUploadBizTypeUserVoice;
        }
            break;
        case UploadImageTypeGroupIcon:
        {
            bizType = HttpRequestHelperUploadBizTypeFamilyGroup;
        }
            break;
        default:
            break;
    }
    
    [self uploadImages:@[image] bizType:bizType success:^(NSArray<UploadImage *> *data) {
        
        NSString *imageKey = data.firstObject.filename;
        switch (uploadType) {
            case UploadImageTypeAvtor:
                NotifyCoreClient(FileCoreClient, @selector(didUploadAvtorImageSuccessUseQiNiu:), didUploadAvtorImageSuccessUseQiNiu:imageKey);
                break;
            case UploadImageTypeLibary:
                NotifyCoreClient(FileCoreClient, @selector(didUploadPhotoImageSuccessUseQiNiu:), didUploadPhotoImageSuccessUseQiNiu:imageKey);
                break;
            case UploadImageTypeUserInfo:
                NotifyCoreClient(FileCoreClient, @selector(didUploadPhotoAtUserInfoSuccessUseQiNiu:), didUploadPhotoAtUserInfoSuccessUseQiNiu:imageKey);
                break;
            case UploadImageTypeChatRoot:
                NotifyCoreClient(FileCoreClient, @selector(didUploadChatRoomImageSuccessUseQiNiu:), didUploadChatRoomImageSuccessUseQiNiu:imageKey);
                break;
            case UploadImageTypeGroupIcon:
                NotifyCoreClient(FileCoreClient, @selector(didUploadGroupIconImageSuccessUseQiNiu:), didUploadGroupIconImageSuccessUseQiNiu:imageKey);
                break;
            case UploadImageTypeFamilyIcon:
                NotifyCoreClient(FileCoreClient, @selector(didUploadFamilyIconImageSuccessUseQiNiu:), didUploadFamilyIconImageSuccessUseQiNiu:imageKey);
                break;
            case UploadDataTypeCommunityCover:
                NotifyCoreClient(FileCoreClient, @selector(didUploadCommunityCoverSuccess:), didUploadCommunityCoverSuccess:imageKey);
                break;
            case UploadDataTypeLittleWorld:
                NotifyCoreClient(FileCoreClient, @selector(didUploadTTLittleWorldImageSuccess:), didUploadTTLittleWorldImageSuccess:imageKey);
                break;
            default:
                break;
        }
                
    } failure:^(NSNumber *resCode, NSString *message) {
        
        switch (uploadType) {
            case UploadImageTypeAvtor:
                NotifyCoreClient(FileCoreClient, @selector(didUploadAvtorImageFailUseQiNiu:), didUploadAvtorImageFailUseQiNiu:message);
                break;
            case UploadImageTypeLibary:
                NotifyCoreClient(FileCoreClient, @selector(didUploadPhotoImageFailUseQiNiu:), didUploadPhotoImageFailUseQiNiu:message);
                break;
            case UploadImageTypeUserInfo:
                NotifyCoreClient(FileCoreClient, @selector(didUploadPhotoAtUserInfoFailUseQiNiu:), didUploadPhotoAtUserInfoFailUseQiNiu:message);
                break;
            case UploadImageTypeChatRoot:
                NotifyCoreClient(FileCoreClient, @selector(didUploadChatRoomImageFailUseQiNiu:), didUploadChatRoomImageFailUseQiNiu:message);
                break;
            case UploadImageTypeGroupIcon:
                NotifyCoreClient(FileCoreClient, @selector(didUploadGroupIconImageFailUseQiNiu:), didUploadGroupIconImageFailUseQiNiu:message);
                break;
            case UploadImageTypeFamilyIcon:
                NotifyCoreClient(FileCoreClient, @selector(didUploadFamilyIconImageFailUseQiNiu:), didUploadFamilyIconImageFailUseQiNiu:message);
                break;
            case UploadDataTypeCommunityCover:
                NotifyCoreClient(FileCoreClient, @selector(didUploadCommunityCoverFailth:), didUploadCommunityCoverFailth:message);
                break;
            case UploadDataTypeLittleWorld:
                NotifyCoreClient(FileCoreClient, @selector(didUploadTTLittleWorldFail:), didUploadTTLittleWorldFail:message);
                break;
            default:
                break;
        }
    }];
}

/// 图片上传（delegate）
/// @param images 图片列表
/// @param bizType 业务类型
- (void)uploadImages:(NSArray<UIImage *> *)images
             bizType:(HttpRequestHelperUploadBizType)bizType {
    
    [self uploadImages:images
               bizType:bizType
               success:^(NSArray<UploadImage *> *data) {
        NotifyCoreClient(FileCoreClient, @selector(onUploadImage:errorCode:msg:), onUploadImage:data errorCode:nil msg:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FileCoreClient, @selector(onUploadImage:errorCode:msg:), onUploadImage:nil errorCode:resCode msg:message);
    }];
}

/// 图片上传（block）
/// @param images 图片列表
/// @param bizType 业务类型
- (void)uploadImages:(NSArray<UIImage *> *)images
             bizType:(HttpRequestHelperUploadBizType)bizType
             success:(void (^)(NSArray<UploadImage *> *data))success
             failure:(void (^)(NSNumber *resCode, NSString *message))failure {
        
    [HttpRequestHelper uploadFile:images
                         fileType:HttpRequestHelperUploadFileTypePic
                          bizType:bizType
                          success:^(id data) {
        
        NSArray *list = [UploadImage modelsWithArray:data];
        !success ?: success(list);
        
    } failure:failure];
}


- (NSString *)token{
    NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
    
    [authInfo setObject:keyWithType(KeyType_QiNiuBucketName, NO) forKey:@"scope"];
    [authInfo
     setObject:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] +  24 * 3600]
     forKey:@"deadline"];
    
//    {"key":"$(key)","hash":"$(etag)","w":"$(imageInfo.width)","h":"$(imageInfo.height)","format":"$(imageInfo.format)"}

    NSDictionary *dict = @{@"key" : @"$(key)", @"hash" : @"$(etag)", @"w" : @"$(imageInfo.width)", @"h": @"$(imageInfo.height)", @"format" : @"$(imageInfo.format)"};
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *returnBody = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    [authInfo setObject:returnBody forKey:@"returnBody"];
    
    NSData *jsonData =
    [NSJSONSerialization dataWithJSONObject:authInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *encodedString = [self urlSafeBase64Encode:jsonData];
    
    
    NSString *encodedSignedString = [self HMACSHA1:keyWithType(KeyType_QiNiuSK, NO) text:encodedString];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@", keyWithType(KeyType_QiNiuAK, NO), encodedSignedString, encodedString];
    return token;
}

- (NSString *)urlSafeBase64Encode:(NSData *)text {
    
    NSString *base64 =
    [[NSString alloc] initWithData:[GTMBase64 encodeData:text] encoding:NSUTF8StringEncoding];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64;
}



- (NSString *)HMACSHA1:(NSString *)key text:(NSString *)text {
    
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [self urlSafeBase64Encode:HMAC];
    return hash;
}


//获取音乐列表
- (void)uploadMusicList {
    
    self.dbMusicArray = [[[[[MusicCache shareCache] getAllMusics] reverseObjectEnumerator] allObjects] mutableCopy];
    if (self.dbMusicArray) {
        NotifyCoreClient(FileCoreClient,@selector(onUploadMusicListSuccess:), onUploadMusicListSuccess:self.dbMusicArray);
    }else{
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"文件不存在",NSLocalizedDescriptionKey , nil];
        NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:4 userInfo:dic];
        NotifyCoreClient(FileCoreClient, @selector(onUploadMusicListFailth:), onUploadMusicListFailth:error);
    }
}


//删除歌曲
- (void) deleteMusicWithPath:(NSString *)filePath{

    //删除数据库里面的同时删除本地的
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL deletateSucccess;
    if ([manager fileExistsAtPath:filePath]) {
       deletateSucccess = [manager removeItemAtPath:filePath error:nil];
    }else{
        deletateSucccess = NO;
    }
  
    self.dbMusicArray = [[[[[MusicCache shareCache] getAllMusics] reverseObjectEnumerator] allObjects] mutableCopy];

    if (self.dbMusicArray && deletateSucccess) {
        NotifyCoreClient(FileCoreClient,@selector(onDeleteMusicSuccess:), onDeleteMusicSuccess:self.dbMusicArray);
    }else{
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"文件不存在",NSLocalizedDescriptionKey , nil];
        NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:4 userInfo:dic];
        NotifyCoreClient(FileCoreClient, @selector(onDeleteMusicFailth:), onDeleteMusicFailth:error);
    }
    
}


//获取歌曲信息列表
- (NSString *)getMusicArtistsWithFilesURL:(NSURL *)fileURL {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
    NSMutableArray *artists = [[AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyArtist keySpace:AVMetadataKeySpaceCommon] mutableCopy];
    NSArray *albumNames = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyAlbumName keySpace:AVMetadataKeySpaceCommon];
    
    NSString * artistStr = [NSString string];
    
    if (artists.count > 0) {
        AVMetadataItem *artist = [artists objectAtIndex:0];
        artistStr = [artist.value copyWithZone:nil];
    }else{
        artistStr = @"未知歌手";
    }

    return artistStr;
}



#pragma mark - MyHTTPConnectionDelegate

- (NSString *)onSetDestinationPathHttpFileTranSportDestination:(MyHTTPConnection *)server {
    
    NSString* uploadDirPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    uploadDirPath = [NSString stringWithFormat:@"%@/music",uploadDirPath];
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:uploadDirPath isDirectory:&isDir ]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:uploadDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return uploadDirPath;
    
}

- (void)onHttpFileTranSportServer:(MyHTTPConnection *)server successWithPath:(NSString *)filePath {
    if (GetCore(FileCore).aNewMusic != nil) {
        GetCore(FileCore).aNewMusic.musicArtists = [GetCore(FileCore) getMusicArtistsWithFilesURL:[NSURL fileURLWithPath:filePath]];
        NSUUID * uuid = [UIDevice currentDevice].identifierForVendor;
        NSString * musicId = [uuid.UUIDString stringByAppendingString:GetCore(FileCore).aNewMusic.musicName];
        GetCore(FileCore).aNewMusic.musicId = musicId;
        
        [[MusicCache shareCache] saveMusicInfo:GetCore(FileCore).aNewMusic];
        [GetCore(FileCore).kNewMusicArray addObject:GetCore(FileCore).aNewMusic];
        
        //modify by kevin
        [self uploadMusicList];
        
    }
    GetCore(FileCore).aNewMusic = nil;
}

- (BOOL)onHttpFileDataEstimateDuplicateCanPassTranSportServer:(MyHTTPConnection *)server withPath:(NSString *)filePath andFileName:(NSString *)fileName {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        GetCore(FileCore).aNewMusic = [[MusicInfo alloc]init];
        GetCore(FileCore).aNewMusic.filePath = filePath;
        GetCore(FileCore).aNewMusic.musicName = fileName;
    }else {
        return NO;
    }
    return YES;
}

@end
