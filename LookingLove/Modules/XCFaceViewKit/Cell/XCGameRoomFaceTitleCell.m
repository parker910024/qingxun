//
//  XCGameRoomFaceTitleCell.m
//  XCRoomMoudle
//
//  Created by 卫明何 on 2018/8/23.
//  Copyright © 2018年 卫明何. All rights reserved.
//

#import "XCGameRoomFaceTitleCell.h"
#import "XCGameRoomFaceTitleButton.h"

#import "XCTheme.h"
#import "XCMacros.h"

//3rd part
#import <Masonry/Masonry.h>

@interface XCGameRoomFaceTitleCell ()

@property (strong, nonatomic) XCGameRoomFaceTitleButton *titleButton;

@end

@implementation XCGameRoomFaceTitleCell

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response

#pragma mark - private method

- (void)initView {
    [self.contentView addSubview:self.titleButton];
}

- (void)initConstrations {
    if (projectType() == ProjectType_CeEr ||
        projectType() == ProjectType_LookingLove) {
        [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    } else {
        [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(20);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-20);
            make.height.mas_equalTo(25);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
}

- (void)setDisplayModel:(XCGameRoomFaceTitleDisplayModel *)displayModel {
    _displayModel = displayModel;
    NSAssert(displayModel.title.length > 0, @"XCGameRoomFaceTitleDisplayModel 's protype name title can'not be nil");
    
    self.titleButton.title = displayModel.title;
    self.titleButton.selected = displayModel.isSelected;
}

#pragma mark - getters and setters

- (XCGameRoomFaceTitleButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [XCGameRoomFaceTitleButton buttonWithType:UIButtonTypeCustom];
        if (projectType() == ProjectType_CeEr ||
            projectType() == ProjectType_LookingLove) {
            _titleButton.isShowUnderline = YES;
        } else {
            _titleButton.normalTitleColor = UIColorFromRGB(0xffffff);
            _titleButton.selectTitleColor = UIColorFromRGB(0xfed700);
        }
    }
    return _titleButton;
}

@end
