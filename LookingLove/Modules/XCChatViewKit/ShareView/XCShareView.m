//
//  XCShareView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/9/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCShareView.h"
#import "XCMacros.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "XCKeyWordTool.h"
#import "DarkModeTool.h"

#import "XCShareItemCell.h"

@interface XCShareView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *cancleButton;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<XCShareItem *> *items;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong) UIView  *contianterView;//容器
@property (nonatomic, assign) CGFloat collectionH;

@property (nonatomic, assign) XCShareViewStyle shareViewStyle;

@end

@implementation XCShareView


#pragma mark - Life Style
- (instancetype)initWithItemSize:(CGSize)itemSize items:(NSArray<XCShareItem *> *)items margin:(CGFloat)margin{
    return [self initWithShareViewStyle:XCShareViewStyleCenter items:items itemSize:itemSize edgeInsets:UIEdgeInsetsMake(0, margin, 0, margin)];
}

- (instancetype)initWithShareViewStyle:(XCShareViewStyle)style items:(NSArray<XCShareItem *> *)items itemSize:(CGSize)itemSize edgeInsets:(UIEdgeInsets)edgeInsets{
    
    _shareViewStyle = style;
    _items = items;
    _itemSize = itemSize;
    _edgeInsets = edgeInsets;
    if (self=[super init]) {
        [self setupSubviews];
        [self makeConstriants];
        [self configASMRUI];
    }
    return self;
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XCShareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCShareItemCell" forIndexPath:indexPath];
    cell.shareItem = self.items[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[self.items[indexPath.item] title]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:didSelected:)]) {
        XCShareItem *item = self.items[indexPath.item];
        [self.delegate shareView:self didSelected:item.itemTag];
    }
}

#pragma mark - event response
- (void)cancleButtonDidClck:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareViewDidClickCancle:)]) {
        [self.delegate shareViewDidClickCancle:self];
    }
}


#pragma mark - Private

- (void)setupSubviews{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contianterView];
    
    if (self.shareViewStyle == XCShareViewStyleAll) {
        [self.contianterView addSubview:self.titleLabel];
        [self.contianterView addSubview:self.tipLabel];
    }
    
    [self.contianterView addSubview:self.collectionView];
    
    if (self.shareViewStyle == XCShareViewStyleCenterAndBottom || self.shareViewStyle == XCShareViewStyleAll) {
        [self.contianterView addSubview:self.cancleButton];
    }
    
    [self.collectionView registerClass:[XCShareItemCell class] forCellWithReuseIdentifier:@"XCShareItemCell"];
}

- (void)makeConstriants{
    int collectionWidth = KScreenWidth-self.edgeInsets.left-self.edgeInsets.right;
    int offset =  (int)(self.items.count * self.itemSize.width) % collectionWidth;
    int row = self.items.count * self.itemSize.width / collectionWidth ;
    self.collectionH = (offset == 0 ? self.itemSize.height*row : self.itemSize.height*(row+1));
    
    int cancleButtonH = 44;
    
    if (self.shareViewStyle == XCShareViewStyleCenter) {
        
        self.frame = CGRectMake(0, 0, KScreenWidth, self.collectionH + self.edgeInsets.top+self.edgeInsets.bottom + kSafeAreaBottomHeight);
        self.collectionView.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, collectionWidth, self.collectionH);
        
    }else if (self.shareViewStyle == XCShareViewStyleCenterAndBottom){
        
        self.frame = CGRectMake(0, 0, KScreenWidth, self.collectionH + self.edgeInsets.top+self.edgeInsets.bottom + cancleButtonH + kSafeAreaBottomHeight);
        self.collectionView.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, collectionWidth, self.collectionH);
        self.cancleButton.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+self.edgeInsets.bottom, KScreenWidth, cancleButtonH);
        
    }else if (self.shareViewStyle == XCShareViewStyleAll){
        
        self.frame = CGRectMake(0, 0, KScreenWidth, self.collectionH + self.edgeInsets.top+self.edgeInsets.bottom + cancleButtonH + 55 + kSafeAreaBottomHeight);
        self.titleLabel.frame =CGRectMake(0, 18, KScreenWidth, 14);
        self.tipLabel.frame =CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+10, KScreenWidth, 13);
        self.collectionView.frame = CGRectMake(self.edgeInsets.left, CGRectGetMaxY(self.tipLabel.frame)+self.edgeInsets.top, collectionWidth, self.collectionH);
        self.cancleButton.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+self.edgeInsets.bottom, KScreenWidth, cancleButtonH);
    }
    // 适配 iPhone X 系列安全区域
    self.contianterView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - kSafeAreaBottomHeight);
    
    
    [self.collectionView reloadData];
}

- (void)configASMRUI{
    
    self.titleLabel.text = @"分享到";
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textColor = [[DarkModeTool shareInstance] configColorWithLight:UIColorFromRGB(0xB5B5B5) Dark:[UIColor whiteColor]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tipLabel.hidden = YES;
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.cancleButton setTitleColor:[[DarkModeTool shareInstance] configColorWithLight:UIColorFromRGB(0x333333) Dark:[UIColor whiteColor]] forState:UIControlStateNormal];
}
#pragma mark - Getter & Setter

- (UIView *)contianterView {
    if (!_contianterView) {
        _contianterView = [[UIView alloc] init];
        _contianterView.backgroundColor = [[DarkModeTool shareInstance] defaultBackgroundColorConfiguration];
        _contianterView.layer.cornerRadius = 14.0;
        _contianterView.layer.masksToBounds = YES;
    }
    return _contianterView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [[DarkModeTool shareInstance] configColorWithLight:UIColorFromRGB(0x333333) Dark:[UIColor whiteColor]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"分享给好友";
    }
    return _titleLabel;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:13.0];
        _tipLabel.textColor = [[DarkModeTool shareInstance] configColorWithLight:UIColorFromRGB(0x999999) Dark:[UIColor whiteColor]];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = [NSString stringWithFormat:@"每天第一次分享免费领%@（不包含分享至%@好友）",[XCKeyWordTool sharedInstance].xcRedColor, MyAppName];
    }
    return _tipLabel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.itemSize;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [[DarkModeTool shareInstance] defaultBackgroundColorConfiguration];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [[UIButton alloc] init];
        [_cancleButton setBackgroundColor:[[DarkModeTool shareInstance]configColorWithLight:UIColorFromRGB(0xF5F5F5) Dark:UIColorFromRGB(0x202020)]];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_cancleButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancleButtonDidClck:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

@end
