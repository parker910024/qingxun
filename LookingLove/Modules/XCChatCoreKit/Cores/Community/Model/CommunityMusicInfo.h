//
//  CommunityMusicInfo.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
/** 社区背景音乐*/

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN


/** 音乐分类*/
@interface CommunityMusicCatalog : BaseObject
/** 分类id*/
@property (nonatomic, copy) NSString *ID;
/** 分类名称*/
@property (nonatomic, copy) NSString *name;
/** 排序*/
@property (nonatomic, assign) int seq;

@end

/** 音乐*/
@interface CommunityMusicInfo : BaseObject
/** 背景音乐id*/
@property (nonatomic, copy) NSString *ID;
/** 分类id*/
@property (nonatomic, copy) NSString *catalogId;
/** 歌曲名称*/
@property (nonatomic, copy) NSString *name;
/** 歌手*/
@property (nonatomic, copy) NSString *singer;
/** 歌曲地址*/
@property (nonatomic, copy) NSString *url;
/** 歌曲封面*/
@property (nonatomic, copy) NSString *cover;
/** 上传作者*/
@property (nonatomic, copy) NSString *uploader;
/** 歌曲时长(秒)*/
@property (nonatomic, assign) int duration;
/** 排序*/
@property (nonatomic, assign) int seq;
/** 状态*/
@property (nonatomic, assign) int status;
/** 本地字段:是否使用选中*/
@property (nonatomic, assign) BOOL isSelected;

@end

/** 音乐数据*/
@interface CommunityMusicData : BaseObject

@property (nonatomic, strong) CommunityMusicCatalog *catalog;
@property (nonatomic, strong) NSArray<CommunityMusicInfo *> *musicList;

@end

NS_ASSUME_NONNULL_END
