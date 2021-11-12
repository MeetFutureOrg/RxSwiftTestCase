//
//  NotificationCenterUtils.h
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef bool (^NotificationHandlerBlock)(NSString *, id, NSDictionary *, void (^)(void));

@interface NotificationCenterUtils : NSObject

+ (void)addNotificationHandler:(NotificationHandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
