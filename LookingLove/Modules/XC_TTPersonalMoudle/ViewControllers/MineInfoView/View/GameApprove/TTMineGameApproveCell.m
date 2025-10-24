//
//  TTMineGameApproveCell.m
//  TTPlay
//
//  Created by new on 2019/3/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMineGameApproveCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "NSArray+Safe.h"
#import "TTGameApproveCollectionViewCell.h"
#import "AuthCore.h"
#import "NSMutableArray+Safe.h"

static NSString *const kGameApproveCellID = @"kGameApproveID";

@interface TTMineGameApproveCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) NSMutableArray *approveArray;
@property (nonatomic, strong) UIButton *editButton;

@end

@implementation TTMineGameApproveCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
        
        [self initView];
        
        [self initConstraint];
    }
    return self;
}

- (void)initView{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subLabel];
    [self.contentView addSubview:self.editButton];
    [self.contentView addSubview:self.collectionView];
}

- (void)initConstraint{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(34);
    }];
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-18);
        make.centerY.mas_equalTo(self.subLabel.mas_centerY);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(21);
        make.height.mas_equalTo(75);
        make.width.mas_equalTo(KScreenWidth);
    }];
    
}

- (void)setModel:(CertificationModel *)model{
    
    _model = model;
    [self.approveArray removeAllObjects];
    
    NSMutableArray *skliiVolistArray = model.liveSkillVoList.mutableCopy;
    for (int i = 0; i < skliiVolistArray.count; i++) {
        CertificationSkillListModel *model = [skliiVolistArray safeObjectAtIndex:i];
        if (model.status == 3) {
            [self.approveArray addObject:model];
        }
    }
    [self.collectionView reloadData];
    
}

- (void)setUserID:(UserID)userID{
    if (userID == GetCore(AuthCore).getUid.userIDValue) {
        self.editButton.hidden = NO;
    }else{
        self.editButton.hidden = YES;
    }
}

// button Action
- (void)editTagButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editBtnClickAction:)]) {
        [self.delegate editBtnClickAction:_model];
    }
}


//  setter
- (NSMutableArray *)approveArray{
    if (!_approveArray) {
        _approveArray = [NSMutableArray array];
    }
    return _approveArray;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"认证标签";
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _subLabel.font = [UIFont systemFontOfSize:12];
        _subLabel.text = @"（认证后可点亮101标识）";
    }
    return _subLabel;
}

- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:UIColorFromRGB(0xFFB606) forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editButton addTarget:self action:@selector(editTagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _editButton.hidden = YES;
    }
    return _editButton;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(75, 75);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 31;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:TTGameApproveCollectionViewCell.class forCellWithReuseIdentifier:kGameApproveCellID];
        
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.approveArray.count > 3 ? 3 : self.approveArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TTGameApproveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameApproveCellID forIndexPath:indexPath];
    
    CertificationSkillListModel *listModel = [self.approveArray safeObjectAtIndex:indexPath.row];
    
    cell.listModel = listModel;
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
