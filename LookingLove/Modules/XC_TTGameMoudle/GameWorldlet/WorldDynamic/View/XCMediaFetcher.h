//
//  XCMediaFetcher.h
//  NIMKit
//
//  Created by chris on 2016/11/12.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


typedef void(^XCLibraryFetchResult)(NSArray *images,NSMutableArray *selectedAssets, NSString *path, PHAssetMediaType type);

typedef void(^XCCameraFetchResult)(NSString *path, UIImage *image);

@interface XCMediaFetcher : NSObject

@property (nonatomic,assign) NSInteger limit;

@property (nonatomic,strong) NSArray *mediaTypes; //kUTTypeMovie,kUTTypeImage
///是否不允许选择原图
@property (nonatomic, assign) BOOL notAllowPickingOriginalPhoto;
///已经选择的图片数组
@property (nonatomic, strong) NSMutableArray *selectedAssets;

- (void)fetchPhotoFromLibrary:(XCLibraryFetchResult)result;

- (void)fetchMediaFromCamera:(XCCameraFetchResult)result;

@end
