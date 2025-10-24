//
//  FaceConfigInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/12/1.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XCFaceDisplayTypeOnlyOne = 0,
    XCFaceDisplayTypeFlow = 1,
    XCFaceDisplayTypeOverLay = 2,
    XCFaceDisplayTypeOnlyOneLine = 3,
} XCFaceDisplayType;

typedef enum : NSUInteger {
    XCFaceType_Face = 1,//1 正常表情，需要在表情面板显示
    XCFaceType_Dragon = 2,// 2 龙珠
    XCFaceType_PlayTogether = 3, //一起玩
} XCFaceType;

@interface FaceConfigInfo : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, assign) NSInteger animDuration;
@property (nonatomic, assign) NSInteger animEndPos;
@property (nonatomic, assign) NSInteger animStartPos;
@property (nonatomic, assign) NSInteger iconPos;
@property (nonatomic, assign) NSInteger animRepeatCount;
@property (nonatomic, assign) NSInteger resultCount;
@property (nonatomic, assign) BOOL canResultRepeat;
@property (nonatomic, assign) NSInteger resultDuration;
@property (nonatomic, assign) NSInteger resultEndPos;
@property (nonatomic, assign) NSInteger resultStartPos;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) XCFaceDisplayType displayType;
@property (nonatomic, assign) BOOL isNobleFace; //是否贵族表情
@property (nonatomic, assign) int nobleId;//贵族等级
@property (nonatomic, assign) XCFaceType faceType;//1 正常表情，需要在表情面板显示, 2 龙珠 3.一起玩
@property (nonatomic, assign) BOOL isLuckFace;//YES 表示审核中需要隐藏的表情，NO 审核中不需要隐藏的表情
@end
