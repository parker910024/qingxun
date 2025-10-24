#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifndef Const_h
#define Const_h

/*---------------aliyun log----------------------*/
#define HTTP_DATE_FORMAT @"EEE, dd MMM yyyy HH:mm:ss"

#define KEY_HOST @"Host"
#define KEY_TIME @"__time__"
#define KEY_TOPIC @"__topic__"
#define KEY_SOURCE @"__source__"
#define KEY_LOGS @"__logs__"

#define KEY_DATE @"Date"

#define KEY_CONTENT_LENGTH @"Content-Length"
#define KEY_CONTENT_MD5 @"Content-MD5"
#define KEY_CONTENT_TYPE @"Content-Type"

#define KEY_LOG_APIVERSION @"x-log-apiversion"
#define KEY_LOG_BODYRAWSIZE @"x-log-bodyrawsize"
#define KEY_LOG_COMPRESSTYPE @"x-log-compresstype"
#define KEY_LOG_SIGNATUREMETHOD @"x-log-signaturemethod"

#define KEY_ACS_SECURITY_TOKEN @"x-acs-security-token"
#define KEY_AUTHORIZATION @"Authorization"

#define POST_VALUE_LOG_APIVERSION @"0.6.0"
#define POST_VALUE_LOG_COMPRESSTYPE @"deflate"
#define POST_VALUE_LOG_CONTENTTYPE @"application/json"
#define POST_VALUE_LOG_SIGNATUREMETHOD @"hmac-sha1"


#define POST_GROUP_LIMIT 1



/*---------------常量----------------------*/
UIKIT_EXTERN CGFloat const TitleHeight;


UIKIT_EXTERN NSString * const kHomeTagUserDefaultKey;//首页tag
UIKIT_EXTERN NSString * const kRoomTagUserDefaultKey;//room tag
UIKIT_EXTERN NSString * const kCarRemindUserDefaultKey;//car remind
UIKIT_EXTERN NSString * const kIPATranscationIdsKey;//IPA

UIKIT_EXTERN NSString * const kImageTypeRoomBg;         //房间背景20x20
UIKIT_EXTERN NSString * const kImageTypeRoomMagic;      //房间魔法40x40
UIKIT_EXTERN NSString * const kImageTypeRoomFace;       //房间表情
UIKIT_EXTERN NSString * const kImageTypeRoomGift;       //房间礼物
UIKIT_EXTERN NSString * const kImageTypeRoomChatBuble;  //ChatBuble
UIKIT_EXTERN NSString * const kImageTypeHomePageItem;   //首页400x400
UIKIT_EXTERN NSString * const kImageTypeHomeBanner;     //首页banner220x660
UIKIT_EXTERN NSString * const kImageTypeUserIcon;       //用户头像60x60
UIKIT_EXTERN NSString * const kImageTypeUserLibary;     //用户相册60x60
UIKIT_EXTERN NSString * const kImageTypeUserLibaryDetail;//用户相册大图nil
UIKIT_EXTERN NSString * const kImageTypeHomeBottomBanner;//首页底部banner
UIKIT_EXTERN NSString * const kImageTypeFamilyHeaderBack;//家族最强王者头部背景图
UIKIT_EXTERN NSString * const kImageTypeUserCardBg;//用户卡片背景
UIKIT_EXTERN NSString * const kImageTypeCornerAvatar;//圆角图形，会先把图形裁剪成正方形，并且转换为png



/*---------------BasicParameterConstructor----------------------*/
UIKIT_EXTERN NSString * const kHttpClientBasicParameterOSKey;
UIKIT_EXTERN NSString * const kHttpClientBasicParameterOSVersionKey;
UIKIT_EXTERN NSString * const kHttpClientBasicParameterISPTypeKey;
UIKIT_EXTERN NSString * const kHttpClientBasicParameterNetTypeKey;
UIKIT_EXTERN NSString * const kHttpClientBasicParameterChannelKey;
UIKIT_EXTERN NSString * const kHttpClientBasicParameterModelKey;
UIKIT_EXTERN NSString * const kHttpClientBasicParameterDeviceIdKey;
UIKIT_EXTERN NSString * const kHttpClientBasicParameterAPpVersionKey;
UIKIT_EXTERN NSString * const kHttpClientBasicParameterAppName;

/*---------------通知----------------------*/
//退出账号
UIKIT_EXTERN NSString  * const kApplicationDidBecomeActiveNotification;
//充值pop到房间的通知：需要刷新👾
UIKIT_EXTERN NSString  * const kRechargePopToGameRoomNotification;
//需要更新用户信息的通知（修改头饰座驾贵族信息）
UIKIT_EXTERN NSString  * const kNeedRefreshUserInfoNotification;
//用户从最小化进入房间通知
UIKIT_EXTERN NSString  * const kEnterRoomFromMiniRoomNotification;
//礼物view 三级礼物键盘弹起来的通知
UIKIT_EXTERN NSString  * const KTTInputViewBecomeFirstResponder;

//房间信息变更通知
UIKIT_EXTERN NSString  * const KOnCacheChatRoomInfoChangeNotification;

//-----------耳萌作品播放器相关通知---------------
//关闭播放器
UIKIT_EXTERN NSString  * const KCloseMusicPlayerNotification;
//播放音乐
UIKIT_EXTERN NSString  * const kPlayMusicPlayerNotification;
//暂停音乐
UIKIT_EXTERN NSString  * const kPauseMusicPlayerNotification;

//-----------StoreKey---------------
//搜索记录保存键
UIKIT_EXTERN NSString * const XCConstSearchRecordStoreKey;

/*---------------枚举----------------------*/

typedef NS_ENUM(NSUInteger,ImageType){
    ImageTypeRoomBg,                //房间背景20x20
    ImageTypeRoomMagic,             //房间魔法80x80
    ImageTypeRoomFace,              //房间表情
    ImageTypeRoomGift,              //房间礼物
    ImageTypeRoomChatBuble,         //ChatBuble
    ImageTypeHomePageItem,          //首页400x400
    ImageTypeHomeBanner,            //首页banner220x660
    ImageTypeUserIcon,              //用户头像60x60
    ImageTypeUserLibary,            //用户相册60x60
    ImageTypeUserLibaryDetail,      //用户相册大图
    ImageTypeUserRoomTag,           //roomTag
    ImageTypeBottomBanners,       //底部banner
    ImageTypeFamilyHeaderBack,       //家族最强王者 头部背景
    ImageTypeUserCardBg, //用户卡片背景
    ImageTypeCornerAvatar,         //圆角图形，会先把图形裁剪成正方形，并且转换为png
};



#endif /* Const_h */
