//
//  TTGameMenuView.m
//  XC_TTGameMoudle
//
//  Created by lee on 2019/6/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameMenuView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"

#import "TTGameMenuCell.h"
#import "TTGameMenuModel.h"

@interface TTGameMenuView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) NSArray<TTGameMenuModel *> *items;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation TTGameMenuView

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initMenuViewWithItems:(NSArray<TTGameMenuModel *> *)items menuRect:(CGRect)menuRect {
    self = [super init];
    if (self) {
        _items = items;
        [self initViews];
        [self initConstraints];
        [self.tableView setFrame:menuRect];
        [self.maskImageView setFrame:menuRect];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
//    [self addSubview:self.maskImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addViewGestureRecognizer:)];
    [self.maskView addGestureRecognizer:tap];
}

- (void)initConstraints {
    self.frame = [UIScreen mainScreen].bounds;
}

- (void)addViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self dismiss];
}

- (void)dismiss {
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf removeFromSuperview];
        !strongSelf.dismissBlock ?: strongSelf.dismissBlock();
    }];
}

#pragma mark -
#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTTGameMenuCellConst];
    TTGameMenuModel *model = self.items[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = model.titleColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    !_selectBlock ?: _selectBlock(indexPath.row);
   
    [self dismiss];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response

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
        _tableView.rowHeight = 44;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TTGameMenuCell class] forCellReuseIdentifier:kTTGameMenuCellConst];
        _tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        _tableView.layer.cornerRadius = 14.f;
    }
    return _tableView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
        _maskImageView.image = [UIImage imageNamed:@"home_list_title_bg"];
    }
    return _maskImageView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _maskView;
}

@end
