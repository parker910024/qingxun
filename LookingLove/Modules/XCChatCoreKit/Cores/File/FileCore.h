//
//  FileCore.h
//  BberryCore
//
//  Created by chenran on 2017/5/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "MusicInfo.h"

#import "MyHTTPConnection.h"
#import "HTTPServer.h"
#import "HttpRequestHelper.h"
#import "UploadImage.h"

typedef enum : NSUInteger {
    UploadImageTypeAvtor,  //头像
    UploadImageTypeLibary, //编辑
    UploadImageTypeUserInfo,//个人页
    UploadImageTypeChatRoot,
    UploadImageTypeGroupIcon, //群头像
    UploadImageTypeFamilyIcon, //家族头像
    UploadImageTypeWKWeb,      //h5交互
    UploadDataTypeNightSong,  //晚安曲 （音频文件）
    UploadDataTypeDynamicVoice, //社区动态 （音频文件）
    UploadDataTypeCommunityCover, //萌圈封面(萌声用)
    UploadDataTypeCommunityAudio, //萌圈音频(萌声用)
    UploadDataTypeVoiceBottle, //声音瓶子 （兔兔用)
    UploadDataTypeLittleWorld, // 小世界（兔兔用）
} UploadImageType;

@interface FileCore : BaseCore

@property (nonatomic, strong)NSMutableArray * fileArray;
@property (nonatomic, strong)NSMutableArray<MusicInfo *> * musicArray;
@property (nonatomic, strong)MusicInfo * aNewMusic;
@property (nonatomic, strong)NSMutableArray * kNewMusicArray;
@property (nonatomic, strong)NSMutableArray * dbMusicArray;
/** 录音文件地址: 打招呼 */
@property (nonatomic, copy) NSString *filePath;

/** 获取音乐列表*/
- (void) uploadMusicList;
- (void) deleteMusicWithPath:(NSString *)filePath;
- (NSString *)getMusicArtistsWithFilesURL:(NSURL *)fileURL;

#pragma mark - NIMSDK
/** 下载录音文件*/
- (void) downloadVoice:(NSString *)urlString;
- (void) uploadVoice:(NSString *)filePath;
- (void) uploadAvatar:(UIImage *)image;
- (void) uploadCover:(UIImage *)image;
- (void) uploadImage:(UIImage *)image;


#pragma mark - qiNiu
/// 图片上传，内部已改为服务器上传，并非七牛上传
- (void)qiNiuUploadImage:(UIImage *)image uploadType:(UploadImageType)uploadType;
/// 文件上传，七牛
- (void)qiNiuUploadFile:(NSData *)file  uploadType:(UploadImageType)uploadType;
/// 上传音频，七牛
- (void)qiNiuUploadSoundDataFile:(NSString *)filePath uploadType:(UploadImageType)uploadType;

#pragma mark - Server Upload
/// 图片上传（delegate）
/// @param images 图片列表
/// @param bizType 业务类型
- (void)uploadImages:(NSArray<UIImage *> *)images
             bizType:(HttpRequestHelperUploadBizType)bizType;

/// 图片上传（block）
/// @param images 图片列表
/// @param bizType 业务类型
- (void)uploadImages:(NSArray<UIImage *> *)images
             bizType:(HttpRequestHelperUploadBizType)bizType
             success:(void (^)(NSArray<UploadImage *> *data))success
             failure:(void (^)(NSNumber *resCode, NSString *message))failure;




/**
 socket流传输 Connection 设置Filecore为代理

 @param connection Connection
 */
- (void)setDelegate:(MyHTTPConnection *)connection;
@end
