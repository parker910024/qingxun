//
//  NSObject+XCMacros.h
//  XCConstKit
//
//  Created by 卫明 on 2018/12/4.
//  Copyright © 2018 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCMacros.h"
#import "XCProjectType.h"
ProjectType projectType() {
    return [XCProjectType sharedProjectType].projectType;
}

NSString * const keyWithType(KeyType type,BOOL isDebug) {
    NSDictionary *keys = @{
        @"轻寻":@{
            //配置sdk @xiaoxiao
                @(NO):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"https://dev-api.gehe.chat",
                        @(KeyType_BaseURL_Pre_Release)             : @"https://dev-api.gehe.chat",
                        @(KeyType_BaiDuMTJAk)          : @"c5a8a632cf",
                        @(KeyType_Agora)               : @"663fbbf20fd841d1bd73de4d22f8480e",
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"erban-img",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.erbanyy.com",
                        @(KeyType_NetEase)             : @"1568e3306cf6864f5f66618d6f693774",
                        @(KeyType_APNSCer)             : @"qingxunrelease",
                        @(KeyType_QQAppid)             : @"1109704698",
                        @(KeyType_QQSecret)            : @"EDovf0UR64acAEnf",
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_WechatAppid)         : @"wxbfd798337f743f8c",
                        @(KeyType_WechatSecret)        : @"4296aef2ab01b6855068870c87bc48b3",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        @(KeyType_AliyunLogStore)      : @"erbanlog",
                        @(KeyType_SecretaryUid)        : @"90003989",
                        @(KeyType_SystemNotifyUid)     : @"90295478",
                        @(KeyType_AliyunLogProject)    : @"erbanlog",
                        @(KeyType_AliyunLogEndPoint)   : @"cn-qingdao.log.aliyuncs.com",
                        @(KeyType_WechatUniversalLink) : @"https://xq8ut.share2dlink.com/",
                        @(KeyType_QQUniversalLink)     : @"https://xq8ut.share2dlink.com/qq_conn/1109606637"
                },
                @(YES):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"https://dev-api.gehe.chat",
                        @(KeyType_BaseURL_Pre_Release)             : @"https://dev-api.gehe.chat",
                        @(KeyType_BaiDuMTJAk)          : @"c5a8a632cf",
                        @(KeyType_Agora)               : @"663fbbf20fd841d1bd73de4d22f8480e",
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"erban-img",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.erbanyy.com",
                        @(KeyType_NetEase)             : @"1568e3306cf6864f5f66618d6f693774",
                        @(KeyType_APNSCer)             : @"qingxundebug",
                        @(KeyType_QQAppid)             : @"1109704698",
                        @(KeyType_QQSecret)            : @"EDovf0UR64acAEnf",
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_WechatAppid)         : @"wx71ff7661b637a4ed",
                        @(KeyType_WechatSecret)        : @"a6227bac88021915ed392abed24bf5e0",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        @(KeyType_AliyunLogStore)      : @"erbanlog",
                        @(KeyType_SecretaryUid)        : @"91287",
                        @(KeyType_SystemNotifyUid)     : @"94188",
                        @(KeyType_AliyunLogProject)    : @"erbanlog",
                        @(KeyType_AliyunLogEndPoint)   : @"cn-qingdao.log.aliyuncs.com",
                        @(KeyType_WechatUniversalLink) : @"https://xq8ut.share2dlink.com/",
                        @(KeyType_QQUniversalLink)     : @"https://xq8ut.share2dlink.com/qq_conn/1109606637"
                }
        },
        @"侧耳":@{
                @(NO):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"https://api.yinmengyy.com",
                        @(KeyType_BaseURL_Pre_Release)             : @"https://preview.yinmengyy.com",
                        @(KeyType_BaiDuMTJAk)          : @"c5a8a632cf",
                        @(KeyType_Agora)               : @"c5f1fa4878d141f99f3e86ec59f619d9",
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"erban-img",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.erbanyy.com",
                        @(KeyType_NetEase)             : @"ca46478c438dda51d25306f52fe7506b",
                        @(KeyType_APNSCer)             : @"CeErRelease",
                        @(KeyType_QQAppid)             : @"1110067067",
                        @(KeyType_QQSecret)            : @"Tf8FVvGYT01Y5RHi",
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_WechatAppid)         : @"wx32c140bf1e674813",
                        @(KeyType_WechatSecret)        : @"3c24daabb31cc79f03855e293b4051f8",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        @(KeyType_AliyunLogStore)      : @"erbanlog",
                        @(KeyType_SecretaryUid)        : @"90003989",
                        @(KeyType_SystemNotifyUid)     : @"90295478",
                        @(KeyType_AliyunLogProject)    : @"erbanlog",
                        @(KeyType_AliyunLogEndPoint)   : @"cn-qingdao.log.aliyuncs.com",
                        @(KeyType_WechatUniversalLink) : @"https://7l7wu.share2dlink.com/",
                        @(KeyType_QQUniversalLink)     : @"https://7l7wu.share2dlink.com/qq_conn/1110067067"
                },
                @(YES):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"http://apibeta.yinmengyy.com",
                        @(KeyType_BaseURL_Pre_Release)             : @"https://preview.yinmengyy.com",
                        @(KeyType_BaiDuMTJAk)          : @"c5a8a632cf",
                        @(KeyType_Agora)               : @"c5f1fa4878d141f99f3e86ec59f619d9",
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"erban-img",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.erbanyy.com",
                        @(KeyType_NetEase)             : @"2c375581f900a7b4ea3922fa7643f307",
                        @(KeyType_APNSCer)             : @"qingxundebug",
                        @(KeyType_QQAppid)             : @"1110067067",
                        @(KeyType_QQSecret)            : @"Tf8FVvGYT01Y5RHi",
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_WechatAppid)         : @"wx71ff7661b637a4ed",
                        @(KeyType_WechatSecret)        : @"a6227bac88021915ed392abed24bf5e0",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        @(KeyType_AliyunLogStore)      : @"erbanlog",
                        @(KeyType_SecretaryUid)        : @"91287",
                        @(KeyType_SystemNotifyUid)     : @"94188",
                        @(KeyType_AliyunLogProject)    : @"erbanlog",
                        @(KeyType_AliyunLogEndPoint)   : @"cn-qingdao.log.aliyuncs.com",
                        @(KeyType_WechatUniversalLink) : @"https://7l7wu.share2dlink.com/",
                        @(KeyType_QQUniversalLink)     : @"https://7l7wu.share2dlink.com/qq_conn/1110067067"
                }
        },
        @"默默":@{
                @(NO):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"https://api.bmuoo.com",
                        @(KeyType_BaseURL_Pre_Release) : @"https://preview.bmuoo.com",
                        
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        
                        @(KeyType_Agora)               : @"da08bb38d4fc4fa48631af608a2cb1f0",
                        @(KeyType_NetEase)             : @"6096a480c38c5cb857cf61e43d979437",
                        @(KeyType_APNSCer)             : @"bmuoorelease",
//                        @(KeyType_QYSDK)               : @"411661bd233f0805626044b6d65fa74a",
                        @(KeyType_WJSDK)               : @"wj4uUCET4R0SarsgGFeCqyGFTdrfRBQs",
                        
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"bmuoo-img",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.bmuoo.com",
                        
                        @(KeyType_QQAppid)             : @"1109704698",
                        @(KeyType_QQSecret)            : @"EDovf0UR64acAEnf",
                        @(KeyType_WechatAppid)         : @"wx95355a1f6b2321fd",
                        @(KeyType_WechatSecret)        : @"bc16dcff1b81649bc36d99bc40bae457",
                        
                        @(KeyType_SecretaryUid)        : @"90003989",
                        @(KeyType_SystemNotifyUid)     : @"90295478",
                        
                        @(KeyType_BaiDuMTJAk)          : @"01574bab76",
                        @(KeyType_AMLocationSDKApiKey) : @"f3d3f81400a3fc942496c824634254f5",
                        @(KeyType_BuglySDKApiKey)      : @"63234b0381",
                        @(KeyType_YiDunProduceID)      : @"YD00937811914948",
                        @(KeyType_YiDunBusinessID)      : @"af43d0f8752147c48f8281800da6049e",
                        @(KeyType_ShuMeiOrganizationID): @"2qjgWI5tyNipa08YPjOt",
                },
                @(YES):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"http://apibeta.bmuoo.com",
                        @(KeyType_BaseURL_Pre_Release) : @"https://preview.bmuoo.com ",
                        
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        
                        @(KeyType_Agora)               : @"da08bb38d4fc4fa48631af608a2cb1f0",
                        @(KeyType_NetEase)             : @"6d40d0183eadcd4320610f9ef3e579bd",
                        @(KeyType_APNSCer)             : @"bmuoodebug",
//                        @(KeyType_QYSDK)               : @"411661bd233f0805626044b6d65fa74a",
                        @(KeyType_WJSDK)               : @"wj4uUCET4R0SarsgGFeCqyGFTdrfRBQs",
                        
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"bmuoo-img",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.bmuoo.com",
                        
                        @(KeyType_QQAppid)             : @"1109704698",
                        @(KeyType_QQSecret)            : @"EDovf0UR64acAEnf",
                        @(KeyType_WechatAppid)         : @"wx95355a1f6b2321fd",
                        @(KeyType_WechatSecret)        : @"bc16dcff1b81649bc36d99bc40bae457",
                        
                        @(KeyType_SecretaryUid)        : @"91287",
                        @(KeyType_SystemNotifyUid)     : @"94188",
                        
                        @(KeyType_BaiDuMTJAk)          : @"01574bab76",
                        @(KeyType_AMLocationSDKApiKey) : @"5ce098f3aa8b4e8f73f8a7839eb6e36a",
                        @(KeyType_BuglySDKApiKey)      : @"0ae847b11d",
                        @(KeyType_YiDunProduceID)      : @"YD00937811914948",
                        @(KeyType_YiDunBusinessID)      : @"af43d0f8752147c48f8281800da6049e",
                        @(KeyType_ShuMeiOrganizationID): @"2qjgWI5tyNipa08YPjOt",
                }
        },
        @"耳萌":@{
                @(NO):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"https://api.kuaixiangwl.com",
                        @(KeyType_BaseURL_Pre_Release) : @"https://preview.kuaixiangwl.com",
                        
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        
                        @(KeyType_Agora)               : @"62e170bdce314eb7a62eaca4a49ae6f3",
                        @(KeyType_NetEase)             : @"6b25cc9494815e9da2048b65f30ef546",
                        @(KeyType_APNSCer)             : @"catASMRrelease",
//                        @(KeyType_QYSDK)               : @"411661bd233f0805626044b6d65fa74a",
                        @(KeyType_WJSDK)               : @"0pfJU3wdmO2DsU7E7H4e0p7nHrYNDTjM",
                        
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"catchear",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.kuaixiangwl.com",
                        
                        @(KeyType_QQAppid)             : @"1106975719",
                        @(KeyType_QQSecret)            : @"kx6dzYrNQ1lQV7g7",
                        @(KeyType_WechatAppid)         : @"wx2e2a5962a8db2892",
                        @(KeyType_WechatSecret)        : @"72859700fef0171fa3ad8cff55037ccb",
                        @(KeyType_WechatUniversalLink) : @"https://www.ormatch.com/",
                        
                        @(KeyType_GKAppid)             : @"w50TrCWXed6ArF8kt56r23",
                        @(KeyType_GKAppKey)            : @"6BHtdpxx5PABQtsDuE0Ma2",
                        @(KeyType_GKAppSecret)         : @"hIuLw0ovToAmGIWXFNIZE9",
                        
                        @(KeyType_UMappAppKey)         : @"5b51f321f43e487f390001b6",
                        @(KeyType_UMChannelId)         : @"appstore_ermeng2",
                        
                        @(KeyType_SecretaryUid)        : @"90000983",
                        @(KeyType_SystemNotifyUid)     : @"90000985",
                        @(KeyType_HudongMessageUid)    : @"90000984",
                        
                        @(KeyType_BaiDuMTJAk)          : @"01574bab76",
                        @(KeyType_AMLocationSDKApiKey) : @"f3d3f81400a3fc942496c824634254f5",
                        @(KeyType_BuglySDKApiKey)      : @"d657599028",
                        @(KeyType_YiDunProduceID)      : @"YD00937811914948",
                        @(KeyType_YiDunBusinessID)     : @"af43d0f8752147c48f8281800da6049e",
                        @(KeyType_ShuMeiOrganizationID): @"2qjgWI5tyNipa08YPjOt",
                        @(KeyType_CLShanYanAppID)      : @"3nYlKDsm",
                        @(KeyType_QQUniversalLink)     : @"https://srcb3.share2dlink.com/qq_conn/1106975719"
                },
                @(YES):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"http://apibeta.kuaixiangwl.com",
                        @(KeyType_BaseURL_Pre_Release) : @"https://api.kuaixiangwl.com",
                        
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        
                        @(KeyType_Agora)               : @"62e170bdce314eb7a62eaca4a49ae6f3",
                        @(KeyType_NetEase)             : @"12eaff09070e15329c7e022f670d0b64",
                        @(KeyType_APNSCer)             : @"catASMRdebug",
//                        @(KeyType_QYSDK)               : @"411661bd233f0805626044b6d65fa74a",
                        @(KeyType_WJSDK)               : @"NC4Nfa9PkBbsdWoBjoXKfrC5gS68lLIi",
                        
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"catchear",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.kuaixiangwl.com",
                        
                        @(KeyType_QQAppid)             : @"1106975719",
                        @(KeyType_QQSecret)            : @"kx6dzYrNQ1lQV7g7",
                        @(KeyType_WechatAppid)         : @"wx2e2a5962a8db2892",
                        @(KeyType_WechatSecret)        : @"72859700fef0171fa3ad8cff55037ccb",
                        @(KeyType_WechatUniversalLink) : @"https://www.ormatch.com/",
                        
                        @(KeyType_GKAppid)             : @"w50TrCWXed6ArF8kt56r23",
                        @(KeyType_GKAppKey)            : @"6BHtdpxx5PABQtsDuE0Ma2",
                        @(KeyType_GKAppSecret)         : @"hIuLw0ovToAmGIWXFNIZE9",
                        
                        @(KeyType_UMappAppKey)         : @"5b51f321f43e487f390001b6",
                        @(KeyType_UMChannelId)         : @"appstore_ermeng2",
                        
                        @(KeyType_SecretaryUid)        : @"90000983",
                        @(KeyType_SystemNotifyUid)     : @"90000985",
                        @(KeyType_HudongMessageUid)    : @"90000984",
                        
                        @(KeyType_BaiDuMTJAk)          : @"01574bab76",
                        @(KeyType_AMLocationSDKApiKey) : @"5ce098f3aa8b4e8f73f8a7839eb6e36a",
                        @(KeyType_BuglySDKApiKey)      : @"e87dbdec34",
                        @(KeyType_YiDunProduceID)      : @"YD00937811914948",
                        @(KeyType_YiDunBusinessID)     : @"af43d0f8752147c48f8281800da6049e",
                        @(KeyType_ShuMeiOrganizationID): @"2qjgWI5tyNipa08YPjOt",
                        @(KeyType_CLShanYanAppID)      : @"bZGzfuk7",
                        @(KeyType_QQUniversalLink)     : @"https://srcb3.share2dlink.com/qq_conn/1106975719"
                }
        },
        @"猫耳":@{
                @(NO):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"https://api.kuaixiangwl.com",
                        @(KeyType_BaseURL_Pre_Release) : @"https://preview.kuaixiangwl.com",
                        
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        
                        @(KeyType_Agora)               : @"62e170bdce314eb7a62eaca4a49ae6f3",
                        @(KeyType_NetEase)             : @"6b25cc9494815e9da2048b65f30ef546",
                        @(KeyType_APNSCer)             : @"catASMRrelease",
//                        @(KeyType_QYSDK)               : @"411661bd233f0805626044b6d65fa74a",
                        @(KeyType_WJSDK)               : @"0pfJU3wdmO2DsU7E7H4e0p7nHrYNDTjM",
                        
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"catchear",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.kuaixiangwl.com",
                        
                        @(KeyType_QQAppid)             : @"101713616",
                        @(KeyType_QQSecret)            : @"f80ff8013ce7d1114bb4289e4558a991",
                        @(KeyType_WechatAppid)         : @"wx3848473f01c89bff",
                        @(KeyType_WechatSecret)        : @"7c1da08f166c27db8eefee530d1e5080",
                        @(KeyType_WechatUniversalLink) : @"https://rpcco.share2dlink.com/",
                        
                        @(KeyType_GKAppid)             : @"w50TrCWXed6ArF8kt56r23",
                        @(KeyType_GKAppKey)            : @"6BHtdpxx5PABQtsDuE0Ma2",
                        @(KeyType_GKAppSecret)         : @"hIuLw0ovToAmGIWXFNIZE9",
                        
                        @(KeyType_UMappAppKey)         : @"5b51f321f43e487f390001b6",
                        @(KeyType_UMChannelId)         : @"appstore_cat",
                        
                        @(KeyType_SecretaryUid)        : @"90000983",
                        @(KeyType_SystemNotifyUid)     : @"90000985",
                        @(KeyType_HudongMessageUid)    : @"90000984",
                        
                        @(KeyType_BaiDuMTJAk)          : @"01574bab76",
                        @(KeyType_AMLocationSDKApiKey) : @"f3d3f81400a3fc942496c824634254f5",
                        @(KeyType_BuglySDKApiKey)      : @"55f17f9586",
                        @(KeyType_YiDunProduceID)      : @"YD00937811914948",
                        @(KeyType_YiDunBusinessID)      : @"af43d0f8752147c48f8281800da6049e",
                        @(KeyType_ShuMeiOrganizationID): @"2qjgWI5tyNipa08YPjOt",
                },
                @(YES):@{
                        @(KeyType_NetWork)             : @"TTEnv",
                        @(KeyType_BaseURL)             : @"http://apibeta.kuaixiangwl.com",
                        @(KeyType_BaseURL_Pre_Release) : @"https://api.kuaixiangwl.com",
                        
                        @(KeyType_SignKey)             : @"yytduo3xmm33uymtd0r8dkj42uu1a5sb",
                        @(KeyType_PwdEncode)           : @"pk4wwipi3ygeg4jmfwd4xaau6li878zg",
                        @(KeyType_ParamsEncode)        : @"x023fwcfxqbmfk5p1vsgdv8zu91f15sv",
                        
                        @(KeyType_Agora)               : @"62e170bdce314eb7a62eaca4a49ae6f3",
                        @(KeyType_NetEase)             : @"12eaff09070e15329c7e022f670d0b64",
                        @(KeyType_APNSCer)             : @"catASMRdebug",
//                        @(KeyType_QYSDK)               : @"411661bd233f0805626044b6d65fa74a",
                        @(KeyType_WJSDK)               : @"NC4Nfa9PkBbsdWoBjoXKfrC5gS68lLIi",
                        
                        @(KeyType_QiNiuAK)             : @"_yrUANU6t3YGhNXZzdMNt03EhqDKUvFZ3oSbAAKJ",
                        @(KeyType_QiNiuSK)             : @"PJ-NZ_qc0cabSebH2A9eYsodgRMFqV3tOFbP2Grr",
                        @(KeyType_QiNiuBucketName)     : @"catchear",
                        @(KeyType_QiNiuBaseURL)        : @"https://img.kuaixiangwl.com",
                        
                        @(KeyType_QQAppid)             : @"101713616",
                        @(KeyType_QQSecret)            : @"f80ff8013ce7d1114bb4289e4558a991",
                        @(KeyType_WechatAppid)         : @"wx3848473f01c89bff",
                        @(KeyType_WechatSecret)        : @"7c1da08f166c27db8eefee530d1e5080",
                        @(KeyType_WechatUniversalLink) : @"https://rpcco.share2dlink.com/",
                        
                        @(KeyType_GKAppid)             : @"w50TrCWXed6ArF8kt56r23",
                        @(KeyType_GKAppKey)            : @"6BHtdpxx5PABQtsDuE0Ma2",
                        @(KeyType_GKAppSecret)         : @"hIuLw0ovToAmGIWXFNIZE9",
                        
                        @(KeyType_UMappAppKey)         : @"5b51f321f43e487f390001b6",
                        @(KeyType_UMChannelId)         : @"appstore_cat",
                        
                        @(KeyType_SecretaryUid)        : @"90000983",
                        @(KeyType_SystemNotifyUid)     : @"90000985",
                        @(KeyType_HudongMessageUid)    : @"90000984",

                        @(KeyType_BaiDuMTJAk)          : @"01574bab76",
                        @(KeyType_AMLocationSDKApiKey) : @"5ce098f3aa8b4e8f73f8a7839eb6e36a",
                        @(KeyType_BuglySDKApiKey)      : @"5139aa9230",
                        @(KeyType_YiDunProduceID)      : @"YD00937811914948",
                        @(KeyType_YiDunBusinessID)      : @"af43d0f8752147c48f8281800da6049e",
                        @(KeyType_ShuMeiOrganizationID): @"2qjgWI5tyNipa08YPjOt",
                }
        },
        
    };
    NSDictionary *appKeys = [keys objectForKey:MyAppName];
    NSDictionary *envKeys = [appKeys objectForKey:@(isDebug)];
    return [envKeys objectForKey:@(type)];
}



NSString * const idWithRobotId(NSInteger userID, BOOL isDebug) {
    
    NSArray *userIDArray = @[@"90184705",@"90184715",@"908150",@"908152",@"90453774",@"90453777",@"90453776"];  // 用户Uid
    
    for (NSString *userIDStr in userIDArray) {
        if ([userIDStr integerValue] == userID) {
            
            NSMutableArray *robotIDArray = [NSMutableArray array];
            if (isDebug) {
                [robotIDArray addObject:@"903851"]; // 测试环境机器人ID
            } else {
                NSArray *robotArray = @[@"90014856",@"90052723",@"90125063",@"90125023",@"90054063",@"90053323"];
                [robotIDArray addObjectsFromArray:robotArray]; // 正式环境机器人ID
            }
            if (robotIDArray.count >= 1) {
                NSInteger index = arc4random() % robotIDArray.count;
                
                return [robotIDArray objectAtIndex:index];
            } else {
                return nil;
            }
        }
    }
    return nil;
}
