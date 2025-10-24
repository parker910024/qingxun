//
//  XCFaceViewKitProtocol.h
//  Pods
//
//  Created by lvjunhang on 2018/11/27.
//

#ifndef XCFaceViewKitProtocol_h
#define XCFaceViewKitProtocol_h

@protocol XCFaceViewKitDelegate <NSObject>

/**
 用户点击贵族表情，但是没有相应的贵族权限
 */

/**
 用户点击贵族表情，但是没有相应的贵族权限

 @param currentLevel 当前用户等级，等级名称获取：MatchNobleNameUsingID(levle)
 @param needLevel 需要等级，等级名称获取：MatchNobleNameUsingID(levle)
 */
- (void)nobleFaceNoPermissionForLevel:(NSInteger)currentLevel needLevel:(NSInteger)needLevel;

@end
#endif /* XCFaceViewKitProtocol_h */
