//
//  XCShareItem.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/9/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XCShareItemTagReport, //举报
    XCShareItemTagAppFriends, //应用好友
    XCShareItemTagWeChat, //微信好友
    XCShareItemTagMoments, //微信朋友圈
    XCShareItemTagQQ, //QQ好友
    XCShareItemTagQQZone, //QQ空间
    XCShareItemTagWeibo, //新浪微博
    XCShareItemTagDelete,//删除
    XCShareItemTagCopyright,//版权
    XCShare_Platfrom_Type_FaceBook, //FaceBook
} XCShareItemTag;

@interface XCShareItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *disableImageName;
@property (nonatomic, assign) BOOL disable;
@property (nonatomic, assign) XCShareItemTag itemTag;

+ (instancetype)itemWitTag:(XCShareItemTag)itemTag title:(NSString *)title imageName:(NSString *)imageName disableImageName:(NSString *)disableImageName disable:(BOOL)disable;

@end
