//
//  XC_MSRichTextParser.h
//  XC_MSMessageMoudle
//
//  Created by gzlx on 2018/10/26.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "MessageBussiness.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTSessionRichTextParser : BaseObject
@property (weak, nonatomic) UINavigationController *navigationController;
+ (instancetype)shareParser;
- (void)creatMessageContentAttributeWithMessageBusiness:(MessageBussiness *)messageBussiness
                                              messageId:(NSString *)messageId
                                      completionHandler:(void (^)(NSMutableAttributedString *))completionHandler
                                                failure:(void (^) (NSError *))failure;

- (void)creatP2PInteractiveAttrWith:(P2PInteractive_SkipType)skipType
                        routerValue:(NSString *)routerValue
                         andAttrStr:(NSMutableAttributedString *)attrStr
                          fontColor:(UIColor *)fontColor;

+ (NSMutableAttributedString *)setUpAttrInteractiveWithAttrStr:(NSMutableAttributedString *)attrStr
                                                     fontColor:(UIColor *)fontColor
                                              interactiveBlock:(void(^)(void))interactiveBlock;
@end

NS_ASSUME_NONNULL_END
