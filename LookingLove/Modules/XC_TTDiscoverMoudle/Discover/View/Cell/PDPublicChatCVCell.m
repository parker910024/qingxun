//
//  PDPublicChatCVCell.m
//  TuTu
//
//  Created by lvjunhang on 2018/12/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "PDPublicChatCVCell.h"
#import "TTHomeRecommendPublicChatSectionHeaderView.h"
#import "LLPublicHeadView.h"

#import "TTDiscoverPublicMessageCell.h"
#import "UITableView+NIMScrollToBottom.h"

#import <Masonry/Masonry.h>

#import "XCTheme.h"
#import "XCEmptyDataView.h"
#import "XCMacros.h"
#import "Attachment.h"

#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCCurrentVCStackManager.h"

CGFloat const PDPublicChatCVCellTopMargin = 50;//顶部边距
CGFloat const PDPublicChatCVCellBottomMargin = 14;//底部边距
CGFloat const PDPublicChatCVCellRows = 6;//行数
CGFloat const PDPublicChatCVCellTableViewCellHeight = 66;//cell 高度
CGFloat const PDPublicChatCVCellTableHeaderHeight = 54;//section header 高度

static NSString * kLeftChatCellID = @"kLeftChatCellID";
static NSString * kRightChatCellID = @"kRightChatCellID";
static NSString * kSectionCellID = @"kSectionCellID";

@interface PDPublicChatCVCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) LLPublicHeadView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XCEmptyDataView *emptyDataView;
@end

@implementation PDPublicChatCVCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        [self.contentView addSubview:self.tableView];
        self.discoverType = NO;
        
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
             _emptyDataView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:self.headView];
            [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.top.mas_equalTo(self.contentView);
                make.height.mas_equalTo(50);
                make.width.mas_equalTo(KScreenWidth - 40);
            }];
            
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.headView.mas_bottom);
                make.left.mas_equalTo(self.contentView).offset(6);
                 make.right.mas_equalTo(self.contentView).offset(-6);
                make.bottom.mas_equalTo(self.contentView).offset(-14);
            }];
            self.tableView.backgroundColor = [UIColor whiteColor];
        }else {
             _emptyDataView.backgroundColor = UIColorFromRGB(0xFAFAFA);
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView);
                make.left.right.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView).offset(-14);
            }];
            self.tableView.backgroundColor = UIColorFromRGB(0xfafafa);
            self.tableView.layer.cornerRadius = 2;
        }
        
        @weakify(self);
        self.headView.clickHandle = ^{
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectTableViewRowWith:)]) {
                [self.delegate didSelectTableViewRowWith:self];
            }
        };
    }
    return self;
}

#pragma mark - protocol
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.backgroundView = self.dataModelArray.count == 0 ? self.emptyDataView : nil;
    return self.dataModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataModelArray.count <= indexPath.row) {
        return nil;
    }
    NIMMessageModel *model = self.dataModelArray[indexPath.row];
    NSString *cellID = model.isMe ? kRightChatCellID : kLeftChatCellID;
    TTDiscoverPublicMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if ([model isKindOfClass:NIMMessageModel.class]) {
        cell.messageModel = model;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TTHomeRecommendPublicChatSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionCellID];
    view.ATmeName = self.ATmeName;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.ATmeName.length>0 ? PDPublicChatCVCellTableHeaderHeight : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectTableViewRowWith:)]) {
        [self.delegate didSelectTableViewRowWith:self];
    }
}
#pragma mark - getters and setters


- (void)setDataModelArray:(NSMutableArray<NIMMessageModel *> *)dataModelArray {
    
    if (dataModelArray == nil || dataModelArray.count == 0) {
        return;
    }
    
    //第一次载入公聊数据标记
    static BOOL isFirstLoadFlag = YES;
    
    _dataModelArray = [dataModelArray mutableCopy];
    
    for (int i = 0; i < _dataModelArray.count; i++) {
        NIMCustomObject *object = (NIMCustomObject *)_dataModelArray[i].message.messageObject;
        if (object) {
            if ([object.attachment isKindOfClass:Attachment.class]) {
                Attachment *attchment = (Attachment *)object.attachment;
                
                if (attchment.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification) {
                    [_dataModelArray removeObjectAtIndex:i];
                    i--;
                }
                if (attchment.first == Custom_Noti_Header_CPGAME_PublicChat_Respond) {
                    [_dataModelArray removeObjectAtIndex:i];
                    i--;
                }
                
            }
            
            if (!object.attachment) {
                [_dataModelArray removeObjectAtIndex:i];
                i--;
            }
        }
        
    }
    
    [self.tableView reloadData];
    
    //第一次载入时，滚动到底部无动画效果
    [self.tableView nim_scrollToBottom:!isFirstLoadFlag];
    
    if (isFirstLoadFlag) {
        isFirstLoadFlag = NO;
    }
}

- (void)setATmeName:(NSString *)ATmeName {
    _ATmeName = ATmeName;
    
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = UIColorFromRGB(0xfafafa);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = PDPublicChatCVCellTableViewCellHeight;
        _tableView.scrollEnabled = NO;
        _tableView.clipsToBounds = YES;
        [_tableView registerClass:TTDiscoverPublicMessageCell.class forCellReuseIdentifier:kLeftChatCellID];
        [_tableView registerClass:TTDiscoverPublicMessageCell.class forCellReuseIdentifier:kRightChatCellID];
        [_tableView registerClass:TTHomeRecommendPublicChatSectionHeaderView.class forHeaderFooterViewReuseIdentifier:kSectionCellID];
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 8)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 8)];
    }
    return _tableView;
}

- (LLPublicHeadView *)headView {
    if (!_headView) {
        _headView = [[LLPublicHeadView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

- (XCEmptyDataView *)emptyDataView {
    if (!_emptyDataView) {
        UIImage *image = [UIImage imageNamed:@"common_noData_empty"];
        CGFloat height = 488;
        _emptyDataView = [[XCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 30, height)];
       
        _emptyDataView.title = @"正在加载数据中";
        _emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        _emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
        _emptyDataView.image = image;
        _emptyDataView.imageFrame = CGRectMake((KScreenWidth - 30 - 185)/2, (height - 145) / 2 - 30, 185, 145);
        _emptyDataView.margin = - 45;
    }
    return _emptyDataView;
}

@end
