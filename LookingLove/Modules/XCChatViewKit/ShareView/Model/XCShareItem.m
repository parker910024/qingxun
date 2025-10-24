//
//  XCShareItem.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/9/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCShareItem.h"

@implementation XCShareItem

+ (instancetype)itemWitTag:(XCShareItemTag)itemTag title:(NSString *)title imageName:(NSString *)imageName disableImageName:(NSString *)disableImageName disable:(BOOL)disable{
    XCShareItem *item = [[self alloc] init];
    item.itemTag = itemTag;
    item.title = title;
    item.imageName = imageName;
    item.disableImageName = disableImageName;
    item.disable = disable;
    return item;
}

@end
