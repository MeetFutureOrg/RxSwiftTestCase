//
//  UIWindow+OrientationChange.m
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

#import "UIWindow+OrientationChange.h"

#import "RuntimeUtils.h"
#import "NotificationCenterUtils.h"

static const void *isRotatingKey = &isRotatingKey;

static NSMutableArray *postDeviceDidChangeOrientationBlocks() {
    static NSMutableArray *array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [[NSMutableArray alloc] init];
    });
    return array;
}

static bool _isDeviceRotating = false;

@implementation UIWindow (OrientationChange)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        [NotificationCenterUtils addNotificationHandler:^bool(NSString *name, id object, NSDictionary *userInfo, void (^passNotification)(void)) {
            if ([name isEqualToString:@"UIWindowWillRotateNotification"]) {
                [(UIWindow *)object setRotating:true];
                
                if (NSClassFromString(@"NSUserActivity") == NULL) {
                    UIInterfaceOrientation orientation = [userInfo[@"UIWindowNewOrientationUserInfoKey"] integerValue];
                    CGSize screenSize = [UIScreen mainScreen].bounds.size;
                    if (screenSize.width > screenSize.height)
                    {
                        CGFloat tmp = screenSize.height;
                        screenSize.height = screenSize.width;
                        screenSize.width = tmp;
                    }
                    CGSize windowSize = CGSizeZero;
                    CGFloat windowRotation = 0.0;
                    bool landscape = false;
                    switch (orientation) {
                        case UIInterfaceOrientationPortrait:
                            windowSize = screenSize;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            windowRotation = (CGFloat)(M_PI);
                            windowSize = screenSize;
                            break;
                        case UIInterfaceOrientationLandscapeLeft:
                            landscape = true;
                            windowRotation = (CGFloat)(-M_PI / 2.0);
                            windowSize = CGSizeMake(screenSize.height, screenSize.width);
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            landscape = true;
                            windowRotation = (CGFloat)(M_PI / 2.0);
                            windowSize = CGSizeMake(screenSize.height, screenSize.width);
                            break;
                        default:
                            break;
                    }
                    
                    [UIView animateWithDuration:0.3 animations:^
                    {
                        CGAffineTransform transform = CGAffineTransformIdentity;
                        transform = CGAffineTransformRotate(transform, windowRotation);
                        ((UIWindow *)object).transform = transform;
                        ((UIWindow *)object).bounds = CGRectMake(0.0f, 0.0f, windowSize.width, windowSize.height);
                    }];
                }
                
                passNotification();
                
                return true;
            } else if ([name isEqualToString:@"UIWindowDidRotateNotification"]) {
                [(UIWindow *)object setRotating:false];
            } else if ([name isEqualToString:UIDeviceOrientationDidChangeNotification]) {
                _isDeviceRotating = true;
                
                passNotification();
                
                if (postDeviceDidChangeOrientationBlocks().count != 0) {
                    NSArray *blocks = [postDeviceDidChangeOrientationBlocks() copy];
                    [postDeviceDidChangeOrientationBlocks() removeAllObjects];
                    for (dispatch_block_t block in blocks) {
                        block();
                    }
                }
                
                _isDeviceRotating = false;
                
                return true;
            }
            
            return false;
        }];
    });
}

+ (void)addPostDeviceOrientationDidChangeBlock:(void (^)(void))block {
    [postDeviceDidChangeOrientationBlocks() addObject:[block copy]];
}

- (void)setRotating:(bool)rotating
{
    [self setAssociatedObject:@(rotating) forKey:isRotatingKey];
}

- (bool)isRotating
{
    return [[self associatedObjectForKey:isRotatingKey] boolValue];
}

+ (bool)isDeviceRotating {
    return _isDeviceRotating;
}

@end
