
#import <UIKit/UIKit.h>
/*---------------常量----------------------*/
CGFloat const TitleHeight = 40;

NSString * const kHomeTagUserDefaultKey = @"kHomeTagUserDefaultKey";//首页tag
NSString * const kRoomTagUserDefaultKey = @"kRoomTagUserDefaultKey";//room tag
NSString * const kCarRemindUserDefaultKey = @"kCarRemindUserDefaultKey";//car remind
NSString * const kIPATranscationIdsKey = @"kIPATranscationIdsKey";//IPA
NSString * const kNobleIPATranscationIdsKey = @"kNobleIPATranscationIdsKey";//Noble IPA


NSString * const kImageTypeRoomBg = @"imageMogr2/auto-orient/thumbnail/20x20";                      //房间背景20x20
NSString * const kImageTypeRoomMagic = @"imageMogr2/auto-orient/thumbnail/80x80";                      //房间魔法80x80
NSString * const kImageTypeRoomFace = @"";                                               //房间表情
NSString * const kImageTypeRoomGift = @"";                                              //房间礼物
NSString * const kImageTypeRoomChatBuble = @"";                                         //ChatBuble
NSString * const kImageTypeHomePageItem = @"imageMogr2/auto-orient/thumbnail/400x400";              //首页400x400
NSString * const kImageTypeHomeBanner = @"imageMogr2/auto-orient/thumbnail/220x660";                //首页banner220x660
NSString * const kImageTypeUserIcon = @"imageMogr2/auto-orient/thumbnail/150x150";                    //用户头像150x150
NSString * const kImageTypeUserLibary = @"imageMogr2/auto-orient/thumbnail/150x150";                  //用户相册150x150
NSString * const kImageTypeUserLibaryDetail = @"";                                      //用户相册大图nil
NSString * const kImageTypeHomeBottomBanner = @"imageMogr2/auto-orient/thumbnail/186x660";

NSString * const kImageTypeFamilyHeaderBack = @"imageMogr2/auto-orient/thumbnail/352x750";

NSString *const kImageTypeUserCardBg = @"imageMogr2/auto-orient/thumbnail/320x120";

NSString * const kImageTypeCornerAvatar = @"imageMogr2/auto-orient/thumbnail/300x300/format/png";



/*---------------BasicParameterConstructor----------------------*/
NSString * const kHttpClientBasicParameterOSKey         = @"os";
NSString * const kHttpClientBasicParameterOSVersionKey  = @"osVersion";
NSString * const kHttpClientBasicParameterISPTypeKey    = @"ispType";
NSString * const kHttpClientBasicParameterNetTypeKey    = @"netType";
NSString * const kHttpClientBasicParameterChannelKey    = @"channel";
NSString * const kHttpClientBasicParameterModelKey      = @"model";
NSString * const kHttpClientBasicParameterDeviceIdKey = @"deviceId";
NSString * const kHttpClientBasicParameterAPpVersionKey = @"appVersion";
NSString * const kHttpClientBasicParameterAppName       = @"app";

/*---------------通知----------------------*/
NSString  * const kApplicationDidBecomeActiveNotification = @"kApplicationDidBecomeActiveNotification";
NSString  * const kRechargePopToGameRoomNotification = @"kRechargePopToGameRoomNotification";
NSString  * const kNeedRefreshUserInfoNotification = @"kNeedRefreshUserInfoNotification";
NSString  * const kEnterRoomFromMiniRoomNotification = @"kEnterRoomFromMiniRoomNotification";
NSString  * const KTTInputViewBecomeFirstResponder = @"KTTInputViewBecomeFirstResponder";
//房间信息变更通知
NSString  * const KOnCacheChatRoomInfoChangeNotification = @"KOnCacheChatRoomInfoChangeNotification";

//-----------耳萌作品播放器相关通知---------------
//关闭播放器
NSString  * const KCloseMusicPlayerNotification = @"KCloseMusicPlayerNotification";
//播放音乐
NSString  * const kPlayMusicPlayerNotification = @"kPlayMusicPlayerNotification";
//暂停音乐
NSString  * const kPauseMusicPlayerNotification = @"kPauseMusicPlayerNotification";

//-----------StoreKey---------------
//搜索记录保存键
NSString * const XCConstSearchRecordStoreKey = @"XCConstSearchRecordStoreKey";

