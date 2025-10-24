//
//  YYEmptyContentToastView.m
//  YYMobile
//
//  Created by wuwei on 14/7/30.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "YYEmptyContentToastView.h"
#import <Masonry.h>
#import "XCMacros.h"

@implementation YYEmptyContentToastView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
//        [self initConstrations];
    }
    return self;
}
#pragma mark - private method

- (void)initView {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
}

- (void)initConstrations {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(100);
        make.centerX.top.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(5);
    }];
}

+ (instancetype)instantiateEmptyContentToast
{
    YYEmptyContentToastView *view = [[YYEmptyContentToastView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    view.imageView.image = [UIImage imageNamed:@"praised_list_empty"];
    
    return view;
}

+ (instancetype)instantiateNetworkErrorToast
{
    YYEmptyContentToastView *view =  [[YYEmptyContentToastView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    view.imageView.image = [UIImage imageNamed:@"network_error.png"];
    
    return view;
}

+ (instancetype)instantiateEmptyContentToastWithImage:(UIImage*)image
{
    YYEmptyContentToastView *view =  [[YYEmptyContentToastView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    view.imageView.image = image;
    view.titleLabel.text = @"";
    return view;
}

+ (instancetype)instantiateEmptyContentToastWithImage:(UIImage *)image andTile:(NSString *)title
{
    CGSize imageSize;
    CGSize contentViewSize;
    CGSize titleSize;
    if (image.size.width > 250) {
        imageSize.width = image.size.width * 0.7;
        imageSize.height = image.size.height * 0.7;
    }else{
        imageSize = image.size;
    }
    
    if (title.length > 0) {
        titleSize = [title boundingRectWithSize:CGSizeMake(KScreenWidth, KScreenHeight) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    }
   
    if (titleSize.width > 0 && titleSize.width > imageSize.width && titleSize.width < KScreenWidth) {
        contentViewSize.width = titleSize.width;
        contentViewSize.height = imageSize.height + 30;
    }else{
        contentViewSize.width = imageSize.width;
        contentViewSize.height = imageSize.height + 30;
    }
    
    if (contentViewSize.width == 0) {
        contentViewSize = CGSizeMake(250, 290);
    }
    
    
    YYEmptyContentToastView *view =  [[YYEmptyContentToastView alloc] initWithFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
    view.imageView.frame = CGRectMake((contentViewSize.width - imageSize.width)/ 2, 0, imageSize.width, imageSize.height);
    view.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(view.imageView.frame) + 5, contentViewSize.width, 15);
    view.imageView.image = image;
    view.titleLabel.text = @"";
    return view;
    
}

#pragma mark - getters and setters

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
