//
//  TTFamilyGuideView.m
//  TuTu
//
//  Created by gzlx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyGuideView.h"
#import "UIView+Layout.h"
#import "XCMacros.h"

typedef void(^isShow)(BOOL show);

@interface TTFamilyGuideView()
@property (nonatomic, assign) FamilyGuideType guideType;
@property (nonatomic, weak) UIView *parentView;//展示的View
@property (nonatomic, strong) UIImageView *btnMaskView;
@property (nonatomic, weak) UIButton * maskBtn;//高亮的btn
@property (nonatomic, weak) UIView * maskView;//高亮的view
@property (nonatomic, strong) UIView *topMaskView;//上边的
@property (nonatomic, strong) UIView *bottomMaskView;//下边的
@property (nonatomic, strong) UIView *leftMaskView;//左边的
@property (nonatomic, strong) UIView *rightMaskView;//右边的
@property (nonatomic, strong) UIImageView * arrowImageView;//箭头
@property (nonatomic, strong) UIImageView * knowImageView;//知道了
@property (nonatomic, strong) UIImageView * contentImageView;//内容的
//共有的参数
@property (nonatomic, copy) isShow show;
@property (nonatomic, strong) UIImageView * maskImageView;//蒙层

@end

@implementation TTFamilyGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topMaskView];
        [self addSubview:self.bottomMaskView];
        [self addSubview:self.leftMaskView];
        [self addSubview:self.rightMaskView];
        [self addSubview:self.btnMaskView];
        [self addSubview:self.arrowImageView];
        [self addSubview:self.contentImageView];
        [self addSubview:self.knowImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = _parentView.bounds;
    
    [self configContentFrame];
    
    _topMaskView.left = 0;
    _topMaskView.top = 0;
    _topMaskView.height = _btnMaskView.top;
    _topMaskView.width = self.width;
    
    _bottomMaskView.left = 0;
    _bottomMaskView.top = _btnMaskView.bottom;
    _bottomMaskView.width = self.width;
    _bottomMaskView.height = self.height - _bottomMaskView.bottom;
    
    _leftMaskView.left = 0;
    _leftMaskView.top = _btnMaskView.top;
    _leftMaskView.width = _btnMaskView.left;
    _leftMaskView.height = _btnMaskView.height;
    
    _rightMaskView.left = _btnMaskView.right;
    _rightMaskView.top = _btnMaskView.top;
    _rightMaskView.width = self.width - _rightMaskView.right;
    _rightMaskView.height = _btnMaskView.height;
    
}


- (void)showInView:(UIView *)parentview maskView:(UIView *)view guideType:(FamilyGuideType)type dismiss:(void (^)(BOOL))show{
    self.parentView = parentview;
    self.maskView = view;
    self.guideType = type;
    self.alpha = 0;
    self.show = show;
    [parentview addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:nil];
}

- (void)showInView:(UIView *)view maskBtn:(nullable UIButton *)btn guideType:(FamilyGuideType)type dismiss:(void (^)(BOOL))show{
    self.parentView = view;
    self.maskBtn = btn;
    self.guideType = type;
    self.alpha = 0;
    self.show = show;
    [view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.show(YES);
        [self removeFromSuperview];
    }];
}

#pragma mark - 根据类型判断显示的frame
- (void)configContentFrame{
    if (self.guideType == FamilyGuideType_Share) {
        self.btnMaskView.image = [UIImage imageNamed:@"family_share_bg"];
        self.arrowImageView.image = [UIImage imageNamed:@"family_share_arrow"];
        self.contentImageView.image = [UIImage imageNamed:@"family_share_content"];
        self.knowImageView.image = [UIImage imageNamed:@"family_guide_sure"];
        CGRect rect  = [_maskView convertRect:_maskView.bounds toView:_parentView];
        rect.size = CGSizeMake(40, 40);
        rect.origin = CGPointMake(self.width - 43 - 45 , 22+ kSafeAreaTopHeight);
        _btnMaskView.frame = rect;
        
        self.arrowImageView.top = _btnMaskView.centerY;
        self.arrowImageView.size = CGSizeMake(172, 199);
        self.arrowImageView.right = _btnMaskView.centerX;
        
        self.knowImageView.size = CGSizeMake(142, 60);
        self.knowImageView.top = self.height - 168;
        self.knowImageView.left = (self.width - 142)/2;
        
        self.contentImageView.size = CGSizeMake(250 , 75);
        self.contentImageView.top = _arrowImageView.bottom + 2;
        self.contentImageView.left = (self.width -250)/2;
    }else if(self.guideType == FamilyGuideType_Group){
        self.btnMaskView.image = [UIImage imageNamed:@"family_group_bg"];
        self.arrowImageView.image = [UIImage imageNamed:@"family_group_arrow"];
        self.contentImageView.image = [UIImage imageNamed:@"family_group_content"];
        self.knowImageView.image = [UIImage imageNamed:@"family_guide_sure"];
        CGRect rect  = [_maskView convertRect:_maskView.bounds toView:_parentView];
        CGSize oldSize = rect.size;
        CGPoint oldPoint = rect.origin;
        rect.size = CGSizeMake(112, 26);
        CGFloat width = rect.size.width - oldSize.width;
        CGFloat height = rect.size.height - oldSize.height;
        rect.origin = CGPointMake(oldPoint.x- width / 2, oldPoint.y - height / 2);
        
        _btnMaskView.frame = rect;
        
        self.arrowImageView.top = _btnMaskView.top - 269;
        self.arrowImageView.size = CGSizeMake(162, 278);
        self.arrowImageView.left = self.width - 186;
        if (self.parentView.frame.size.width > 320) {
            self.knowImageView.size = CGSizeMake(142, 60);
            self.knowImageView.top = self.height - 168;
            self.knowImageView.left = (self.width - 142)/2;
        }else{
            self.knowImageView.size = CGSizeMake(142, 60);
            self.knowImageView.top = self.height - 220;
            self.knowImageView.left = (self.width - 142)/2;
        }
        
        
        self.contentImageView.size = CGSizeMake(253 , 79);
        self.contentImageView.top = _arrowImageView.top -74;
        self.contentImageView.left = (self.width - 264)/2;
    }else if (self.guideType == FamilyGuideType_Manager){
        self.btnMaskView.image = [UIImage imageNamed:@"family_manager_bg"];
        self.arrowImageView.image = [UIImage imageNamed:@"family_manager_arrow"];
        self.contentImageView.image = [UIImage imageNamed:@"family_manager_content"];
        self.knowImageView.image = [UIImage imageNamed:@"family_guide_sure"];
        CGRect rect  = [_maskView convertRect:_maskView.bounds toView:_parentView];
        CGSize oldSize = rect.size;
        CGPoint oldPoint = rect.origin;
        rect.size = CGSizeMake(91, 36);
        CGFloat widht = rect.size.width - oldSize.width;
        CGFloat height = rect.size.height - oldSize.height;
        rect.origin = CGPointMake(oldPoint.x - widht /2  , oldPoint.y - height / 2);
        _btnMaskView.frame = rect;
        self.arrowImageView.top = _btnMaskView.top + 4;
        self.arrowImageView.size = CGSizeMake(171, 190);
        self.arrowImageView.left = self.btnMaskView.right - 10;

        self.contentImageView.size = CGSizeMake(271 , 80);
        self.contentImageView.top = _arrowImageView.bottom + 14;
        self.contentImageView.left = (self.width - 271)/2;
        if (self.parentView.bounds.size.width > 320) {
            self.knowImageView.size = CGSizeMake(138, 55);
            self.knowImageView.top = self.height - 168;
            self.knowImageView.left = (self.width - 138)/2;
        }else{
            self.knowImageView.size = CGSizeMake(138, 55);
            self.knowImageView.top = self.contentImageView.bottom + 20;
            self.knowImageView.left = (self.width - 138)/2;
        }
       
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_knowImageView addGestureRecognizer:tap];
}


- (UIImageView *)maskImageView
{
    if (_maskImageView == nil) {
        _maskImageView = [[UIImageView alloc] init];
        _maskImageView.userInteractionEnabled = YES;
    }
    return _maskImageView;
}


#pragma mark - getter and setter

- (UIImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
    }
    return _contentImageView;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
    }
    return _arrowImageView;
}


- (UIImageView *)knowImageView{
    if (!_knowImageView) {
        _knowImageView = [[UIImageView alloc] init];
        _knowImageView.userInteractionEnabled = YES;
    }
    return _knowImageView;
}

- (UIImageView *)btnMaskView {
    if (!_btnMaskView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _btnMaskView = imageView;
    }
    return _btnMaskView;
}

- (UIView *)topMaskView {
    if (!_topMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _topMaskView = view;
    }
    return _topMaskView;
}

- (UIView *)bottomMaskView {
    if (!_bottomMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _bottomMaskView = view;
    }
    return _bottomMaskView;
}

- (UIView *)leftMaskView {
    if (!_leftMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _leftMaskView = view;
    }
    return _leftMaskView;
}

- (UIView *)rightMaskView {
    if (!_rightMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _rightMaskView = view;
    }
    return _rightMaskView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
