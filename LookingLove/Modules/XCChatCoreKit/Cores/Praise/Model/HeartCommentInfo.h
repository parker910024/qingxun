//
//  heartCommentInfo.h
//  AFNetworking
//
//  Created by apple on 2018/12/7.
//

#import "BaseObject.h"
#import "UserInfo.h"
#import "RoomInfo.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    DynamicTypeText = 0,
    DynamicTypeVoice,
    DynamicTypePicture,
    DynamicTypeVideo,
} DynamicType;

@interface HeartCommentInfo : BaseObject

@property (nonatomic, assign) UserID uid;
///是否存在有效视频
@property (assign , nonatomic) BOOL uploadFlag;
@property (nonatomic, assign) long commentId; //评论id
@property (copy, nonatomic) NSString *content;    //动态内容
@property (copy, nonatomic) NSArray<NSString*> * imageUrl;//动态图片
@property (copy, nonatomic) NSString *commentUid; //评论者的uid
@property (copy, nonatomic) NSString *commentNick; //评论者昵称
@property (copy, nonatomic) NSString *commentAvatar;//评论者头像

@property (assign, nonatomic) UserGender gender;//性别
@property (nonatomic, strong) NSString *publishTime; //时间
@property (nonatomic, strong) NSString *commentContent; //评论内容
@property (nonatomic, strong) NSString *age; //年龄

@property (nonatomic, assign) long dynamicId; //动态id
@property (nonatomic, strong) NSString *dynamicContent; //动态内容

@property (nonatomic, assign) long parentId; //上一级的评论id //回复的评论id
@property (nonatomic, assign) long createTime; //创建时间
@property (nonatomic, assign) long type;//0是评论y1回复

@property (nonatomic, assign) int isDelete;//是否删除
/// 0或者空表示文本 1表示音频
@property (nonatomic, assign) long contentType;
//类型 0：纯文本，1:语音，2图片，3视频',
@property (nonatomic, assign) DynamicType dynamicType;
 //dynamicStatus  = 3表示动态被删除了
@property (nonatomic, assign) int dynamicStatus;
@end
                                                                                                     
NS_ASSUME_NONNULL_END
