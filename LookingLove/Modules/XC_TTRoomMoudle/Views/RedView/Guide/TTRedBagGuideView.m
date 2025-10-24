//
//  TTRedBagGuideView.m
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/18.
//

#import "TTRedBagGuideView.h"
@interface TTRedBagGuideView()
@property (nonatomic, strong)UIImageView *imgView;
@end

@implementation TTRedBagGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.imgView];
}

#pragma mark - Action
- (void)tapClick {
    self.didFinishGuide();
    [self removeFromSuperview];
}

#pragma mark - Setter && Getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.frame];
        _imgView.image = [UIImage imageNamed:@"redbag_guide"];
        _imgView.userInteractionEnabled = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [_imgView addGestureRecognizer:tap];
    }
    return _imgView;
}

@end
