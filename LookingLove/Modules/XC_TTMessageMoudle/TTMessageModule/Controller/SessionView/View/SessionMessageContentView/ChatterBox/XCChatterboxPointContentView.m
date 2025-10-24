//
//  XCChatterboxPointContentView.m
//  AFNetworking
//
//  Created by apple on 2019/6/3.
//

#import "XCChatterboxPointContentView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

#import "XCChatterboxAttachment.h"
#import "TTChatterboxGameModel.h"

@interface XCChatterboxPointContentView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *cornerView;
@property (nonatomic, strong) UIImageView *pointImageView;

@end

@implementation XCChatterboxPointContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        
        [self initView];
        
        [self layoutSubviewsWithFrame];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    
    XCChatterboxAttachment *customObject = (XCChatterboxAttachment*)object.attachment;
    
    TTChatterboxGameModel *customModel = [TTChatterboxGameModel modelDictionary:customObject.data];
    
    self.pointImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"chatterboxPoint_0%d",customModel.pointCount]];
}

- (void)initView {
    
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.cornerView];
    
    [self.backView addSubview:self.pointImageView];
    
}

- (void)layoutSubviewsWithFrame {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.pointImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.center.mas_equalTo(self.backView);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _backView;
}

- (UIView *)cornerView {
    if (!_cornerView) {
        _cornerView = [[UIView alloc] init];
        _cornerView.layer.cornerRadius = 12;
        _cornerView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _cornerView;
}

- (UIImageView *)pointImageView {
    if (!_pointImageView) {
        _pointImageView = [[UIImageView alloc] init];
    }
    return _pointImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
