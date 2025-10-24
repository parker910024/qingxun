//iphone size
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO) //判断是否iphone4

#define iPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) //判断是否iphone5
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO) //判断是否iphone6
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO) //判断是否iPhoneX

//iPhoneX系列设备(刘海屏设备）
#define iPhoneXSeries \
({BOOL isPhoneXSeries = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneXSeries = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneXSeries);})

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

#define iOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)
#define LiOS11 ([[UIDevice currentDevice].systemVersion doubleValue] < 11.0)

//i18Ns
#define XCLocalizedString(key) \
[NSBundle xc_localizedStringForKey:(key)]

#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define statusbarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height
#define kStatusBarHeight statusbarHeight
#define kSafeAreaBottomHeight (KScreenHeight >= 812.0 ? 34 : 0)
#define kSafeAreaTopHeight (KScreenHeight >= 812.0 ? 24 : 0)
#define kNavigationHeight (statusbarHeight + 44)
#define kTabBarHeight (iPhoneXSeries ? 49.0+34.0 : 49.0)

#define KWeakify(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define KStrongify(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#define default_bg @"default_bg"

#define WCNumberHaHa @"hahayuyin2018"

#define ticketKey @"accountTicket"
#define uidKey @"accountUid"
#define isFirstLogin @"isFirstLogin"

/*---------------视频耳萌旧代码----------------------*/
#define m_loginKey @"loginKey"
#define m_uid @"uid"

/*---------------打印----------------------*/
#if DEBUG
#define NSLog(fmt,...) NSLog((@"%s [Line %d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define NSLog(...)
#endif



/*---------------项目名----------------------*/
#define MyAppName ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

typedef NS_ENUM(NSUInteger,ProjectType){
    ProjectType_MengSheng = 1,  //萌声
    ProjectType_BB,          //萌声社区
    ProjectType_Haha,       //哈哈
    ProjectType_TuTu,       //兔兔
    ProjectType_Pudding,     //兔兔玩友
    ProjectType_LookingLove, //轻寻
    ProjectType_CeEr,       // 侧耳
    ProjectType_VKiss,       //VKiss
    ProjectType_Planet,     // hello处CP
    ProjectType_DontSilent,     // 不默
    ProjectType_CatASMR,     // 抓耳
    ProjectType_CatEar,      // 猫耳
    ProjectType_HAYO,//hayo
    ProjectType_Unknow      //未知项目
};


    

typedef NS_ENUM(NSUInteger,KeyType){
    KeyType_BaseH5URL,       
    KeyType_NetWork,            //网络环境key
    KeyType_BaseURL,            //baseURL
    KeyType_BaseURL_Pre_Release,//Pre_ReleaseType预发布环境
    
    KeyType_AliyunLogEndPoint,  //阿里云log 服务器目的地址
    KeyType_AliyunLogProject,   //阿里云log 项目名
    KeyType_AliyunLogStore,     //阿里云log 存储块名
    
    KeyType_PwdEncode,          //密码加密key
    KeyType_ParamsEncode,       //参数加密key
    KeyType_SignKey,            //参数签名key
    
    KeyType_Agora,              //声网key
    KeyType_NetEase,            //云信key
    KeyType_APNSCer,            //推送证书名
//    KeyType_QYSDK,              //七语SDK
    KeyType_WJSDK,             //WJSDK
    
    KeyType_QiNiuAK,            //七牛AK
    KeyType_QiNiuSK,            //七牛SK
    KeyType_QiNiuBaseURL,       //七牛baseURL
    KeyType_QiNiuBucketName,    //七牛存储库
    
    KeyType_QQAppid,            //QQ Appid
    KeyType_QQSecret,           //QQ secret
    KeyType_WechatAppid,        //微信 Appid
    KeyType_WechatSecret,       //微信 Secret
    KeyType_WechatUniversalLink,//微信 UniversalLink
    KeyType_QQUniversalLink,    // QQ UniversalLink

    KeyType_GKAppid,  //个推Appid
    KeyType_GKAppKey,  //个推AppKey
    KeyType_GKAppSecret,  //个推AppSecret
    
    KeyType_UMappAppKey, //友盟AppKey
    KeyType_UMChannelId,//友盟channelId
    
    KeyType_SecretaryUid,       //小秘书id
    KeyType_SystemNotifyUid,     //系统消息id
    KeyType_HudongMessageUid,     //互动消息

    KeyType_BaiDuMTJAk,         //百度统计
    KeyType_AMLocationSDKApiKey,      // 高德地图
    KeyType_BuglySDKApiKey,             // Bugly
    KeyType_YiDunProduceID,            //易盾产品id
    KeyType_YiDunBusinessID,          //易盾业务id
    KeyType_ShuMeiOrganizationID,      //数美
    
    KeyType_CLShanYanAppID,     //创蓝appid
};


#define force_inline __inline__ __attribute__((always_inline))
static force_inline NSString *IntToNSString(int num) {
    return [NSString stringWithFormat:@"%d",num];
}
//兔兔贵族专用
static force_inline NSDictionary *MatchNobleName(){
    return @{@"0":@"平民",
             @"1":@"男爵",
             @"2":@"子爵",
             @"3":@"伯爵",
             @"4":@"侯爵",
             @"5":@"公爵",
             @"6":@"国王",
             @"7":@"皇帝"};
}
static force_inline NSString *MatchNobleNameUsingID(NSString *type){
    NSDictionary *dictionary = MatchNobleName();
    return dictionary[type];
}


/**
 获取当前项目的枚举

 @return 项目枚举
 */
ProjectType projectType(void);

NSString * const keyWithType(KeyType type,BOOL isDebug);

NSString * const idWithRobotId(NSInteger userID, BOOL isDebug);
