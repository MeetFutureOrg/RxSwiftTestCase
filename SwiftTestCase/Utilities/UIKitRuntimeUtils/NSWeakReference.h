//
//  NSWeakReference.h
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWeakReference : NSObject

@property (nonatomic, weak) id value;

- (instancetype)initWithValue:(id)value;

@end

NS_ASSUME_NONNULL_END
