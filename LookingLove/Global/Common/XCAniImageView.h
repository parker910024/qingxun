//
//  XCAniImageView.h
//  CeEr
//
//  Created by icholab on 2021/4/6.
//  Copyright © 2021 WUJIE INTERACTIVE. All rights reserved.
//

#import <YYWebImage/YYWebImage.h>

@class XCAniImageConfigurSvgaModel;
NS_ASSUME_NONNULL_BEGIN
//封面图片类型，1:gif，2:svga
typedef NS_ENUM(NSInteger,XCAniImageType){
    XCAniImageGif = 1,
    XCAniImageSVGA,
    XCAniMp4,
    XCAniImageNormal    //普通图片，走sd下载，会快很多
};
@interface XCAniImageView : UIImageView

- (void)xc_setImageWithURL:(NSURL *)url withType:(XCAniImageType)type placeholder:(UIImage *)image;
- (void)xc_setImageWithURL:(NSURL *)url placeholder:(UIImage *)image;
- (void)xc_setImageWithURL:(NSURL *)url withType:(XCAniImageType)type;
- (void)configureSvgaModel:(XCAniImageConfigurSvgaModel *)model;   //关于svga的配置信息

- (BOOL)isPlaySvga;

- (void)clearVideoItem;

- (void)stopAnimating;

- (void)reset;
- (void)replay;
- (XCAniImageConfigurSvgaModel *)svgaModel;

- (void)showSvgaIamage:(BOOL)isShow;    //避免频繁刷新引起
@end

@interface XCAniImageConfigurSvgaModel : NSObject
@property (nonatomic, assign) int  playCount;     //播放次数
@property (nonatomic, strong) NSString *replaceKey;     //替换的image url
@property (nonatomic, strong) NSString *replaceUrl;        //替换的头像地址

@property (nonatomic, strong) NSString *replaceHeaderAroundKey;     //替换的image url
@property (nonatomic, strong) NSString *replaceHeaderAroundUrl;        //替换的key

@property (nonatomic, strong) NSString  *replaceNickKey;    //替换昵称key
@property (nonatomic, strong) NSString  *replaceNickName;    //替换昵称name

@property (nonatomic, strong) NSString  *mp4Url;    //MP4地址
@property (nonatomic, strong) NSString  *staticPic;

@property (nonatomic, assign) CGFloat  rio; //mp4 资源宽高比例

@property (nonatomic, copy) void (^finshCallBack)(UIView *view);



@end
NS_ASSUME_NONNULL_END
