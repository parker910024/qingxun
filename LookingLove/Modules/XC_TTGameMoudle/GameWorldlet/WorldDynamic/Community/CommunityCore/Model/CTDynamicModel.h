//
//  CTDynamicModel.h
//  UKiss
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "CTCommentReplyModel.h"
#import "LLDynamicImageModel.h"
#import "UserOfficialAnchorCertification.h"
#import "AnchorOrderStatus.h"

typedef NS_ENUM(NSInteger, CTDynamicModelType) {
    CTDynamicModelTypeText = 0,              //文字
    CTDynamicModelTypeRecord,                 //语音
    CTDynamicModelTypePicture,              //图片
    CTDynamicModelTypeVideo,       //视频
};
/*
 "code":200,
 "message":"success",
 "data":[
 {
 "id":1,
 "uid":2475,
 "nick":"漫步人生路。",
 "content":"测试动态",
 "imageUrl":[
 "https://imgkelo.wduoo.com/zj.png?imageslim",
 "https://imgkelo.wduoo.com/bq.png?imageslim",
 "https://imgkelo.wduoo.com/zp.png?imageslim",
 "https://imgkelo.wduoo.com/dy.png?imageslim"
 ],
 "status":1,//审核状态0,待审核 1 发布 2 举报 3 删除 4审核不通过'
 "likeCount":0,
 "commentCount":0,
 "createTime":1562836145000,
 "type":2,
 "gender":1,
 "age":23,
 "nationality":"China",
 "country":"https://img.wduoo.com/agenting.gif?imageslim",
 "sex":"Male",
 "like":false,
 "match":true,//是否相互喜欢了
 "avatar":"https://imgkelo.wduoo.com/FjqZGw8YbyI2gmjD-KBGcl9iqSh-?imageslim",//头像
 "nationalFlag":"https://img.wduoo.com/zhongguo.gif?imageslim",//国旗
 "publishTime":"07-11 17:09",//发布时间
 "voiceUrl":"https://imgkelo.wduoo.com/FjqZGw8YbyI2gmjD-KBGcl9iqSh-?imageslim",//语音url
 "voiceLength":"5",//语言长度
 "videoUrl":"https://imgkelo.wduoo.com/FjqZGw8YbyI2gmjD-KBGcl9iqSh-?imageslim",//视频url
 "cover":"https://imgkelo.wduoo.com/FjqZGw8YbyI2gmjD-KBGcl9iqSh-?imageslim"//封面
 }
 ]
 }
 */
@interface CTDynamicModel : BaseObject
///动态id
@property (nonatomic, assign) long ID;
///是否存在有效视频
@property (assign , nonatomic) BOOL uploadFlag;
///性别
@property (nonatomic, copy) NSString *sex;

///是否相互喜欢
@property (nonatomic, assign) BOOL match;

///国旗
@property (nonatomic, copy) NSString *nationalFlag;

///视频
@property (nonatomic, copy) NSString *videoUrl;

///视频封面
@property (nonatomic, copy) NSString *cover;
///视频封面
@property (nonatomic, strong) UIImage *coverImage;
///横屏1  竖屏 2
@property (nonatomic, assign) NSInteger isLandscape;
///视频封面方向
@property (nonatomic, assign) BOOL videoDirection;

@property (nonatomic, copy) NSString *userLanguage;

///国家
@property (nonatomic, copy) NSString *nationality;

///
@property (nonatomic, copy) NSString *country;
///翻译文本内容
@property (nonatomic, copy) NSString *contentTranslate;
///图片数组
@property (nonatomic, strong) NSArray <NSString *> *imageUrl;
///话题id
@property (nonatomic, assign) long topicId;
///话题名字
@property (nonatomic, copy) NSString *topicName;
///我是否已经点赞
@property (nonatomic, assign) BOOL like;
///最多三条评论数据
@property (nonatomic, strong) NSArray <CTCommentReplyModel *>*commentVoList;
///微博的高度
@property (nonatomic, assign) CGFloat cellHeight;
///是否已经展开
@property (nonatomic, assign) BOOL isOpenUp;
///是否已经翻译
@property (nonatomic, assign) BOOL isTranslate;
///是否已经展开翻译
@property (nonatomic, assign) BOOL isOpenTranslateUp;
///是否是详情页
@property (nonatomic, assign) BOOL isCommunityDetails;
///显示贴结束
@property (nonatomic, assign) BOOL isLimitTimeEnd;
///创建动态时间
@property (nonatomic, copy) NSString *createTime;

///语音url
@property (nonatomic, copy) NSString *voiceUrl;
///语音长度
@property (nonatomic, assign) NSInteger voiceLength;
///是否正在播放
@property (nonatomic, assign) BOOL isPlaying;
///城市
@property (nonatomic, copy) NSString *city;
///声音标签
@property (nonatomic, copy) NSString *voiceTagValue;
///是否正在活跃
@property (nonatomic, copy) NSString *isOnline;
///年月 2019-08
@property (nonatomic, copy) NSString *dateStr;
///日
@property (nonatomic, copy) NSString *day;
///时分
@property (nonatomic, copy) NSString *publishDate;
///是否显示年月
@property (nonatomic, assign) BOOL isShowYears;
//模板类型
@property (nonatomic, assign) int tempType;
//模板内容
@property (nonatomic, copy) NSString *videoContent;
///一张图片的高度
@property (nonatomic, assign) CGFloat oneImageHeight;

#pragma mark -
#pragma mark lookinglove 轻寻项目使用的字段
///动态id
@property (nonatomic, assign) NSInteger dynamicId;
// 动态作者 uid
@property (nonatomic, copy) NSString *uid;
// 所在的小世界id
@property (nonatomic, copy) NSString *worldId;
// 所在的小世界创建人Uid
@property (nonatomic, copy) NSString *worldUid;
/// 动态图片素材
@property (nonatomic, strong) NSArray<LLDynamicImageModel *> *dynamicResList;
///社区头像
@property (nonatomic, copy) NSString *avatar;
///性别
@property (nonatomic, assign) NSInteger gender;
///年龄
@property (nonatomic, assign) NSInteger age;
///文本内容
@property (nonatomic, copy) NSString *content;
// 默认用户身份 1 , 官方账户 2
@property (nonatomic, assign) NSInteger defUser;
// 是否是新用户
@property (nonatomic, assign) BOOL newUser;
// 是否点赞过
@property (nonatomic, assign) BOOL isLike;
// 贵族id
@property (nonatomic, assign) UserID nobleId;
// 贵族名字
@property (nonatomic, copy) NSString *nobleName;
// 点赞数量
@property (nonatomic, copy) NSString *likeCount;
// 评论数量
@property (nonatomic, copy) NSString *commentCount;
///发布时间
@property (nonatomic, copy) NSString *publishTime;
///类型 0：纯文本，1:语音，2图片，3视频
@property (nonatomic, assign) NSInteger type;
///社区昵称
@property (nonatomic, copy) NSString *nick;
/// 贵族 badge
@property (nonatomic, copy) NSString *badge;
/// 头饰url地址
@property (nonatomic, copy) NSString *headwearPic;
// 贵族头饰字段
@property (nonatomic, copy) NSString *micDecorate;
/// 动态状态 0 审核中， 1 审核通过
@property (nonatomic, assign) BOOL status;
// 是否是首次发布动态
@property (nonatomic, assign) BOOL isFirstDynamic;

@property (nonatomic, copy) NSString *worldName;
// 是否在当前的小世界中
@property (nonatomic, assign) BOOL inWorld;

// 官方主播认证
@property (nonatomic, strong) UserOfficialAnchorCertification *nameplate;
//认证主播的派单
@property (nonatomic, strong) AnchorOrderInfo *workOrder;
//主播认证标签
@property (nonatomic, strong) NSArray<NSString *> *tagList;

+ (UIImage *)modelWithPictureImageBg;


- (CGFloat)getContentTextNoEmptyText:(NSString *)text;

@end
