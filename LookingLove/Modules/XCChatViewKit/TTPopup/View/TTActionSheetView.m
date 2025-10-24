//
//  TTActionSheetView.m
//  XC_TTChatViewKit
//
//  Created by lee on 2019/5/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTActionSheetView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "TTActionSheetConfig.h"

static CGFloat const kSheetViewCellHeight = 51.f;
static CGFloat const kSheetViewCornerRadius = 14.f;
static NSString *const kSheetViewCellConst = @"kSheetViewCellConst";

@interface TTActionSheetView ()<UITableViewDelegate, UITableViewDataSource>

/** sheetView 载体 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSArray<TTActionSheetConfig *> *items;
/** 是否需要显示取消按钮 */
@property (nonatomic, assign) BOOL needCancel;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation TTActionSheetView

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithFrame:(CGRect)frame needCancel:(BOOL)needCancel items:(NSArray<TTActionSheetConfig *> *)items {
    self = [super initWithFrame:frame];
    if (self) {
        _items = items;
        _needCancel = needCancel;
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    [self addSubview:self.cancelButton];
}

- (void)initConstraints {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(self.items.count * kSheetViewCellHeight);
    }];
    
    if (_needCancel) {
        // 显示 cancel view
        self.cancelButton.hidden = NO;
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(kSheetViewCellHeight);
            make.top.mas_equalTo(self.tableView.mas_bottom).offset(15);
        }];
    }
    
}

#pragma mark -
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSheetViewCellConst];
    cell.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _items[indexPath.row].title;
    cell.textLabel.textColor = _items[indexPath.row].titleColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 配置中的事件处理
    TTActionSheetConfig *config = _items[indexPath.row];
    !config.clickAction ?: config.clickAction();
    
    !_dismissAction ?: _dismissAction();
}

#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response
- (void)onClickCancelButtonAction:(UIButton *)cancelButton {
    !_cancelAction ?: _cancelAction();
    !_dismissAction ?: _dismissAction();
}

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Private Methods

#pragma mark -
#pragma mark Getters and Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColorFromRGB(0xF0F0F0);
        _tableView.rowHeight = kSheetViewCellHeight;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.cornerRadius = kSheetViewCornerRadius;
        _tableView.layer.masksToBounds = YES;
        _tableView.bounces = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSheetViewCellConst];
    }
    return _tableView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:UIColor.whiteColor];
        [_cancelButton setTitleColor:UIColorFromRGB(0x4d4d4d) forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _cancelButton.layer.cornerRadius = kSheetViewCornerRadius;
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton addTarget:self action:@selector(onClickCancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.hidden = YES;
    }
    return _cancelButton;
}

@end
