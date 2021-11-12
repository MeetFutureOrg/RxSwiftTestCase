//
//  NSWeakReference.m
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//


#import "NSWeakReference.h"

@implementation NSWeakReference

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self != nil) {
        self.value = value;
    }
    return self;
}

@end
