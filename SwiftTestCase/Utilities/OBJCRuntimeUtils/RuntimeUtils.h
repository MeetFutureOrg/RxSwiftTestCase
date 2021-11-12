//
//  RuntimeUtils.h
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    NSObjectAssociationPolicyRetain = 0,
    NSObjectAssociationPolicyCopy = 1
} NSObjectAssociationPolicy;

@interface RuntimeUtils : NSObject

+ (void)swizzleInstanceMethodOfClass:(Class)targetClass currentSelector:(SEL)currentSelector newSelector:(SEL)newSelector;
+ (void)swizzleInstanceMethodOfClass:(Class)targetClass currentSelector:(SEL)currentSelector withAnotherClass:(Class)anotherClass newSelector:(SEL)newSelector;
+ (void)swizzleClassMethodOfClass:(Class)targetClass currentSelector:(SEL)currentSelector newSelector:(SEL)newSelector;
+ (CALayer * _Nonnull)makeLayerHostCopy:(CALayer * _Nonnull)another;

@end

@interface NSObject (AssociatedObject)

- (void)setAssociatedObject:(nullable id)object forKey:(void const *)key;
- (void)setAssociatedObject:(nullable id)object forKey:(void const *)key associationPolicy:(NSObjectAssociationPolicy)associationPolicy;
- (id)associatedObjectForKey:(void const *)key;
- (BOOL)checkObjectIsKindOfClass:(Class)targetClass;
- (void)setClass:(Class)newClass;

@end

NS_ASSUME_NONNULL_END
