//
//  AnchorOrderDataPickerView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/29.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "AnchorOrderDataPickerView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "HomeTag.h"
#import "TTPopup.h"
#import "XCCurrentVCStackManager.h"
#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>

@interface AnchorOrderDataPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation AnchorOrderDataPickerView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    /// 设置默认宽高
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initView];
        [self initConstraints];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapEmptyAreaAction)];
        tapGR.delegate = self;
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //设置圆角
    CGSize radio = CGSizeMake(10, 10);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.pickerBgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    masklayer.frame = self.pickerBgView.bounds;
    masklayer.path = path.CGPath;
    self.pickerBgView.layer.mask = masklayer;
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.pickerBgView];
    [self.pickerBgView addSubview:self.pickerView];
    [self.pickerBgView addSubview:self.closeButton];
}

- (void)initConstraints {
    [self.pickerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.pickerBgView);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(6);
    }];
}

- (void)didTapEmptyAreaAction {
    [TTPopup dismiss];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 如果点击UICollectionView就执行手势，否则不执行
    if ([touch.view isKindOfClass:[self class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - Public Methods
- (void)showAlert {
    [TTPopup popupView:self style:TTPopupStyleActionSheet];
}

#pragma mark - Event Response
- (void)closeButtonTapped:(UIButton *)sender {
    [TTPopup dismiss];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataList.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [pickerView selectRow:row inComponent:component animated:NO];
    NSString *data = self.dataList[row];
    !self.selectHandler ?: self.selectHandler(data);
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *data = self.dataList[row];
    return data;
}

#pragma mark - Getter & Setter
- (void)setSelectData:(NSString *)selectData {
    _selectData = selectData;
    
    if (selectData == nil) {
        !self.selectHandler ?: self.selectHandler(self.dataList.firstObject);
    } else {
        NSInteger findIndex = 0;
        for (NSInteger idx=0; idx<self.dataList.count; idx++) {
            NSString *content = self.dataList[idx];
            if ([selectData isEqualToString:content]) {
                findIndex = idx;
                break;
            }
        }
        
        [self.pickerView selectRow:findIndex inComponent:0 animated:NO];
    }
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = UIColorFromRGB(0xe6e6e6);
        _closeButton.layer.cornerRadius = 3;
        _closeButton.layer.masksToBounds = YES;
        
        [_closeButton enlargeTouchArea:UIEdgeInsetsMake(10, 10, 10, 10)];

        [_closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIView *)pickerBgView {
    if (_pickerBgView == nil) {
        _pickerBgView = [[UIView alloc] init];
        _pickerBgView.backgroundColor = UIColor.whiteColor;
    }
    return _pickerBgView;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = NO;
    }
    return _pickerView;
}

@end

