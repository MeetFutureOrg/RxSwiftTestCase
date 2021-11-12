//
//  NSBag.h
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBag : NSObject

- (NSInteger)addItem:(id)item;
- (void)enumerateItems:(void (^)(id))block;
- (void)removeItem:(NSInteger)key;

@end

NS_ASSUME_NONNULL_END
