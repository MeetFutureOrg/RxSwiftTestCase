//
//  UIWindow+OrientationChange.h
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (OrientationChange)

- (bool)isRotating;
+ (void)addPostDeviceOrientationDidChangeBlock:(void (^)(void))block;
+ (bool)isDeviceRotating;

@end

NS_ASSUME_NONNULL_END
