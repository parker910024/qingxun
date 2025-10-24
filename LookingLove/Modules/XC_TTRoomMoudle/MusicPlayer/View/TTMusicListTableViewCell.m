//
//  TTMusicListTableViewCell.m
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMusicListTableViewCell.h"

#import "MeetingCore.h"

//3rd part
#import <Masonry/Masonry.h>

//theme
#import "XCTheme.h"

@interface TTMusicListTableViewCell ()

/**
 歌曲名字标签
 */
@property (strong, nonatomic) UILabel *musicNameLabel;

/**
 歌手名标签
 */
@property (strong, nonatomic) UILabel *musicAuthorLabel;

/**
 删除按钮
 */
@property (strong, nonatomic) UIButton *deleteButton;
/** 分割线 */
@property (nonatomic, strong) UIView *lineView;
/** 是否已经下载过 */
@property (nonatomic, assign) BOOL isAdded;
@end

@implementation TTMusicListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

- (void)ttUpdateMusicInfo:(MusicInfo *)musicInfo {
    
    if (self.isOnline) {
        self.musicNameLabel.textColor = [XCTheme getTTMainTextColor];
        self.musicAuthorLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        NSString *music = musicInfo.musicName != nil ? musicInfo.musicName : musicInfo.songName;
        self.musicNameLabel.text = [NSString stringWithFormat:@"%@-%@", music,musicInfo.author];
        
        NSString *nick = musicInfo.nick.length > 0 ? musicInfo.nick : @"佚名";
        self.musicAuthorLabel.text = [NSString stringWithFormat:@"上传者 %@", nick];
        
        [self.deleteButton setImage:[UIImage imageNamed:@"room_music_list_add"] forState:UIControlStateNormal];
        
        NSArray *musicArray = GetCore(MeetingCore).musicLists;
        BOOL isExist = NO;
        for (MusicInfo *musicI in musicArray) {
            if ([musicI.musicId integerValue] == [musicInfo.musicId integerValue]) {
                isExist = YES;
                break;
            }
        }
        
        if (isExist) {
            [self.deleteButton setImage:[UIImage imageNamed:@"room_music_share_added"] forState:UIControlStateNormal];
            self.isAdded = YES;
        } else {
            [self.deleteButton setImage:[UIImage imageNamed:@"room_music_list_add"] forState:UIControlStateNormal];
            self.isAdded = NO;
        }
        
    } else {
        self.musicNameLabel.text = musicInfo.musicName != nil ? musicInfo.musicName : musicInfo.songName;
        
        NSString *currentMusicName = GetCore(MeetingCore).currentMusic.musicName ? GetCore(MeetingCore).currentMusic.musicName : GetCore(MeetingCore).currentMusic.songName;
        
        if ([currentMusicName isEqualToString:self.musicNameLabel.text]) {
            if (GetCore(MeetingCore).isPlaying) {
                self.musicNameLabel.textColor = [XCTheme getTTMainColor];
                self.musicAuthorLabel.textColor = [XCTheme getTTMainColor];
            } else {
                self.musicNameLabel.textColor = [XCTheme getTTMainTextColor];
                self.musicAuthorLabel.textColor = [XCTheme getTTDeepGrayTextColor];
            }
        } else {
            self.musicNameLabel.textColor = [XCTheme getTTMainTextColor];
            self.musicAuthorLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        }
        
        [self.deleteButton setImage:[UIImage imageNamed:@"room_music_list_delete"] forState:UIControlStateNormal];
        self.musicAuthorLabel.text = musicInfo.musicArtists != nil ? musicInfo.musicArtists : musicInfo.author;
    }
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response

- (void)didClickDeleteMusicButton:(UIButton *)sender {
    
    if (self.isOnline && self.isAdded) {
        return;
    }
    
    if (self.delegate) {
        [self.delegate onTTMusicListTableViewCell:self deleteSongAtIndexPath:self.indexPath];
    }
}

#pragma mark - private method

- (void)initView {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.musicNameLabel];
    [self.contentView addSubview:self.musicAuthorLabel];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.lineView];
}

- (void)initConstrations {
    [self.musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(23);
        make.trailing.mas_equalTo(self.deleteButton.mas_leading).offset(-10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
    }];
    [self.musicAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.musicNameLabel.mas_leading);
        make.top.mas_equalTo(self.musicNameLabel.mas_bottom).offset(8);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
        make.width.mas_equalTo(50);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(25);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - getters and setters

- (UILabel *)musicNameLabel {
    if (!_musicNameLabel) {
        _musicNameLabel = [[UILabel alloc]init];
        _musicNameLabel.textColor = [XCTheme getTTMainTextColor];
        _musicNameLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _musicNameLabel;
}

- (UILabel *)musicAuthorLabel {
    if (!_musicAuthorLabel) {
        _musicAuthorLabel = [[UILabel alloc]init];
        _musicAuthorLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _musicAuthorLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _musicAuthorLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc]init];
        [_deleteButton setImage:[UIImage imageNamed:@"room_music_list_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(didClickDeleteMusicButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBCOLOR(240, 240, 240);
    }
    return _lineView;
}

@end
