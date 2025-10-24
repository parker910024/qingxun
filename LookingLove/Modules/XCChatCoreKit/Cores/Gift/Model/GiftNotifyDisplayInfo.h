//
//  GiftNotifyDisplayInfo.h
//  BberryCore
//

#import <UIKit/UIKit.h>
#import "BaseObject.h"

@interface GiftNotifyDisplayInfo : BaseObject

/**
 通知背景
 */
@property (nonatomic,strong) UIImage *notifyBg;

/**
 喊话背景
 */
@property (nonatomic,strong) UIImage *speakingBg;

/**
 名字背景
 */
@property (nonatomic,strong) UIImage *nameLabelBg;

/**
 围观背景
 */
@property (nonatomic,strong) UIImage *goImageBg;

/**
 “赠送”字样的图片
 */
@property (nonatomic,strong) UIImage *giveTypeBg;

/**
 头像背景图片
 */
@property (nonatomic,strong) UIImage *headCycleBg;

/**
 遮罩图片
 */
@property (nonatomic,strong) UIImage *scaleBg;

/**
 关闭按钮背景
 */
@property (nonatomic,strong) UIImage *closeBtnBg;

@end
