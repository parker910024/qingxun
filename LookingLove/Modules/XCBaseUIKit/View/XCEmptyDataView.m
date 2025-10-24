//
//  XCEmptyDataView.m
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCEmptyDataView.h"
#import "XCTheme.h"
#import "XCMacros.h"

@interface XCEmptyDataView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation XCEmptyDataView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        self.imageView.bounds = CGRectMake((KScreenWidth - 190)*0.5, 100, 190, 140);
        self.margin = 18;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.messageLabel.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame)+self.margin, self.frame.size.width - 40, 28 * 4);
}

- (void)setTitle:(NSString *)title{
    self.messageLabel.text = title;
}

- (void)setColor:(UIColor *)color {
    self.messageLabel.textColor = color;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    if (_imageName != nil) {
        self.imageView.image = [UIImage imageNamed:@"noNetword_empty"];
        self.messageLabel.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame)+18, self.frame.size.width - 40, 28 * 4);
    }
}

-(void)setImageFrame:(CGRect)imageFrame
{
    _imageFrame = imageFrame;
    self.imageView.frame = _imageFrame;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

#pragma mark - Private
- (void)setupSubviews{
    [self addSubview:self.imageView];
    [self addSubview:self.messageLabel];
}


#pragma mark - Getter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"praised_list_empty"];
        //        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = UIColorFromRGB(0x808080);
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text = @"暂无内容";
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}




@end
