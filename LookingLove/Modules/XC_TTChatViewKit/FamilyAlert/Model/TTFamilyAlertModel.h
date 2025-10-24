//
//  TTFamilyAlertModel.h
//  TuTu
//
//  Created by gzlx on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyAlertModel : BaseObject
/** 提示的文字 如果没有就默认是提示*/
@property (nonatomic, strong) NSString * tipString;
/** 内容*/
@property (nonatomic, strong) NSString * content;
/** 内容的字体 默认颜色333333*/
@property (nonatomic, strong) UIColor * contentColor;
/** 内容的行间距，默认不设置，当值为 0 或负数时无效 */
@property (nonatomic, assign) CGFloat contentLineSpacing;
/** 内容中需要变颜色的文字*/
@property (nonatomic, strong) NSString * changeColorString;
/** 所需要变的颜色*/
@property (nonatomic, strong) UIColor * changeColor;
/** 变化的字体*/
@property (nonatomic, strong) UIFont * changeFont;
#pragma mark - 公会
/** 需要改变颜色的文字(非第一次被改变的) */
@property (nonatomic, strong) NSString *moreChangeColorStr;
/** 所需要变的颜色 (非第一次被改变的)*/
@property (nonatomic, strong) UIColor * moreChangeColor;

#pragma mark -转让家族bi
/**
 转让给谁
 */
@property (nonatomic, strong) NSString * contribuMember;
#pragma mark - 输入框
/** 是不是显示输入框 默认不显示*/
@property (nonatomic, assign) BOOL textFiledHidden;
/** 输入框的默认展位字符串*/
@property (nonatomic, strong) NSString * placeHolder;
/** 键盘的样式*/
@property (nonatomic, assign) UIKeyboardType keyboardType;
/** 输入框是不是显示家族bi*/
@property (nonatomic, assign) BOOL isShowMon;
/** 家族b名称*/
@property (nonatomic, strong) NSString * familyMon;
#pragma mark - 按钮的配置
/** 左边按钮的配置
 font:字体
 textColor:字体颜色
 text:显示的文字
 backColor:背景颜色
 */
@property (nonatomic, strong) NSDictionary * leftConfigDic;

/** 右边按钮的配置
 font:字体
 textColor:字体颜色
 text:显示的文字
 backColor:背景颜色
 */
@property (nonatomic, strong) NSDictionary * rightConfigDic;

#pragma mark - 分享给好友使用
/** 头像*/
@property (nonatomic, strong) NSString * familyMemberIcon;
/** 名字*/
@property (nonatomic, strong) NSString * familyMemberName;
@end

NS_ASSUME_NONNULL_END
