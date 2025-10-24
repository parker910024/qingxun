//
//  LinkedMeClient.h
//  BberryCore
//
//  Created by gzlx on 2017/7/17.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LinkedMeClient <NSObject>
@optional

- (void)jumpInRoomWithRoomid:(NSString *)uid;
- (void)jumpInFamilyWithFamilyId:(NSString *)familyId;
- (void)jumpInWebViewWithh5Url:(NSString *)h5Url;

/**
 跳转到小世界客态页

 @param worldId 小世界id
 */
- (void)jumpInLittleWorldHomePageWithWorldId:(NSString *)worldId;

/// 跳转到小世界动态详情页
/// @param worldID 小世界id
/// @param dynamicID 举报id
- (void)jumpInLittleWorldDynamicDetailPageWithWorldId:(NSString *)worldID
                                            dynamicID:(NSString *)dynamicID;
@end
