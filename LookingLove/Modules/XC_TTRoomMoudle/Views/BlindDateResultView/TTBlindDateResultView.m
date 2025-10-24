//
//  TTBlindDateResultView.m
//  WanBan
//
//  Created by lvjunhang on 2020/10/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTBlindDateResultView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "XCHUDTool.h"

#import "SVGAPlayer.h"
#import "SVGAParserManager.h"

#import <Masonry/Masonry.h>
#import "SDWebImage/SDWebImageManager.h"

//svga纵横比
#define SVGA_ASPECT_RATIO 1032/580.0

@interface TTBlindDateResultView()<SVGAPlayerDelegate>

@property (nonatomic, strong) RoomLoveModelSuccess *model;

@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
@property (nonatomic, strong) SVGAParserManager *svgaManager;

@property (nonatomic, strong) UIImageView *resultImageView;

@property (nonatomic, strong) UIView *successContainerView;
@property (nonatomic, strong) UIImageView *firstAvatarImageView;//头像一
@property (nonatomic, strong) UIImageView *secondAvatarImageView;//头像二
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation TTBlindDateResultView

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = UIScreen.mainScreen.bounds;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickView)];
        [self addGestureRecognizer:tap];
        
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    
    [self addSubview:self.svgaPlayer];
    [self addSubview:self.resultImageView];
    [self addSubview:self.successContainerView];
    [self.successContainerView addSubview:self.firstAvatarImageView];
    [self.successContainerView addSubview:self.secondAvatarImageView];
    [self.successContainerView addSubview:self.nameLabel];
    [self.successContainerView addSubview:self.shareButton];

    [self.svgaPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.svgaPlayer.mas_width).multipliedBy(SVGA_ASPECT_RATIO);
    }];
    
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.successContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    CGFloat baseHeight = 658;
    CGFloat realHeight = KScreenWidth * SVGA_ASPECT_RATIO;
    CGFloat heightRatio = realHeight / baseHeight;
    [self.firstAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.svgaPlayer).offset(307 * heightRatio);
        make.left.mas_equalTo((KScreenWidth-65-66*2)/2);
        make.width.height.mas_equalTo(66);
    }];
    
    [self.secondAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstAvatarImageView);
        make.left.mas_equalTo(self.firstAvatarImageView.mas_right).offset(65);
        make.width.height.mas_equalTo(66);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstAvatarImageView.mas_bottom).offset(42 * heightRatio);
        make.left.right.mas_equalTo(self).inset(86);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(38 * heightRatio);
        make.left.right.mas_equalTo(self).inset(97);
        make.height.mas_equalTo(44);
    }];
}

- (void)handleResult:(RoomLoveModelSuccess *)model {
    self.model = model;
    
    if (model.resultType == 111) {
        // 失败
        [self handleFailureWithImage:model.picUrl];
    } else {
        // 成功
        [self handleSuccessWithSvgURL:model.vggUrl resultType:model.resultType avatar1:model.avatar avatar2:model.choseAvatar name1:model.nick name2:model.choseNick];
    }
}

- (void)handleFailureWithImage:(NSString *)image {
    self.successContainerView.hidden = YES;
    self.successContainerView.alpha = 0;
    
    [self.resultImageView qn_setImageImageWithUrl:image placeholderImage:XCTheme.defaultTheme.placeholder_image_rectangle type:ImageTypeUserLibaryDetail];
    
    [self autoDismissAfterDelay];
}

- (void)handleSuccessWithSvgURL:(NSString *)svgURL resultType:(NSInteger)resultType avatar1:(NSString *)avatar1 avatar2:(NSString *)avatar2 name1:(NSString *)name1 name2:(NSString *)name2 {
    
    self.successContainerView.hidden = NO;
    
    [self.firstAvatarImageView qn_setImageImageWithUrl:avatar1 placeholderImage:XCTheme.defaultTheme.default_avatar type:ImageTypeCornerAvatar cornerRadious:33];
    [self.secondAvatarImageView qn_setImageImageWithUrl:avatar2 placeholderImage:XCTheme.defaultTheme.default_avatar type:ImageTypeCornerAvatar cornerRadious:33];
    
    self.nameLabel.text = self.model.nickStr;
    
    [self loadSvgaAnimation:svgURL];
    self.successContainerView.alpha = 0;
    
    @KWeakify(self)
    if (resultType == 112) {
        [UIView animateWithDuration:0.5 animations:^{
            @KStrongify(self)
            self.successContainerView.alpha = 1;
        }];
    } else {
        //高级动画有2.5秒延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            @KStrongify(self)
            [UIView animateWithDuration:0.5 animations:^{
                @KStrongify(self)
                self.successContainerView.alpha = 1;
            }];
        });
    }
}

- (void)loadSvgaAnimation:(NSString *)svgURL {
    if (!svgURL) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:svgURL];
    if (!url) {
        return;
    }
    
    @KWeakify(self);
    [self.svgaManager loadSvgaWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.svgaPlayer.videoItem = videoItem;
        [self.svgaPlayer startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)onClickView {
}

- (void)onClickShareButton:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    
    if (!self.model.picUrl) {
        [XCHUDTool showErrorWithMessage:@"分享图片失败"];
        sender.userInteractionEnabled = YES;
        return;
    }
    
    NSURL *url = [NSURL URLWithString:self.model.picUrl];
    if (!url) {
        [XCHUDTool showErrorWithMessage:@"分享图片失败"];
        sender.userInteractionEnabled = YES;
        return;
    }
    
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:url completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        if (!image) {
            [XCHUDTool showErrorWithMessage:@"分享图片失败"];
            sender.userInteractionEnabled = YES;
            return;
        }
        
        !self.shareHandler ?: self.shareHandler(image);
        [self saveImage:image];
        [self removeFromSuperview];
    }];
}

- (void)saveImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}

/// 定时自动移除
- (void)autoDismissAfterDelay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    [self autoDismissAfterDelay];
}

#pragma mark - Getter
- (SVGAPlayer *)svgaPlayer {
    if (!_svgaPlayer) {
        _svgaPlayer = [[SVGAPlayer alloc] init];
        _svgaPlayer.delegate = self;
        _svgaPlayer.loops = 1;
        _svgaPlayer.clearsAfterStop = NO;
        _svgaPlayer.fillMode = @"Forward";
        _svgaPlayer.userInteractionEnabled = YES;
    }
    return _svgaPlayer;
}

- (SVGAParserManager *)svgaManager {
    if (!_svgaManager) {
        _svgaManager = [[SVGAParserManager alloc] init];
    }
    return _svgaManager;
}

- (UIImageView *)resultImageView {
    if (!_resultImageView) {
        _resultImageView = [[UIImageView alloc] init];
        _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _resultImageView;
}

- (UIView *)successContainerView {
    if (!_successContainerView) {
        _successContainerView = [[UIView alloc] init];
        _successContainerView.backgroundColor = UIColor.clearColor;
        _successContainerView.alpha = 0;
    }
    return _successContainerView;
}

- (UIImageView *)firstAvatarImageView {
    if (!_firstAvatarImageView) {
        _firstAvatarImageView = [[UIImageView alloc] init];
        _firstAvatarImageView.layer.masksToBounds = YES;
        _firstAvatarImageView.layer.cornerRadius = 33;
        _firstAvatarImageView.layer.borderWidth = 2;
        _firstAvatarImageView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    return _firstAvatarImageView;
}

- (UIImageView *)secondAvatarImageView {
    if (!_secondAvatarImageView) {
        _secondAvatarImageView = [[UIImageView alloc] init];
        _secondAvatarImageView.layer.masksToBounds = YES;
        _secondAvatarImageView.layer.cornerRadius = 33;
        _secondAvatarImageView.layer.borderWidth = 2;
        _secondAvatarImageView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    return _secondAvatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = UIColorFromRGB(0x7B3CCE);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"保存图片并分享到动态" forState:UIControlStateNormal];
        [_shareButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _shareButton.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
        _shareButton.layer.cornerRadius = 22;
        _shareButton.layer.masksToBounds = YES;
        
        [_shareButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

@end
