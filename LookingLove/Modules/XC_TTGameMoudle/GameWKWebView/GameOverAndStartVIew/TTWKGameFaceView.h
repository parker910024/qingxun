//
//  TTWKGameFaceView.h
//  AFNetworking
//
//  Created by new on 2019/4/18.
//

#import <UIKit/UIKit.h>

@class TTGameInformationModel;
@class TTWKGameFaceView;

@protocol TTWKGameFaceViewDelgate <NSObject>

- (void)sendFaceWithImageString:(NSString *)imageString WithObj:(TTWKGameFaceView *)object;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTWKGameFaceView : UIView

@property (nonatomic, strong) TTGameInformationModel *dataModel;

@property (nonatomic, assign) id<TTWKGameFaceViewDelgate> delegate;

@end

NS_ASSUME_NONNULL_END
