//
//  TTRoomShareMusicViewController.m
//  TTPlay
//
//  Created by Macx on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomShareMusicViewController.h"

#import "TTRoomShareMusicSearchView.h"
#import "TTMusicListTableViewCell.h"

#import "MusicPlayerCoreClient.h"
#import "MusicPlayerCore.h"
#import "MusicInfo.h"
#import "MeetingCore.h"
#import "MusicCache.h"
#import "FileCore.h"
#import "YYWebResourceDownloader.h"
#import "FileCoreClient.h"

#import "NSArray+Safe.h"

#import "XCHUDTool.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTRoomShareMusicViewController ()<TTRoomShareMusicSearchViewDelegate, UITextFieldDelegate, FileCoreClient, TTMusicListTableViewCellDelegate>
@property (strong, nonatomic) NSMutableArray<MusicInfo *> * musicListArray;
@property (strong, nonatomic) NSMutableArray<MusicInfo *> * musicSearchListArray;

@property (assign, nonatomic) int pageNum;

/** 搜索的view */
@property (nonatomic, strong) TTRoomShareMusicSearchView *searchView;
/** searchTableView */
@property (nonatomic, strong) UITableView *searchTableView;

@property (nonatomic, assign) BOOL isSearch;
/** errorLabel */
@property (nonatomic, strong) UILabel *errorLabel;
@end

@implementation TTRoomShareMusicViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
    
    AddCoreClient(MusicPlayerCoreClient, self);
    AddCoreClient(FileCoreClient, self);
    self.pageNum = 1;
    [XCHUDTool showGIFLoadingInView:self.view];
    [self pullDownRefresh:self.pageNum];
    
    [self.searchView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //Remove Client Here
    RemoveCoreClientAll(self);
}

- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark - public methods

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isSearch ? self.musicSearchListArray.count : self.musicListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicInfo *musicInfo;
    if (self.isSearch) {
        musicInfo = [self.musicSearchListArray safeObjectAtIndex:indexPath.row];
    } else {
        musicInfo = [self.musicListArray safeObjectAtIndex:indexPath.row];
    }
    TTMusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTMusicListTableViewCell class]) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isOnline = YES;
    [cell ttUpdateMusicInfo:musicInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text.length <= 0) {
        [XCHUDTool showErrorWithMessage:@"请输入内容" inView:self.view];
        return NO;
    }
    
    [XCHUDTool showGIFLoadingInView:self.view];
    [self.view endEditing:NO];
    [GetCore(MusicPlayerCore) requestMusicOnlineListWithpageNum:1 pageSize:50 songName:text];
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 50) {
        textField.text = [textField.text substringToIndex:50];
    }
}

#pragma mark - FileCoreClient
- (void)onDeleteMusicSuccess:(NSArray *)musicArray {
    dispatch_async(dispatch_get_main_queue(), ^{
        GetCore(MeetingCore).musicLists = [musicArray mutableCopy];
        [self.tableView reloadData];
        [self.searchTableView reloadData];
    });
}

#pragma mark - TTMusicListTableViewCellDelegate
- (void)onTTMusicListTableViewCell:(TTMusicListTableViewCell *)cell deleteSongAtIndexPath:(NSIndexPath *)indexPath {
    MusicInfo *musicInfo;
    if (self.isSearch) {
        musicInfo = [self.musicSearchListArray safeObjectAtIndex:indexPath.row];
    } else {
        musicInfo = [self.musicListArray safeObjectAtIndex:indexPath.row];
    }
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [NSString stringWithFormat:@"%@/music", path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                withIntermediateDirectories:YES
                                                                 attributes:nil
                                                                      error:nil];
    }
    
    [XCHUDTool showGIFLoadingInView:self.view];
    @KWeakify(self);
    [[YYWebResourceDownloader sharedDownloader] downloadWithURL:[NSURL URLWithString:musicInfo.localUri] fileName:musicInfo.songName  options:(YYWebResourceDownloaderOptions)YYWebResourceDownloaderProgressiveDownload progress:^(int64_t received, int64_t expected, CGFloat progress) {
        
    } completion:^(NSURL *filePath, NSError *error, BOOL finished) {
        @KStrongify(self);
        [XCHUDTool hideHUDInView:self.view];
        if (error) {
            [XCHUDTool showErrorWithMessage:@"添加失败，请稍后重试" inView:self.view];
            return;
        }
        NSString *filePathStr = [filePath path];
        
        [XCHUDTool showSuccessWithMessage:@"添加成功" inView:self.view];
        [GetCore(MeetingCore).musicLists addObject:musicInfo];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [NSString stringWithFormat:@"%@/music/%@",path,musicInfo.songName];
        musicInfo.filePath = path;
        [[MusicCache shareCache] saveMusicInfo:musicInfo];
        [[NSFileManager defaultManager] moveItemAtPath:filePathStr toPath:path error:nil];
        [GetCore(MusicPlayerCore) requestMusicOnlineAddMusicClick:[musicInfo.musicId doubleValue]];
        [GetCore(FileCore) uploadMusicList];
        
        if (self.isSearch) {
            [self.searchTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

#pragma mark - TTRoomShareMusicSearchViewDelegate
/**
 点击取消按钮
 
 @param searchView self
 @param cancleButton button
 */
- (void)roomShareMusicSearchView:(TTRoomShareMusicSearchView *)searchView didClickCancleButton:(UIButton *)cancleButton {
    self.isSearch = NO;
    self.errorLabel.hidden = YES;
}

/**
 点击搜索区域, 变为搜索状态
 
 @param searchView self
 @param contentView contentView
 */
- (void)roomShareMusicSearchView:(TTRoomShareMusicSearchView *)searchView didClickSearchContent:(UIView *)contentView {
    self.isSearch = YES;
    [[BaiduMobStat defaultStat] logEvent:@"sharing_music_search" eventLabel:@"共享音乐-搜索"];
}

#pragma mark - MusicPlayerCoreClient
- (void)onMusicOnlineListSuccess:(NSArray *)musicList {
    [XCHUDTool hideHUDInView:self.view];
    self.errorLabel.hidden = YES;
    if (self.isSearch) { //搜索情况
        self.musicSearchListArray = [musicList mutableCopy];
        [self.searchTableView reloadData];
        if (musicList.count <= 0) {
            self.errorLabel.hidden = NO;
            self.errorLabel.text = @"无搜索结果 换个关键词试试";
        }
        return;
    }
    
    if (musicList.count > 0) {
        if (self.pageNum == 1) {
            [self successEndRefreshStatus:0 hasMoreData:YES];
        } else {
            [self successEndRefreshStatus:1 hasMoreData:YES];
        }
    } else {
        if (self.pageNum == 1) {
            [self successEndRefreshStatus:0 hasMoreData:NO];
        } else {
            [self successEndRefreshStatus:1 hasMoreData:NO];
        }
    }
    if (self.pageNum == 1) {
        [self.musicListArray removeAllObjects];
    }
    [self.musicListArray addObjectsFromArray:[musicList mutableCopy]];
    [self.tableView reloadData];
}

- (void)onMusicOnlineListFailth:(NSString *)msg {
    self.errorLabel.hidden = YES;
    if (self.pageNum == 1) {
        [self failEndRefreshStatus:0];
    } else {
        [self failEndRefreshStatus:1];
    }
    [XCHUDTool showErrorWithMessage:msg inView:self.view];
}

#pragma mark - event response

#pragma mark - private method

- (void)initView {
    if (@available(iOS 11.0, *)) {
        self.searchTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TTMusicListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTMusicListTableViewCell class])];
    [self setupRefreshTarget:self.tableView];
    
    [self.view addSubview:self.searchTableView];
    self.isSearch = NO;
    
    [self.view addSubview:self.errorLabel];
}

- (void)initConstrations {
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.tableView);
    }];
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

// 下拉刷新的回调
- (void)pullDownRefresh:(int)page {
    self.pageNum = 1;
    [GetCore(MusicPlayerCore) requestMusicOnlineListWithpageNum:self.pageNum pageSize:20 songName:@""];
}

// 上拉刷新的回掉
- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    self.pageNum += 1;
    [GetCore(MusicPlayerCore) requestMusicOnlineListWithpageNum:self.pageNum pageSize:20 songName:@""];
}

#pragma mark - getters and setters

- (NSMutableArray<MusicInfo *> *)musicListArray{
    if (!_musicListArray) {
        _musicListArray = [NSMutableArray array];
    }
    return _musicListArray;
}

- (NSMutableArray<MusicInfo *> *)musicSearchListArray{
    if (!_musicSearchListArray) {
        _musicSearchListArray = [NSMutableArray array];
    }
    return _musicSearchListArray;
}

- (TTRoomShareMusicSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[TTRoomShareMusicSearchView alloc] init];
        _searchView.delegate = self;
        _searchView.textField.delegate = self;
    }
    return _searchView;
}

- (void)setIsSearch:(BOOL)isSearch{
    _isSearch = isSearch;
    if (isSearch) {
        [self.searchTableView reloadData];
        self.searchTableView.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        [self.tableView reloadData];
        self.searchTableView.hidden = YES;
        self.tableView.hidden = NO;
        [self.musicSearchListArray removeAllObjects];
    }
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] init];
        _searchTableView.backgroundColor = [UIColor clearColor];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _searchTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchTableView registerClass:[TTMusicListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTMusicListTableViewCell class])];
    }
    return _searchTableView;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _errorLabel.font = [UIFont systemFontOfSize:14];
        _errorLabel.hidden = YES;
    }
    return _errorLabel;
}

@end
