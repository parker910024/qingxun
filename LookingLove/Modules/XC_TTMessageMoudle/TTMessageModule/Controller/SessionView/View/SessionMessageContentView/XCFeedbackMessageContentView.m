//
//  XCFeedbackMessageContentView.m
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2020/5/9.
//  Copyright © 2020 WJHD. All rights reserved.
//

#import "XCFeedbackMessageContentView.h"

#import "FeedbackAttachment.h"

#import "XCTheme.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+QiNiu.h"
#import "XCMacros.h"

#import "NSObject+YYModel.h"
#import <Masonry/Masonry.h>

@interface XCFeedbackMessageContentView()<SDPhotoBrowserDelegate>
@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIView *backView;//背景
@property (nonatomic, strong) UILabel *subtitleLabel;//副标题
@property (nonatomic, strong) UILabel *uidLabel;//用户id(举报）
@property (nonatomic, strong) UILabel *nickLabel;//昵称(举报）
@property (nonatomic, strong) UILabel *contentLabel;//内容
@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组

@property (nonatomic, strong) UILabel *replyLabel;//回复

@end


@implementation XCFeedbackMessageContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        [self initView];
        [self layoutSubViewFrame];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    FeedbackAttachment *attach = (FeedbackAttachment*)object.attachment;
    
    self.titleLabel.text = attach.msg;
    self.contentLabel.text = attach.content;
    self.replyLabel.text = attach.reply;
    
    BOOL isReport = attach.replyType == 0;
    self.subtitleLabel.text = isReport ? @"您的举报内容：" : @"您的反馈内容：";
    self.uidLabel.hidden = !isReport;
    self.nickLabel.hidden = !isReport;
    
    if (isReport) {
        self.uidLabel.text = [@"用户ID：" stringByAppendingString:attach.erbanNo];
        self.nickLabel.text = [@"用户昵称：" stringByAppendingString:attach.nick];
        
        NSString *content = [@"举报内容：" stringByAppendingString:attach.content];
        NSRange range = [content rangeOfString:attach.content];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
        [str addAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xFF4A6F)} range:range];
        
        self.contentLabel.attributedText = str;
    }
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.backView).inset(10);

        if (isReport) {
            make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(6);
        } else {
            make.top.mas_equalTo(self.subtitleLabel.mas_bottom).offset(12);
        }
        
        if (attach.imgList.count == 0) {
            make.bottom.mas_equalTo(-10);
        }
    }];
    
    for (UIImageView *imageView in self.imageArray) {
        [imageView removeFromSuperview];
    }
    [self.imageArray removeAllObjects];
    
    for (NSInteger index = 0; index<attach.imgList.count; index++) {
        if (index>=4) {
            break;
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 100 + index;
        imageView.userInteractionEnabled = YES;
        [imageView qn_setImageImageWithUrl:attach.imgList[index] placeholderImage:nil type:ImageTypeUserLibaryDetail];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 8;
        imageView.layer.masksToBounds = YES;
        [self.backView addSubview:imageView];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImageView:)];
        [imageView addGestureRecognizer:tapGR];
        
        UIImageView *lastView = self.imageArray.lastObject;
        CGFloat width = (KScreenWidth - 106 - 16*2 - 10*2 - 8*3)/4;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(12);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(imageView.mas_width);
            
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(8);
            } else {
                make.left.mas_equalTo(10);
            }
        }];
        
        //图片添加到数组
        [self.imageArray addObject:imageView];
    }

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = self.imageArray[index];
    return imageView.image;
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    NIMCustomObject *object = (NIMCustomObject *)self.model.message.messageObject;
    FeedbackAttachment *attach = (FeedbackAttachment*)object.attachment;
    NSString *img = attach.imgList[index];
    NSURL *url = [NSURL URLWithString:img];
    
    return url;
}

- (void)didClickImageView:(UITapGestureRecognizer *)tap {
    
    NIMCustomObject *object = (NIMCustomObject *)self.model.message.messageObject;
    FeedbackAttachment *attach = (FeedbackAttachment*)object.attachment;
    
    UIImageView *img = (UIImageView *)tap.view;
    NSInteger index = img.tag - 100;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = img;
    browser.delegate = self;
    browser.imageCount = attach.imgList.count;
    browser.currentImageIndex = index;
    [browser show];
}

- (void)initView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.backView];
    [self addSubview:self.replyLabel];
    
    [self.backView addSubview:self.subtitleLabel];
    [self.backView addSubview:self.uidLabel];
    [self.backView addSubview:self.nickLabel];
    [self.backView addSubview:self.contentLabel];
}

- (void)layoutSubViewFrame {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.right.mas_equalTo(self).inset(16);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.right.mas_equalTo(self.titleLabel);
    }];
    
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_bottom).offset(12);
        make.left.right.mas_equalTo(self.titleLabel);
        make.bottom.mas_lessThanOrEqualTo(0).priorityLow();
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.right.mas_equalTo(self.backView).inset(10);
    }];
    
    [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subtitleLabel.mas_bottom).offset(12);
        make.left.right.mas_equalTo(self.backView).inset(10);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uidLabel.mas_bottom).offset(6);
        make.left.right.mas_equalTo(self.backView).inset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(6);
        make.left.right.mas_equalTo(self.backView).inset(10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _backView.layer.cornerRadius = 8;
    }
    return _backView;
}

- (UILabel *)replyLabel {
    if (_replyLabel == nil) {
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.textColor = [XCTheme getTTMainTextColor];
        _replyLabel.font = [UIFont systemFontOfSize:14];
        _replyLabel.numberOfLines = 0;
    }
    return _replyLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [XCTheme getTTMainTextColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        _subtitleLabel.text = @"您的举报内容：";
    }
    return _subtitleLabel;
}

- (UILabel *)uidLabel {
    if (_uidLabel == nil) {
        _uidLabel = [[UILabel alloc] init];
        _uidLabel.textColor = UIColorFromRGB(0x999999);
        _uidLabel.font = [UIFont systemFontOfSize:14];
        _uidLabel.hidden = YES;
    }
    return _uidLabel;
}

- (UILabel *)nickLabel {
    if (_nickLabel == nil) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = UIColorFromRGB(0x999999);
        _nickLabel.font = [UIFont systemFontOfSize:14];
        _nickLabel.hidden = YES;
    }
    return _nickLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x999999);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

@end


