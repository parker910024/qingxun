//
//  TTBaseContributionViewController.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTBaseContributionViewController.h"
//view
#import "TTBaseContributionTableHeaderView.h"

//cate
#import "UITableView+Refresh.h"
//t
#import <Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "RankData.h"

///房间榜单需更新接口通知
NSString *const TTBaseContributionViewControllerShouldUpdateDataNoti = @"TTBaseContributionViewControllerShouldUpdateData";

@interface TTBaseContributionViewController ()
@property (nonatomic, strong) UILabel *emptyLabel;
@end

@implementation TTBaseContributionViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:TTBaseContributionViewControllerShouldUpdateDataNoti object:nil];
}

- (void)initSubView {
    [self.view addSubview:self.tableView];
    self.headView.type = self.type;
    
    CGFloat height = self.type == TTRoomContributionTypeHalfhour ? 192 : 192;
    
    self.headView.frame = CGRectMake(0, 0, KScreenWidth, height);
    self.tableView.tableHeaderView = self.headView;
}

#pragma mark - UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == TTRoomContributionTypeHalfhour) {
        RankData *data = [self.dataArray safeObjectAtIndex:indexPath.row];
        if ([data isKindOfClass:RankData.class] && self.selectUserBlock) {
            self.selectUserBlock(data.uid);
        }
    } else {
        RoomBounsListInfo *data = [self.dataArray safeObjectAtIndex:indexPath.row];
        if ([data isKindOfClass:RoomBounsListInfo.class] && self.selectUserBlock) {
            self.selectUserBlock(data.uid);
        }
    }
}

#pragma mark - public
- (void)addEmpty {
    [self.tableView addSubview:self.emptyLabel];
    self.emptyLabel.frame = CGRectMake(0, 0, 80, 40);
    self.emptyLabel.center = CGPointMake(KScreenWidth/2, CGRectGetMaxY(self.headView.frame)+50);
}

- (void)removeEmpty {
    if(self.emptyLabel.superview) {
        [self.emptyLabel removeFromSuperview];
    }
}

- (void)updateData {
    
}

#pragma mark - Getter && Setter

- (TTBaseContributionTableHeaderView *)headView {
    if (!_headView) {
        _headView = [[TTBaseContributionTableHeaderView alloc] init];
        @weakify(self)
        _headView.selectedBlcok = ^(UserID uid) {
            @strongify(self)
            !self.selectUserBlock ?: self.selectUserBlock(uid);
        };
    }
    return _headView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.screenOrigin = 1;
        _tableView.rowHeight = 55;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.textColor = UIColorFromRGB(0x999999);
        _emptyLabel.font = [UIFont systemFontOfSize:14];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.text = @"暂无用户\n...";
        _emptyLabel.numberOfLines = 0;
    }
    return _emptyLabel;
}

@end
