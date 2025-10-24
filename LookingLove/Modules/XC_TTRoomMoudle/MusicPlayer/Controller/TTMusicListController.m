//
//  TTMusicListController.m
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMusicListController.h"

//view
//列表里播放器
#import "TTMusicListPlayerView.h"
#import "TTAdjustMixView.h"
//PC传歌View
#import "TTWebTransportViewController.h"
//空列表图标View
#import "TTEmptyMusicListView.h"

//cell
#import "TTMusicListTableViewCell.h"

//core
#import "FileCore.h"
#import "MeetingCore.h"
#import "MusicCache.h"
//client
#import "FileCoreClient.h"
#import "MeetingCoreClient.h"

//theme
#import "XCTheme.h"

//tool
#import "XCHUDTool.h"

//const
#import "XCMacros.h"

//category
#import "UIImageView+QiNiu.h"
#import "NSArray+Safe.h"

//3rd part
#import <Masonry/Masonry.h>

@interface TTMusicListController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    FileCoreClient,
    TTMusicListTableViewCellDelegate,
    TTMusicListPlayerViewDelegate,
    TTAdjustMixViewDelegate,
    TTEmptyMusicListViewDelegate,
    MeetingCoreClient
>

/**
 歌曲列表
 */
@property (nonatomic, strong) UITableView *musicListTableView;

/**
 列表播放器
 */
@property (nonatomic, strong) TTMusicListPlayerView * musicPlayerInListView;

/**
 混淆调整view
 */
@property (nonatomic, strong) TTAdjustMixView * adjustMixView;
/** 混淆调整view的父控件 */
@property (nonatomic, strong) UIView *adjustMixContainView;

/**
 空列表view
 */
@property (strong, nonatomic) TTEmptyMusicListView *emptyListView;
/** 共xx首歌 */
@property (nonatomic, strong) UILabel *totalMusicCountLabel;
@end

@implementation TTMusicListController

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self musicListViewHiddenWith:self.musicLists];
    [GetCore(FileCore) uploadMusicList];
    if (@available(iOS 11, *)) {
        self.musicListTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.musicListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (GetCore(MeetingCore).isPlaying) {
        if (LiOS11) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.musicListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
            self.musicListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    [self.musicPlayerInListView playStatusChangeWithMusicInfo:GetCore(MeetingCore).currentMusic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.musicListTableView registerClass:[TTMusicListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTMusicListTableViewCell class])];
    self.musicListTableView.backgroundColor = [UIColor clearColor];
    AddCoreClient(FileCoreClient, self);
    AddCoreClient(MeetingCoreClient, self);
    
    GetCore(FileCore).kNewMusicArray = [NSMutableArray array];
    
    [self initView];
    [self initConstrations];
    
    if (LiOS11) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.musicListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        self.musicListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self musicListViewHiddenWith:self.musicLists];
}

#pragma mark - MeetingCoreClient
- (void)onUpdateNextMusicName:(NSString *)musicName Artist:(NSString *)artistName {
    [self.musicPlayerInListView ttUpdateMusicName:musicName];
    [self.musicListTableView reloadData];
}

#pragma mark - FileCoreClient
- (void)onUploadMusicListSuccess:(NSArray *)musicArray{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.musicLists = [musicArray mutableCopy];
        GetCore(MeetingCore).musicLists = [musicArray mutableCopy];
        [self.musicListTableView reloadData];
        [self musicListViewHiddenWith:musicArray];
    });
}

- (void)onUploadMusicListFailth:(NSError *)error {
    NSLog(@"刷新列表出错了");
}

- (void)onDeleteMusicSuccess:(NSArray *)musicArray {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BaiduMobStat defaultStat] logEvent:@"my_library_delete" eventLabel:@"我的曲库-删除"];
        self.musicLists = [musicArray mutableCopy];
        GetCore(MeetingCore).musicLists = self.musicLists;
        [self.musicListTableView reloadData];
        [self musicListViewHiddenWith:musicArray];
    });
}

- (void)onDeleteMusicFailth:(NSError *)error {
    NSLog(@"删除出错了");
}

#pragma mark - TTMusicListTableViewCellDelegate'
- (void)onTTMusicListTableViewCell:(TTMusicListTableViewCell *)cell deleteSongAtIndexPath:(NSIndexPath *)indexPath {
    if ([GetCore(MeetingCore).currentMusic.musicName isEqualToString:GetCore(MeetingCore).musicLists[indexPath.row].musicName]) {
        [GetCore(MeetingCore) stopPlayMusic];
        GetCore(MeetingCore).isPlaying = NO;
        GetCore(MeetingCore).currentMusic = nil;
        
        [self.musicPlayerInListView playStatusChangeWithMusicInfo:nil];
    }
    NSString * fileName = self.musicLists[indexPath.row].musicName;
    MusicInfo * info = self.musicLists[indexPath.row];
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    documentsPath = [NSString stringWithFormat:@"%@/music",documentsPath];
    NSString * musicPath = [documentsPath stringByAppendingPathComponent:fileName];
    
    BOOL deleted = [[MusicCache shareCache] removeMusicInfo:info];
    if (deleted) {
        [GetCore(FileCore) deleteMusicWithPath:musicPath];
    }
}

#pragma mark - TTMusicListPlayerViewDelegate

- (void)playSongButtonClickPlayerView:(TTMusicListPlayerView *)playerView {
    //看看是否在暂停，如果不在暂停，就是没有播放过歌曲，如果歌曲库中有歌曲，自动播放第一首，如果没有提示没有歌曲
    if (GetCore(MeetingCore).isPlaying == NO && GetCore(MeetingCore).currentMusic == nil){
        
        if (GetCore(MeetingCore).musicLists.count <= 0 || GetCore(MeetingCore).musicLists == nil) {
            [XCHUDTool showErrorWithMessage:@"播放列表中还没有歌曲哦！" inView:self.view];
        }else{
            [GetCore(MeetingCore) startPlayMusicAtIndex:0];
            GetCore(MeetingCore).isPlaying = YES;
            
            MusicInfo *needToPlayMusicInfo = [self.musicLists safeObjectAtIndex:0];
            [self.musicPlayerInListView playStatusChangeWithMusicInfo:needToPlayMusicInfo];
            
            if ([self.delegate respondsToSelector:@selector(onUpdatePlayingStateMusicListController:)]) {
                [_delegate onUpdatePlayingStateMusicListController:self];
                
            }
            [self.musicListTableView reloadData];
        }
    }else{
        if (GetCore(MeetingCore).isPlaying == NO) {
            GetCore(MeetingCore).isPlaying = YES;
            [GetCore(MeetingCore) resumePlayMusic];
        }else{
            GetCore(MeetingCore).isPlaying = NO;
            [GetCore(MeetingCore) pausePlayMusic];
        }
        
        [self.musicPlayerInListView playStatusChangeWithMusicInfo:GetCore(MeetingCore).currentMusic];
        //        GetCore(MeetingCore).isPlaying = !GetCore(MeetingCore).isPlaying;
        
        if ([self.delegate respondsToSelector:@selector(onUpdatePlayingStateMusicListController:)]) {
            [_delegate onUpdatePlayingStateMusicListController:self];
        }
    }
    
}

- (void)adjustMixButtonClickPlayerView:(TTMusicListPlayerView *)playerView {
    [self.view addSubview:self.adjustMixContainView];
    [self.adjustMixContainView addSubview:self.adjustMixView];
    [self.adjustMixContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.adjustMixView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.adjustMixContainView);
        make.trailing.mas_equalTo(self.adjustMixContainView);
        make.bottom.mas_equalTo(self.adjustMixContainView).offset(90);
        make.height.mas_equalTo(90);
    }];
    
    [self.view layoutIfNeeded];
    
    [self.adjustMixView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.adjustMixContainView).offset(-kSafeAreaBottomHeight);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}


#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicInfo *musicInfo = self.musicLists[indexPath.row];
    TTMusicListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTMusicListTableViewCell class]) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell ttUpdateMusicInfo:musicInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GetCore(MeetingCore).isPlaying = YES;
    MusicInfo *musicInfo = [self.musicLists safeObjectAtIndex:indexPath.row];
    BOOL play = [GetCore(MeetingCore) startPlayMusicAtIndex:indexPath.row];
    
    [self.musicPlayerInListView playStatusChangeWithMusicInfo:musicInfo];
    if (_delegate != nil) {
        [_delegate musicListController:self updateSongName:musicInfo.musicName];
        [_delegate onUpdatePlayingStateMusicListController:self];
    }
    
    if (LiOS11) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.musicListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        self.musicListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.musicListTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self musicListViewHiddenWith:self.musicLists];
    return self.musicLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    self.totalMusicCountLabel.frame = CGRectMake(22, 5, 200, 12);
    [view addSubview:self.totalMusicCountLabel];
    view.backgroundColor = [UIColor whiteColor];
    self.totalMusicCountLabel.text = [NSString stringWithFormat:@"共%li首歌", self.musicLists.count];
    return view;
}

#pragma mark - TTAdjustMixViewDelegate

- (void)adjustMixView:(TTAdjustMixView *)adjustMixView adjustSoundVolFromMixView:(NSInteger)vol {
    GetCore(MeetingCore).soundVol = vol;
    if (_delegate != nil) {
        [_delegate musicListController:self updateVolValue:vol];
    }
}

- (void)adjustMixView:(TTAdjustMixView *)adjustMixView adjustVoiceVolFromMixView:(NSInteger)vol {
    GetCore(MeetingCore).voiceVol = vol;
    if (_delegate != nil) {
        [_delegate musicListController:self updateVolValue:vol];
    }
}

#pragma mark - TTEmptyMusicListViewDelegate

- (void)emptyMusicListView:(TTEmptyMusicListView *)emptyMusicView addMusicButtonClick:(UIButton *)addMusicClick {
    [self onAddMusicButtonClick];
}

- (void)emptyMusicListView:(TTEmptyMusicListView *)emptyMusicView addShareMusicButtonClick:(UIButton *)addShareMusicButton {
    [[BaiduMobStat defaultStat] logEvent:@"my_library_add_music" eventLabel:@"我的曲库-添加共享音乐"];
    if (self.didClickAddShareMusicAction) {
        self.didClickAddShareMusicAction();
    }
}

#pragma mark - private method

- (void)initView {
    self.navigationItem.title = @"我的播放器";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    [self.view addSubview:self.musicPlayerInListView];
    [self.view addSubview:self.musicListTableView];
    [self.view addSubview:self.emptyListView];
    self.musicListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (GetCore(MeetingCore).musicLists == nil || GetCore(MeetingCore).musicLists.count <= 0) {
        self.musicListTableView.hidden = YES;
        
    }else{
        self.musicListTableView.hidden = NO;
    }
    
}


- (void)initConstrations {
    [self.musicPlayerInListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(60);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    [self.musicListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.bottom.mas_equalTo(self.musicPlayerInListView.mas_top);
    }];
    
    [self.emptyListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}


- (void)musicListViewHiddenWith:(NSArray *)musicArray {
    if (musicArray.count > 0) {
        self.emptyListView.hidden = YES;
        self.musicListTableView.hidden = NO;
    } else {
        self.emptyListView.hidden = NO;
        self.musicListTableView.hidden = YES;
    }
}

#pragma mark - event respone

- (void)onAddMusicButtonClick {
    TTWebTransportViewController *vc = [[TTWebTransportViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didRecognizedAdjustMixContainViewTapGestureRecognizer:(UIGestureRecognizer *)recognizer {
    [self.adjustMixView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.adjustMixContainView).offset(90);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.adjustMixContainView.hidden = YES;
        [self.adjustMixContainView removeFromSuperview];
        self.adjustMixView = nil;
        self.adjustMixContainView = nil;
    }];
}


#pragma mark - getters and setters

- (TTMusicListPlayerView *)musicPlayerInListView {
    if (!_musicPlayerInListView) {
        _musicPlayerInListView = [[TTMusicListPlayerView alloc]init];
        _musicPlayerInListView.delegate = self;
    }
    return _musicPlayerInListView;
}

- (TTEmptyMusicListView *)emptyListView {
    if (!_emptyListView) {
        _emptyListView = [[TTEmptyMusicListView alloc]init];
        _emptyListView.delegate = self;
    }
    return _emptyListView;
}

- (UITableView *)musicListTableView {
    if (!_musicListTableView) {
        _musicListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _musicListTableView.backgroundColor = [UIColor clearColor];
        // 设置代理
        _musicListTableView.delegate = self;
        // 设置数据源
        _musicListTableView.dataSource = self;
        // 清除表格底部多余的cell
        _musicListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _musicListTableView.separatorColor = UIColorRGBAlpha(0xffffff, 0.1);
        [self.view addSubview:_musicListTableView];
    }
    return _musicListTableView;
}

- (TTAdjustMixView *)adjustMixView {
    if (!_adjustMixView) {
        _adjustMixView = [[TTAdjustMixView alloc] init];
        _adjustMixView.delegate = self;
    }
    return _adjustMixView;
}

- (UIView *)adjustMixContainView {
    if (!_adjustMixContainView) {
        _adjustMixContainView = [[UIView alloc] init];
        _adjustMixContainView.backgroundColor = [UIColor clearColor];
        _adjustMixContainView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizedAdjustMixContainViewTapGestureRecognizer:)];
        [_adjustMixContainView addGestureRecognizer:tapGes];
    }
    return _adjustMixContainView;
}

- (UILabel *)totalMusicCountLabel {
    if (!_totalMusicCountLabel) {
        _totalMusicCountLabel = [[UILabel alloc] init];
        _totalMusicCountLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _totalMusicCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _totalMusicCountLabel;
}

@end
