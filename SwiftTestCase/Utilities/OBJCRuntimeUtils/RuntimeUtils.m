//
//  RuntimeUtils.m
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

#import "RuntimeUtils.h"

#import <objc/runtime.h>

@interface CALayer ()

- (unsigned int)contextId;
- (void)setContextId:(unsigned int)contextId;

@end

@implementation RuntimeUtils

+ (CALayer * _Nonnull)makeLayerHostCopy:(CALayer * _Nonnull)another {
    CALayer *result = [[NSClassFromString(@"CALayerHost") alloc] init];
    [result setContextId:[another contextId]];
    return result;
}

+ (void)swizzleInstanceMethodOfClass:(Class)targetClass currentSelector:(SEL)currentSelector newSelector:(SEL)newSelector {
    Method origMethod = nil, newMethod = nil;
    
    origMethod = class_getInstanceMethod(targetClass, currentSelector);
    newMethod = class_getInstanceMethod(targetClass, newSelector);
    if ((origMethod != nil) && (newMethod != nil)) {
        if (class_addMethod(targetClass, currentSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(targetClass, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
}

+ (void)swizzleInstanceMethodOfClass:(Class)targetClass currentSelector:(SEL)currentSelector withAnotherClass:(Class)anotherClass newSelector:(SEL)newSelector {
    Method origMethod = nil, newMethod = nil;
    
    origMethod = class_getInstanceMethod(targetClass, currentSelector);
    newMethod = class_getInstanceMethod(anotherClass, newSelector);
    if ((origMethod != nil) && (newMethod != nil)) {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

+ (void)swizzleClassMethodOfClass:(Class)targetClass currentSelector:(SEL)currentSelector newSelector:(SEL)newSelector {
    Method origMethod = nil, newMethod = nil;
    
    origMethod = class_getClassMethod(targetClass, currentSelector);
    newMethod = class_getClassMethod(targetClass, newSelector);
    
    targetClass = object_getClass((id)targetClass);
    
    if ((origMethod != nil) && (newMethod != nil)) {
        if (class_addMethod(targetClass, currentSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(targetClass, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
}

@end

@implementation NSObject (AssociatedObject)

- (void)setAssociatedObject:(id)object forKey:(void const *)key
{
    [self setAssociatedObject:object forKey:key associationPolicy:NSObjectAssociationPolicyRetain];
}

- (void)setAssociatedObject:(id)object forKey:(void const *)key associationPolicy:(NSObjectAssociationPolicy)associationPolicy
{
    int policy = 0;
    switch (associationPolicy)
    {
        case NSObjectAssociationPolicyRetain:
            policy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
            break;
        case NSObjectAssociationPolicyCopy:
            policy = OBJC_ASSOCIATION_COPY_NONATOMIC;
            break;
        default:
            policy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
            break;
    }
    objc_setAssociatedObject(self, key, object, policy);
}

- (id)associatedObjectForKey:(void const *)key
{
    return objc_getAssociatedObject(self, key);
}

- (BOOL)checkObjectIsKindOfClass:(Class)targetClass {
    return [self isKindOfClass:targetClass];
}

- (void)setClass:(Class)newClass {
    object_setClass(self, newClass);
}

@end
