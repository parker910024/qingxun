//
//  TTSessionGuideView.m
//  AFNetworking
//
//  Created by apple on 2019/6/6.
//

#import "TTSessionGuideView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

@interface TTSessionGuideView ()

@property (nonatomic, strong) UIImageView *guideImageView;

@end

@implementation TTSessionGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
        [self initConstraint];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.guideImageView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGes];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (self.chatterbox) {
        self.chatterbox();
    }
    [self removeFromSuperview];
}

- (void)initConstraint {
    [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

- (UIImageView *)guideImageView {
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] init];
        if (iPhoneXSeries) {
            _guideImageView.image = [UIImage imageNamed:@"chatterbox_guild_x_0"];
        } else {
           _guideImageView.image = [UIImage imageNamed:@"chatterbox_guild_0"];
        }
    }
    return _guideImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
