//
//  LTDynamicCommentsView.m
//  LTChat
//
//  Created by apple on 2019/10/22.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTDynamicCommentsView.h"

//view
#import "LTCommentCell.h"

//model
#import "CTCommentReplyModel.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"

@interface LTDynamicCommentsView ()
<
UITableViewDelegate,
UITableViewDataSource,
LTCommentCellDelegate
>

///三角形
@property (nonatomic, strong) UIImageView *markImgView;
///内容背景view
@property (nonatomic, strong) UIView *contentBgView;
///tabbleView
@property (nonatomic, strong) UITableView *tableView;
///查看更多按钮
@property (nonatomic, strong) UIButton *checkMoreBtn;
///评论数据
@property (nonatomic, strong) NSArray *commentVoList;
///缓存高度
@property (nonatomic, strong) NSMutableArray *cacheHeightArr;
///总高度
@property (nonatomic, assign) CGFloat tabHeight;

@end

@implementation LTDynamicCommentsView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentVoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:LTCommentCellIdentifier];
    if (!cell) {
        cell = [[LTCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTCommentCellIdentifier];
    }
    if (indexPath.row < self.commentVoList.count) {
        cell.commentReplyModel = self.commentVoList[indexPath.row];
        cell.delegate = self;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.commentVoList.count) {
        return [self.cacheHeightArr[indexPath.row] doubleValue];
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.commentVoList.count <= indexPath.row) return;
    CTCommentReplyModel *model = self.commentVoList[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpDynamicDetailsWithReplyComment:commentsView:)]) {
        [self.delegate jumpDynamicDetailsWithReplyComment:model commentsView:self];
    }
    
}

#pragma mark - LTCommentCellDelegate

- (void)jumpUserDetailsWithCell:(LTCommentCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpUserDetailsWithComment:commentsView:)]) {
        [self.delegate jumpUserDetailsWithComment:cell.commentReplyModel commentsView:self];
    }
}

#pragma mark - evnt action

- (void)lookMoreCommentsAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpDynamicDetailsWithReplyComment:commentsView:)]) {
          [self.delegate jumpDynamicDetailsWithReplyComment:nil commentsView:self];
      }
}


#pragma mark - 私有方法
- (void)initView {
    self.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self addSubview:self.markImgView];
    [self addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.tableView];
    [self.contentBgView addSubview:self.checkMoreBtn];
}


- (CGFloat)getCacheHeightWithData:(NSArray *)commentVoList commentCount:(NSInteger)count {
    self.checkMoreBtn.hidden = (commentVoList.count == 0 || count <= 3);
    if (commentVoList.count == 0) {
        self.contentBgView.height = 0;
        self.tableView.height = 0;
        self.backgroundColor = UIColorFromRGB(0xF8F8F8);
        return 0;
    }
    self.backgroundColor = [UIColor clearColor];
    self.tabHeight = 0;
    [self.cacheHeightArr removeAllObjects];
    M80AttributedLabel *heightLab = ({
        M80AttributedLabel *lab = [[M80AttributedLabel alloc]init];
        lab.textColor = UIColorFromRGB(0x666666);
        lab.font = [UIFont systemFontOfSize:14];
        lab.numberOfLines = 0;
        lab.lineBreakMode = NSLineBreakByCharWrapping;
        lab.autoDetectLinks = NO;
        lab;
    });
    for (int i = 0; i < commentVoList.count; ++i) {
        CTCommentReplyModel *model = commentVoList[i];
        [heightLab nim_setText:model.content];
        CGFloat height = [heightLab sizeThatFits:CGSizeMake((KScreenWidth - 70), CGFLOAT_MAX)].height + 33;
        [self.cacheHeightArr addObject:@(height)];
        self.tabHeight += height;
    }
    CGFloat bottomHeight = self.checkMoreBtn.hidden ? 10 : 40;
    self.contentBgView.height = self.tabHeight + bottomHeight;
    self.tableView.height = self.tabHeight;
    self.checkMoreBtn.top = CGRectGetMaxY(self.tableView.frame) + 10;
    self.commentVoList = commentVoList;
    [self.tableView reloadData];
    self.tabHeight += (bottomHeight + 6);//6(图片) + 40（查看更多）
    return self.tabHeight;
}


#pragma mark - set/get

- (void)setCommentVoList:(NSArray *)commentVoList {
    _commentVoList = commentVoList;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 6, KScreenWidth - 2*20, 0)];
        _contentBgView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    }
    return _contentBgView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 2*20, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.estimatedRowHeight = KScreenHeight;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (UIImageView *)markImgView {
    if (!_markImgView) {
        _markImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dynamic_mark_icon"]];
        [_markImgView sizeToFit];
        _markImgView.left = 110;
        _markImgView.top = 0;
    }
    return _markImgView;
}

- (UIButton *)checkMoreBtn {
    if (!_checkMoreBtn) {
        _checkMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkMoreBtn setTitleColor:UIColorFromRGB(0x54B9FD) forState:UIControlStateNormal];
        [_checkMoreBtn setTitle:@"查看更多…" forState:UIControlStateNormal];
        _checkMoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_checkMoreBtn addTarget:self action:@selector(lookMoreCommentsAction:) forControlEvents:UIControlEventTouchUpInside];
        [_checkMoreBtn sizeToFit];
        _checkMoreBtn.height = 17;
        _checkMoreBtn.left = 15;
        _checkMoreBtn.hidden = YES;
    }
    return _checkMoreBtn;
}

- (NSMutableArray *)cacheHeightArr {
    if (!_cacheHeightArr) {
        _cacheHeightArr = [NSMutableArray array];
    }
    return _cacheHeightArr;
}


@end
