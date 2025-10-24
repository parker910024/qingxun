//
//  TTLittleWorldPartyListView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldPartyListView.h"
//view
#import "TTLittleWorldNavView.h"
#import "TTLittleWorldPartyTableViewCell.h"
#import "TTLittleWordlEmptyTableViewCell.h"
//第三方类
#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>
//XC类
#import "XCMacros.h"
#import "XCTheme.h"
#import "UITableView+Refresh.h"
#import "NSArray+Safe.h"
#import "BaseAttrbutedStringHandler.h"
//XC_tt类
#import "TTPopup.h"
//core
#import "UserCore.h"
#import "AuthCore.h"
#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
//bridge
#import "XCMediator+TTRoomMoudleBridge.h"

@interface TTLittleWorldPartyListView ()<UITableViewDelegate, UITableViewDataSource, LittleWorldCoreClient>
/** 顶部的View*/
@property (nonatomic,strong) TTLittleWorldNavView *navView;
/** 列表*/
@property (nonatomic,strong) UITableView *tableView;
/** 底部view*/
@property (nonatomic,strong) UIView *footView;
/** 显示文字*/
@property (nonatomic,strong) YYLabel *titleLabel;
/** 数据源*/
@property (nonatomic,strong) NSMutableArray<TTLittleWorldPartyModel *> *datasource;

/**  派对模型 是不是开房间 派对列表*/
@property (nonatomic,strong) TTLittleWorldPartyListModel *listModel;

/** 当前页数*/
@property (nonatomic,assign) int page;

@end


@implementation TTLittleWorldPartyListView

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addCore];
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - public methods
#pragma mark - delegate
- (void)requestLittleWorldTeamPartySuccess:(TTLittleWorldPartyListModel *)listModel status:(int)status {
    if (listModel.worldRoomVoList.count == 0 && status == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadNumberPersonWhenRequestListEmpty)]) {
            [self.delegate reloadNumberPersonWhenRequestListEmpty];
        }
    }
    self.listModel = listModel;
    self.hasParty = self.listModel.hasCurrentUserRoom;
    if (self.page == 1) {
        self.datasource = [listModel.worldRoomVoList mutableCopy];
    }else {
        [self.datasource addObjectsFromArray:listModel.worldRoomVoList];
    }
    if (listModel.worldRoomVoList.count > 0) {
        [self.tableView endRefreshStatus:status hasMoreData:YES];
    }else {
        [self.tableView endRefreshStatus:status hasMoreData:NO];
    }
    [self.tableView reloadData];
}

- (void)requestLittleWorldTeamPartyFail:(NSString *)message status:(int)status {
    [self.tableView endRefreshStatus:status];
}

#pragma mark - UITableViewDelegate  and UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count > 0 ? self.datasource.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datasource.count > 0) {
        return 90;
    }
    return CGRectGetHeight(self.frame)- 49 - 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datasource.count == 0) {
        TTLittleWordlEmptyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTLittleWordlEmptyTableViewCell class])];
        if (cell == nil) {
            cell = [[TTLittleWordlEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TTLittleWordlEmptyTableViewCell class])];
        }
        return cell;
    }else {
        TTLittleWorldPartyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTLittleWorldPartyTableViewCell class])];
        if (cell == nil) {
            cell = [[TTLittleWorldPartyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TTLittleWorldPartyTableViewCell class])];
        }
        cell.partyModel = [self.datasource safeObjectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - event response
- (void)enterRoom:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttLittleWorldPartyListView:didClickEnterRoomWithHasParty:)]) {
        [self.delegate ttLittleWorldPartyListView:self didClickEnterRoomWithHasParty:self.listModel.hasCurrentUserRoom];
    }
}


#pragma mark - http
- (void)pullDownRefresh:(int)page {
    self.page = page;
    [GetCore(LittleWorldCore) requestLittleWorldTeamPartyListWithWorldId:self.worldId page:self.page pageSize:20 status:0];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    self.page = page;
    if (isLastPage) {
        return;
    }
    [GetCore(LittleWorldCore) requestLittleWorldTeamPartyListWithWorldId:self.worldId page:self.page pageSize:20 status:1];
}

#pragma mark - private method

- (void)addCore {
    AddCoreClient(LittleWorldCoreClient, self);
}

- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.navView];
    [self addSubview:self.footView];
    [self addSubview:self.tableView];

    [self.footView addSubview:self.titleLabel];
    
    [self.tableView registerClass:[TTLittleWordlEmptyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTLittleWordlEmptyTableViewCell class])];
    [self.tableView registerClass:[TTLittleWorldPartyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTLittleWorldPartyTableViewCell class])];
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, KScreenWidth, 49) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    layer.path = bezier.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    [self.navView.layer insertSublayer:layer atIndex:0];
    

    
    self.titleLabel.attributedText = [self creatLittleWorldPartyAttribut];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterRoom:)];
    [self.titleLabel addGestureRecognizer:tap];
    self.tableView.tableViewHeightOnScreen = 1;;
    @weakify(self);
    
    [self.tableView setupRefreshFunctionWith:RefreshTypeHeaderAndFooter];
    
    [self.tableView pullDownRefresh:^(int page) {
        @strongify(self);
        [self pullDownRefresh:1];
    }];
    
    [self.tableView pullUpRefresh:^(int page, BOOL isLastPage) {
        @strongify(self);
        [self pullUpRefresh:page lastPage:isLastPage];
    }];
    

}

- (void)initContrations {
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(49);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.bottom.mas_equalTo(self.footView.mas_top);
    }];
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(63+kSafeAreaBottomHeight + 18);
    }];
    

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.footView).offset(28);
        make.right.mas_equalTo(self.footView).offset(-28);
        make.bottom.mas_equalTo(self.footView).offset(-20- kSafeAreaBottomHeight);
        make.height.mas_equalTo(43);
    }];
}

- (NSMutableAttributedString *)creatLittleWorldPartyAttribut {
    NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] init];
    if (_hasParty) {
        NSString * str = @"进入我的房间";
        [attribut appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:str attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        [attribut appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:10]];
        [attribut appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 7, 11) urlString:nil imageName:@"littleworld_owner_party_arrow"]];
    }else {
        NSString * str = @"创建语音派对";
       [attribut appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:str attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    }
    return attribut;
}

#pragma mark - setters and getters
- (void)setHasParty:(BOOL)hasParty {
    _hasParty = hasParty;
    self.titleLabel.attributedText = [self creatLittleWorldPartyAttribut];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setWorldId:(UserID)worldId {
    _worldId = worldId;
    if (_worldId) {
       [self pullDownRefresh:1];
    }
}

- (TTLittleWorldNavView *)navView {
    if (!_navView) {
        _navView = [[TTLittleWorldNavView alloc] init];
        _navView.isShowBack = NO;
        _navView.isShowLine = YES;
        _navView.title = @"派对列表";
        _navView.backgroundColor = [UIColor clearColor];
    }
    return _navView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = [UIColor whiteColor];
    }
    return _footView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = 43/2;
        _titleLabel.backgroundColor = [XCTheme getTTMainColor];
        if ([GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole == XCUserInfoPlatformRoleSuperAdmin) {
            _titleLabel.hidden = YES;
        }
    }
    return _titleLabel;
}

- (NSMutableArray<TTLittleWorldPartyModel *> *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

@end
