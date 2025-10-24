//
//  FileCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPhoto.h"
#import "UploadImage.h"

@protocol FileCoreClient <NSObject>
@optional
- (void)onUploadProgress:(float) progress;
- (void)onUploadSuccess:(NSString *)url;
- (void)onUploadFailth:(NSError *)error;

- (void)onUploadVoiceSuccess:(NSString *)url;
- (void)onUploadVoiceFailth:(NSError *)error;

- (void)onUploadCoverSuccess:(NSString *)url;
- (void)onUploadCoverFailth:(NSError *)error;

- (void)onDownloadVoiceSuccess:(NSString *)filePath;
- (void)onDownloadVoiceFailth:(NSError *)error;

- (void)onUploadImageSuccess;
- (void)onUploadImageFailth:(NSString *)message;

- (void)onUploadMusicListSuccess:(NSArray *)musicArray;
- (void)onUploadMusicListFailth:(NSError *)error;

- (void)onDeleteMusicSuccess:(NSArray *)musicArray;
- (void)onDeleteMusicFailth:(NSError *)error;

//recode
- (void)onUploadRecodeFileSuccess:(NSString *)url;
- (void)onUploadRecodeFileFailth:(NSString *)message;

//=========qiniu
- (void)didUploadAvtorImageSuccessUseQiNiu:(NSString *)key;
- (void)didUploadAvtorImageFailUseQiNiu:(NSString *)message;
//edit image
- (void)didUploadPhotoImageSuccessUseQiNiu:(NSString *)key;
- (void)didUploadPhotoImageFailUseQiNiu:(NSString *)message;
//userinfo image
- (void)didUploadPhotoAtUserInfoSuccessUseQiNiu:(NSString *)key;
- (void)didUploadPhotoAtUserInfoFailUseQiNiu:(NSString *)message;

- (void)didUploadChatRoomImageSuccessUseQiNiu:(NSString *)key;
- (void)didUploadChatRoomImageFailUseQiNiu:(NSString *)message;

- (void)didUploadGroupIconImageSuccessUseQiNiu:(NSString *)key;
- (void)didUploadGroupIconImageFailUseQiNiu:(NSString *)message;

- (void)didUploadFamilyIconImageSuccessUseQiNiu:(NSString *)key;
- (void)didUploadFamilyIconImageFailUseQiNiu:(NSString *)message;

//发布动态图片上传
- (void)didUploadPutDynamicImageSuccessUseQiNiuWithImageInfo:(UploadImage *)dynamicImage;
- (void)didUploadPutDynamicImageFailUseQiNiu:(NSString *)message;

//晚安曲
- (void)didUploadNightSongFileSuccess:(NSString *)key;
- (void)didUploadNightSongFileFailth:(NSString *)message;

//社区音频 
- (void)didUploadDynamicVoiceFileSuccess:(NSString *)key;
- (void)didUploadDynamicVoiceFileFailth:(NSString *)message;

//萌声社区动态封面
- (void)didUploadCommunityCoverSuccess:(NSString *)key;
- (void)didUploadCommunityCoverFailth:(NSString *)message;
//萌声社区音频文件
- (void)didUploadCommunityAudioSuccess:(NSString *)key;
- (void)didUploadCommunityAudioFailth:(NSString *)message;

//兔兔声音瓶子
- (void)didUploadTTVoiceBottleSuccess:(NSString *)key;
- (void)didUploadTTVoiceBottleFailth:(NSString *)message;

//兔兔小世界
- (void)didUploadTTLittleWorldImageSuccess:(NSString *)key;
- (void)didUploadTTLittleWorldFail:(NSString *)message;

#pragma mark - Server Upload
/// 图片上传回调
- (void)onUploadImage:(NSArray<UploadImage *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

@end
