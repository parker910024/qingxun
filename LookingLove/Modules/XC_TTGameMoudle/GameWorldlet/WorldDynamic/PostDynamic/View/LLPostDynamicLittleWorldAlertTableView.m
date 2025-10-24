//
//  LLPostDynamicLittleWorldAlertTableView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/1/9.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLPostDynamicLittleWorldAlertTableView.h"

#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "NSArray+Safe.h"
#import "UITableView+Refresh.h"
#import "XCEmptyDataView.h"

#import <Masonry/Masonry.h>

static NSString *const kCellId = @"kCellId";

@implementation LLPostDynamicLittleWorldAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.desLabel];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(44);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView).offset(4);
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(10);
            make.right.mas_equalTo(-20);
        }];
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
            make.left.right.mas_equalTo(self.nameLabel);
        }];
    }
    return self;
}

#pragma mark - Setter Getter
- (void)setModel:(LittleWorldDynamicPostWorld *)model {
    _model = model;
    
    _nameLabel.text = model.worldName;
    _desLabel.text = model.desc;
    [_avatarImageView qn_setImageImageWithUrl:model.icon placeholderImage:XCTheme.defaultTheme.placeholder_image_rectangle type:ImageTypeCornerAvatar cornerRadious:5];
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = XCTheme.getTTMainTextColor;
    }
    return _nameLabel;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.textColor = XCTheme.getTTDeepGrayTextColor;
    }
    return _desLabel;
}

@end

@interface LLPostDynamicLittleWorldAlertTableView ()
<
UITableViewDelegate,
UITableViewDataSource,
LittleWorldCoreClient
>

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) XCEmptyDataView *emptyDataView;

@end

@implementation LLPostDynamicLittleWorldAlertTableView

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        AddCoreClient(LittleWorldCoreClient, self);

        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 70;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[LLPostDynamicLittleWorldAlertViewCell class] forCellReuseIdentifier:kCellId];
        
        [self setupRefreshFunctionWith:RefreshTypeHeaderAndFooter];
        @weakify(self)
        [self pullDownRefresh:^(int page) {
            @strongify(self)
            [self requestDataWithRefresh:YES];
        }];
        
        [self pullUpRefresh:^(int page, BOOL isLastPage) {
            @strongify(self)
            [self requestDataWithRefresh:NO];
        }];
    }
    return self;
}

#pragma mark - Request
- (void)requestDataWithRefresh:(BOOL)refresh {
    if (refresh) {
        self.page = 1;
    }
    
    [GetCore(LittleWorldCore) requestWorldDynamicPostWorldListWithType:self.requestType page:self.page];
}

#pragma mark - Actions
- (void)didTapEmptyView {
    [self requestDataWithRefresh:YES];
}

#pragma mark - LittleWorldCoreClient
/// 动态发布里的世界列表
- (void)responseWorldDynamicPostWorldList:(NSArray<LittleWorldDynamicPostWorld *> *)data type:(DynamicPostWorldRequestType)type code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    [self endRefreshStatus:0];
    [self endRefreshStatus:1];

    if (type != self.requestType) {
        return;
    }
    
    if (self.page == 1) {
        [self.dataArray removeAllObjects];
    }
    
    if (data && data.count > 0) {
        self.page += 1;
        [self.dataArray addObjectsFromArray:data];
    }
    
    [self reloadData];
    
    self.emptyDataView.hidden = self.dataArray.count > 0;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLPostDynamicLittleWorldAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    LittleWorldDynamicPostWorld *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LittleWorldDynamicPostWorld *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    !self.selectWorldHandler ?: self.selectWorldHandler(model);
}

#pragma mark - Setter Getter
- (void)setRequestType:(DynamicPostWorldRequestType)requestType {
    _requestType = requestType;
    
    [self requestDataWithRefresh:YES];
    
    if (requestType == DynamicPostWorldRequestTypeMine) {
        self.emptyDataView.title = @"还没加入任何小世界哦~";
    }
}

- (NSMutableArray<LittleWorldDynamicPostWorld *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSInteger)page {
    return MAX(1, _page);
}

- (XCEmptyDataView *)emptyDataView {
    if (!_emptyDataView) {
        
        UIImage *image = [UIImage imageNamed:@"dynamic_comment_empty_icon"];
        
        _emptyDataView = [[XCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 400)];
        _emptyDataView.title = @"暂无数据";
        _emptyDataView.messageLabel.textColor = UIColorFromRGB(0xb3b3b3);
        _emptyDataView.messageLabel.font = [UIFont systemFontOfSize:14];
        _emptyDataView.image = image;
        _emptyDataView.imageFrame = CGRectMake((KScreenWidth - 150)/2, 80, 150, 150);
        _emptyDataView.margin = -40;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapEmptyView)];
        [_emptyDataView addGestureRecognizer:tapGR];
        
        _emptyDataView.hidden = YES;
        
        [self addSubview:_emptyDataView];
    }
    return _emptyDataView;
}

@end
