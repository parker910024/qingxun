//
//  TTGroupManagerModel.h
//  TuTu
//
//  Created by gzlx on 2018/11/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, TTGroupManagerModelType){
    TTGroupManagerModelType_Subtitle =1,//只有副标题
    TTGroupManagerModelType_Verifica = 2,//是是不是消息验证或者消息免打扰
    TTGroupManagerModelType_Avatar = 3,//头像
    TTGroupManagerModelType_SubtitleArrow= 4,//副标题和箭头
    TTGroupManagerModelType_SubtitlHidden = 5,//没有副标题
};


@interface TTGroupManagerModel : BaseObject
/** 标题*/
@property (strong, nonatomic) NSString *title;
/** 标题的字体*/
@property (strong, nonatomic) UIFont *titleFont;
/** 标题的颜色*/
@property (strong, nonatomic) NSString *titleColor;
/** 副标题*/
@property (strong, nonatomic) NSString *subTitle;
/** 是不是开启进群审核*/
@property (assign, nonatomic) BOOL switchStatus;
/** 头像*/
@property (strong, nonatomic) NSString *avatar;
@property (nonatomic,assign) TTGroupManagerModelType disPlayType;
//Cell 的高度
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
