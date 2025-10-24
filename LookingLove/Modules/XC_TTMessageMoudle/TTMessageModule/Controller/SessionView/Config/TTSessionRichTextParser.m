//
//  XC_MSRichTextParser.m
//  XC_MSMessageMoudle
//
//  Created by gzlx on 2018/10/26.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSessionRichTextParser.h"
#import "TTWKWebViewViewController.h"

#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"

#import "ImMessageCore.h"
#import "VersionCore.h"
#import "FamilyCore.h"
#import "UIColor+UIColor_Hex.h"

#import <YYText.h>

@implementation TTSessionRichTextParser
+ (instancetype)shareParser {
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)creatMessageContentAttributeWithMessageBusiness:(MessageBussiness *)messageBussiness
                                              messageId:(NSString *)messageId
                                      completionHandler:(void (^)(NSMutableAttributedString *))completionHandler
                                                failure:(void (^) (NSError *))failure{
    
    dispatch_async(GetCore(ImMessageCore).attrCreatQueue, ^{
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
        if ([GetCore(FamilyCore)queryAttrByMessageId:messageId]) {
            AttributedStringDataModel *data = (AttributedStringDataModel *)[GetCore(FamilyCore)queryAttrByMessageId:messageId];
            if (data.isComplete) {
                dispatch_main_sync_safe(^{
                    completionHandler(data.attributedString);
                });
                return;
            }
        }
        
        
        MessageLayout *layout = messageBussiness.layout;
        for (LayoutParams *params in layout.contents) {
            if (params.content.length > 0) {
                if ([params.content containsString:@"/r/n"]) {
                    params.content = @"\r\n";
                }
                NSMutableAttributedString *subAttr = [[NSMutableAttributedString alloc]initWithString:params.content];
                if (params.fontSize.length > 0) {
                    [subAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[params.fontSize floatValue] weight:params.fontBold?UIFontWeightBold:UIFontWeightRegular] range:NSMakeRange(0, subAttr.length)];
                }
                
                if (params.fontColor.length > 0) {
                    [subAttr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:params.fontColor] range:NSMakeRange(0, subAttr.length)];
                }

                if (params.routertype > 0) {
                    [[TTSessionRichTextParser shareParser]creatP2PInteractiveAttrWith:params.routertype routerValue:params.routerValue andAttrStr:subAttr fontColor:[UIColor colorWithHexString:params.fontColor]];
                }
                
                [attr appendAttributedString:subAttr];
                
            }
        }
        attr.yy_lineSpacing = 5;
        [GetCore(FamilyCore)saveAttributedString:attr WithMessageId:messageId isComplete:YES];
        dispatch_main_sync_safe(^{
            completionHandler(attr);
        });
    });
}

- (void)creatP2PInteractiveAttrWith:(P2PInteractive_SkipType)skipType routerValue:(NSString *)routerValue andAttrStr:(NSMutableAttributedString *)attrStr fontColor:(UIColor *)fontColor  {
    
    switch (skipType) {
        case P2PInteractive_SkipType_Room:{
            
            [TTSessionRichTextParser setUpAttrInteractiveWithAttrStr:attrStr fontColor:fontColor interactiveBlock:^{
                [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:routerValue.userIDValue];
            }];
            
        }
            break;
        case P2PInteractive_SkipType_H5:
        {
            [TTSessionRichTextParser setUpAttrInteractiveWithAttrStr:attrStr fontColor:fontColor interactiveBlock:^{
                TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
                webView.url = [NSURL URLWithString:routerValue];
                [self.navigationController pushViewController:webView animated:YES];
            }];
        }
            break;
        case P2PInteractive_SkipType_Purse:
        {
            [TTSessionRichTextParser setUpAttrInteractiveWithAttrStr:attrStr fontColor:fontColor interactiveBlock:^{
                UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_goldCoinController];
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
        }
            break;
        case P2PInteractive_SkipType_Red:
        {
            [TTSessionRichTextParser setUpAttrInteractiveWithAttrStr:attrStr fontColor:fontColor interactiveBlock:^{
                UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_redDrawalsViewController];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case P2PInteractive_SkipType_Recharge:
        {
            [TTSessionRichTextParser setUpAttrInteractiveWithAttrStr:attrStr fontColor:fontColor interactiveBlock:^{
                UIViewController *vc =[[XCMediator sharedInstance]ttPersonalModule_rechargeController];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case P2PInteractive_SkipType_Person:
        {
            [TTSessionRichTextParser setUpAttrInteractiveWithAttrStr:attrStr fontColor:fontColor interactiveBlock:^{
                UIViewController *vc = [[XCMediator sharedInstance]ttPersonalModule_personalViewController:routerValue.userIDValue];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case P2PInteractive_SkipType_Car:
        {
            
            if ([routerValue integerValue] == 0) {
                //商城- 座驾
                UIViewController *dressUpVc = [[XCMediator sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:0 index:0];
                [self.navigationController pushViewController:dressUpVc animated:YES];
            }else {
                //我的装扮 - 座驾
                UIViewController *myDressVc = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:0];
                [self.navigationController pushViewController:myDressVc animated:YES];
            }
            
        }
            break;
        case P2PInteractive_SkipType_Headwear:
        {
//            if(GetCore(VersionCore).loadingData)return;
            if ([routerValue integerValue] == 0) {
                //商城-头饰
                UIViewController *headwearVC = [[XCMediator  sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:0 index:1];
                [self.navigationController pushViewController:headwearVC animated:YES];
            }else {
                //我的装扮-头饰
                UIViewController *myDressUp = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:1];
                [self.navigationController pushViewController:myDressUp animated:YES];
            }
        }
            break;
        case P2PInteractive_SkipType_Background:
        {
//            if(GetCore(VersionCore).loadingData)return;
            if ([routerValue integerValue] == 0) {
                //商城-背景
                UIViewController *backgroundVC = [[XCMediator  sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:0 index:2];
                [self.navigationController pushViewController:backgroundVC animated:YES];
            }else {
                //我的装扮-背景
                UIViewController *myDressUp = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:2];
                [self.navigationController pushViewController:myDressUp animated:YES];
            }
        }
            break;
        default:
            break;
       }
}

+ (NSMutableAttributedString *)setUpAttrInteractiveWithAttrStr:(NSMutableAttributedString *)attrStr fontColor:(UIColor *)fontColor interactiveBlock:(void(^)(void))interactiveBlock {
    [attrStr yy_setTextHighlightRange:NSMakeRange(0, attrStr.length) color:fontColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        interactiveBlock();
    }];
    return attrStr;
}

@end
