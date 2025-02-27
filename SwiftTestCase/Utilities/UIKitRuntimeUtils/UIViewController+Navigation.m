//
//  UIViewController+Navigation.m
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

#import "UIViewController+Navigation.h"

#import "RuntimeUtils.h"
#import <objc/runtime.h>

#import "NSWeakReference.h"

@interface UIViewControllerPresentingProxy : UIViewController

@property (nonatomic, copy) void (^dismiss)(void);
@property (nonatomic, strong, readonly) UIViewController *rootController;

@end

@implementation UIViewControllerPresentingProxy

- (instancetype)initWithRootController:(UIViewController *)rootController {
    _rootController = rootController;
    return self;
}

- (void)dismissViewControllerAnimated:(BOOL)__unused flag completion:(void (^)(void))completion {
    if (_dismiss) {
        _dismiss();
    }
    if (completion) {
        completion();
    }
}

@end

static const void *UIViewControllerIgnoreAppearanceMethodInvocationsKey = &UIViewControllerIgnoreAppearanceMethodInvocationsKey;
static const void *UIViewControllerNavigationControllerKey = &UIViewControllerNavigationControllerKey;
static const void *UIViewControllerPresentingControllerKey = &UIViewControllerPresentingControllerKey;
static const void *UIViewControllerPresentingProxyControllerKey = &UIViewControllerPresentingProxyControllerKey;
static const void *disablesInteractiveTransitionGestureRecognizerKey = &disablesInteractiveTransitionGestureRecognizerKey;
static const void *disablesInteractiveKeyboardGestureRecognizerKey = &disablesInteractiveKeyboardGestureRecognizerKey;
static const void *disablesInteractiveTransitionGestureRecognizerNowKey = &disablesInteractiveTransitionGestureRecognizerNowKey;
static const void *disableAutomaticKeyboardHandlingKey = &disableAutomaticKeyboardHandlingKey;
static const void *setNeedsStatusBarAppearanceUpdateKey = &setNeedsStatusBarAppearanceUpdateKey;
static const void *inputAccessoryHeightProviderKey = &inputAccessoryHeightProviderKey;
static const void *interactiveTransitionGestureRecognizerTestKey = &interactiveTransitionGestureRecognizerTestKey;
static const void *UIViewControllerHintWillBePresentedInPreviewingContextKey = &UIViewControllerHintWillBePresentedInPreviewingContextKey;
static const void *disablesInteractiveModalDismissKey = &disablesInteractiveModalDismissKey;

static bool notyfyingShiftState = false;

@interface UIKeyboardImpl_65087dc8: UIView

@end

@implementation UIKeyboardImpl_65087dc8

- (void)notifyShiftState {
    static void (*impl)(id, SEL) = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method m = class_getInstanceMethod([UIKeyboardImpl_65087dc8 class], @selector(notifyShiftState));
        impl = (typeof(impl))method_getImplementation(m);
    });
    if (impl) {
        notyfyingShiftState = true;
        impl(self, @selector(notifyShiftState));
        notyfyingShiftState = false;
    }
}

@end

@interface UIInputWindowController_65087dc8: UIViewController

@end

@implementation UIInputWindowController_65087dc8

- (void)updateViewConstraints {
    static void (*impl)(id, SEL) = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method m = class_getInstanceMethod([UIInputWindowController_65087dc8 class], @selector(updateViewConstraints));
        impl = (typeof(impl))method_getImplementation(m);
    });
    if (impl) {
        if (!notyfyingShiftState) {
            impl(self, @selector(updateViewConstraints));
        }
    }
}

@end

@implementation UIViewController (Navigation)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [RuntimeUtils swizzleInstanceMethodOfClass:[UIViewController class] currentSelector:@selector(viewWillAppear:) newSelector:@selector(_65087dc8_viewWillAppear:)];
        [RuntimeUtils swizzleInstanceMethodOfClass:[UIViewController class] currentSelector:@selector(viewDidAppear:) newSelector:@selector(_65087dc8_viewDidAppear:)];
        [RuntimeUtils swizzleInstanceMethodOfClass:[UIViewController class] currentSelector:@selector(viewWillDisappear:) newSelector:@selector(_65087dc8_viewWillDisappear:)];
        [RuntimeUtils swizzleInstanceMethodOfClass:[UIViewController class] currentSelector:@selector(viewDidDisappear:) newSelector:@selector(_65087dc8_viewDidDisappear:)];
        [RuntimeUtils swizzleInstanceMethodOfClass:[UIViewController class] currentSelector:@selector(navigationController) newSelector:@selector(_65087dc8_navigationController)];
        [RuntimeUtils swizzleInstanceMethodOfClass:[UIViewController class] currentSelector:@selector(presentingViewController) newSelector:@selector(_65087dc8_presentingViewController)];
        [RuntimeUtils swizzleInstanceMethodOfClass:[UIViewController class] currentSelector:@selector(presentViewController:animated:completion:) newSelector:@selector(_65087dc8_presentViewController:animated:completion:)];
        [RuntimeUtils swizzleInstanceMethodOfClass:[UIViewController class] currentSelector:@selector(setNeedsStatusBarAppearanceUpdate) newSelector:@selector(_65087dc8_setNeedsStatusBarAppearanceUpdate)];
        
        /*#pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        if (@available(iOS 13, *)) {
            Class UIUndoGestureInteractionClass = NSClassFromString(@"UIUndoGestureInteraction");
            SEL addGestureRecognizersSelector = @selector(_addGestureRecognizers);
            IMP doNothing = imp_implementationWithBlock(^void(__unused id _self) {
                return;
            });
            
            method_setImplementation(class_getInstanceMethod(UIUndoGestureInteractionClass, addGestureRecognizersSelector), doNothing);
        }
        #pragma clang diagnostic pop*/
        
        //[RuntimeUtils swizzleInstanceMethodOfClass:NSClassFromString(@"UIKeyboardImpl") currentSelector:@selector(notifyShiftState) withAnotherClass:[UIKeyboardImpl_65087dc8 class] newSelector:@selector(notifyShiftState)];
        //[RuntimeUtils swizzleInstanceMethodOfClass:NSClassFromString(@"UIInputWindowController") currentSelector:@selector(updateViewConstraints) withAnotherClass:[UIInputWindowController_65087dc8 class] newSelector:@selector(updateViewConstraints)];
    });
}

- (void)setHintWillBePresentedInPreviewingContext:(BOOL)value {
    [self setAssociatedObject:@(value) forKey:UIViewControllerHintWillBePresentedInPreviewingContextKey];
}

- (BOOL)isPresentedInPreviewingContext {
    if ([[self associatedObjectForKey:UIViewControllerHintWillBePresentedInPreviewingContextKey] boolValue]) {
        return true;
    } else {
        return false;
    }
}

- (void)setIgnoreAppearanceMethodInvocations:(BOOL)ignoreAppearanceMethodInvocations
{
    [self setAssociatedObject:@(ignoreAppearanceMethodInvocations) forKey:UIViewControllerIgnoreAppearanceMethodInvocationsKey];
}

- (BOOL)ignoreAppearanceMethodInvocations
{
    return [[self associatedObjectForKey:UIViewControllerIgnoreAppearanceMethodInvocationsKey] boolValue];
}

- (void)_65087dc8_viewWillAppear:(BOOL)animated
{
    if (![self ignoreAppearanceMethodInvocations])
        [self _65087dc8_viewWillAppear:animated];
}

- (void)_65087dc8_viewDidAppear:(BOOL)animated
{
    if (![self ignoreAppearanceMethodInvocations])
        [self _65087dc8_viewDidAppear:animated];
}

- (void)_65087dc8_viewWillDisappear:(BOOL)animated
{
    if (![self ignoreAppearanceMethodInvocations])
        [self _65087dc8_viewWillDisappear:animated];
}

- (void)_65087dc8_viewDidDisappear:(BOOL)animated
{
    if (![self ignoreAppearanceMethodInvocations])
        [self _65087dc8_viewDidDisappear:animated];
}

- (void)navigation_setNavigationController:(UINavigationController * _Nullable)navigationControlller {
    [self setAssociatedObject:[[NSWeakReference alloc] initWithValue:navigationControlller] forKey:UIViewControllerNavigationControllerKey];
}

- (UINavigationController *)_65087dc8_navigationController {
    UINavigationController *navigationController = self._65087dc8_navigationController;
    if (navigationController != nil) {
        return navigationController;
    }
    
    UIViewController *parentController = self.parentViewController;
    
    navigationController = parentController.navigationController;
    if (navigationController != nil) {
        return navigationController;
    }
    
    return ((NSWeakReference *)[self associatedObjectForKey:UIViewControllerNavigationControllerKey]).value;
}

- (void)navigation_setPresentingViewController:(UIViewController *)presentingViewController {
    [self setAssociatedObject:[[NSWeakReference alloc] initWithValue:presentingViewController] forKey:UIViewControllerPresentingControllerKey];
}

- (void)navigation_setDismiss:(void (^_Nullable)(void))dismiss rootController:(UIViewController *)rootController {
    UIViewControllerPresentingProxy *proxy = [[UIViewControllerPresentingProxy alloc] initWithRootController:rootController];
    proxy.dismiss = dismiss;
    [self setAssociatedObject:proxy forKey:UIViewControllerPresentingProxyControllerKey];
}

- (UIViewController *)_65087dc8_presentingViewController {
    UINavigationController *navigationController = self.navigationController;
    if (navigationController.presentingViewController != nil) {
        return navigationController.presentingViewController;
    }
    
    UIViewController *controller = ((NSWeakReference *)[self associatedObjectForKey:UIViewControllerPresentingControllerKey]).value;
    if (controller != nil) {
        return controller;
    }
    
    UIViewController *result = [self associatedObjectForKey:UIViewControllerPresentingProxyControllerKey];
    if (result != nil) {
        return result;
    }
    
    return [self _65087dc8_presentingViewController];
}

- (void)_65087dc8_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [self _65087dc8_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)_65087dc8_setNeedsStatusBarAppearanceUpdate {
    [self _65087dc8_setNeedsStatusBarAppearanceUpdate];
    
    void (^block)(void) = [self associatedObjectForKey:setNeedsStatusBarAppearanceUpdateKey];
    if (block) {
        block();
    }
}

- (void)state_setNeedsStatusBarAppearanceUpdate:(void (^_Nullable)(void))block {
    [self setAssociatedObject:[block copy] forKey:setNeedsStatusBarAppearanceUpdateKey];
}

@end

@implementation UIView (Navigation)

- (BOOL)disablesInteractiveTransitionGestureRecognizer {
    return [[self associatedObjectForKey:disablesInteractiveTransitionGestureRecognizerKey] boolValue];
}

- (void)setDisablesInteractiveTransitionGestureRecognizer:(BOOL)disablesInteractiveTransitionGestureRecognizer {
    [self setAssociatedObject:@(disablesInteractiveTransitionGestureRecognizer) forKey:disablesInteractiveTransitionGestureRecognizerKey];
}

- (BOOL)disablesInteractiveKeyboardGestureRecognizer {
    return [[self associatedObjectForKey:disablesInteractiveKeyboardGestureRecognizerKey] boolValue];
}

- (void)setDisablesInteractiveKeyboardGestureRecognizer:(BOOL)disablesInteractiveKeyboardGestureRecognizer {
    [self setAssociatedObject:@(disablesInteractiveKeyboardGestureRecognizer) forKey:disablesInteractiveKeyboardGestureRecognizerKey];
}

- (BOOL (^)(void))disablesInteractiveTransitionGestureRecognizerNow {
    return [self associatedObjectForKey:disablesInteractiveTransitionGestureRecognizerNowKey];
}

- (void)setDisablesInteractiveTransitionGestureRecognizerNow:(BOOL (^)(void))disablesInteractiveTransitionGestureRecognizerNow {
    [self setAssociatedObject:[disablesInteractiveTransitionGestureRecognizerNow copy] forKey:disablesInteractiveTransitionGestureRecognizerNowKey];
}

- (BOOL)disablesInteractiveModalDismiss {
    return [self associatedObjectForKey:disablesInteractiveModalDismissKey];
}

- (void)setDisablesInteractiveModalDismiss:(bool)disablesInteractiveModalDismiss {
    [self setAssociatedObject:@(disablesInteractiveModalDismiss) forKey:disablesInteractiveModalDismissKey];
}

- (BOOL (^)(CGPoint))interactiveTransitionGestureRecognizerTest {
    return [self associatedObjectForKey:interactiveTransitionGestureRecognizerTestKey];
}

- (void)setInteractiveTransitionGestureRecognizerTest:(BOOL (^)(CGPoint))block {
    [self setAssociatedObject:[block copy] forKey:interactiveTransitionGestureRecognizerTestKey];
}

- (UIResponderDisableAutomaticKeyboardHandling)disableAutomaticKeyboardHandling {
    return (UIResponderDisableAutomaticKeyboardHandling)[[self associatedObjectForKey:disableAutomaticKeyboardHandlingKey] unsignedIntegerValue];
}

- (void)setDisableAutomaticKeyboardHandling:(UIResponderDisableAutomaticKeyboardHandling)disableAutomaticKeyboardHandling {
    [self setAssociatedObject:@(disableAutomaticKeyboardHandling) forKey:disableAutomaticKeyboardHandlingKey];
}

- (void)input_setInputAccessoryHeightProvider:(CGFloat (^_Nullable)(void))block {
    [self setAssociatedObject:[block copy] forKey:inputAccessoryHeightProviderKey];
}

- (CGFloat)input_getInputAccessoryHeight {
    CGFloat (^block)(void) = [self associatedObjectForKey:inputAccessoryHeightProviderKey];
    if (block) {
        return block();
    }
    return 0.0f;
}

@end

static NSString *TGEncodeText(NSString *string, int key)
{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (int i = 0; i < (int)[string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        c += key;
        [result appendString:[NSString stringWithCharacters:&c length:1]];
    }
    
    return result;
}

void applyKeyboardAutocorrection(void) {
    static Class keyboardClass = NULL;
    static SEL currentInstanceSelector = NULL;
    static SEL applyVariantSelector = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyboardClass = NSClassFromString(TGEncodeText(@"VJLfzcpbse", -1));
        
        currentInstanceSelector = NSSelectorFromString(TGEncodeText(@"bdujwfLfzcpbse", -1));
        applyVariantSelector = NSSelectorFromString(TGEncodeText(@"bddfquBvupdpssfdujpo", -1));
    });
    
    if ([keyboardClass respondsToSelector:currentInstanceSelector])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id currentInstance = [keyboardClass performSelector:currentInstanceSelector];
        if ([currentInstance respondsToSelector:applyVariantSelector])
            [currentInstance performSelector:applyVariantSelector];
#pragma clang diagnostic pop
    }
}

@interface AboveStatusBarWindowController : UIViewController

@property (nonatomic, copy) UIInterfaceOrientationMask (^ _Nullable supportedOrientations)(void);

@end

@implementation AboveStatusBarWindowController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        self.extendedLayoutIncludesOpaqueBars = true;
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.opaque = false;
    self.view.backgroundColor = nil;
    [self viewDidLoad];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

@implementation AboveStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        self.rootViewController = [[AboveStatusBarWindowController alloc] initWithNibName:nil bundle:nil];
        if (self.gestureRecognizers != nil) {
            for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
                recognizer.delaysTouchesBegan = false;
            }
        }
    }
    return self;
}

- (void)setSupportedOrientations:(UIInterfaceOrientationMask (^)(void))supportedOrientations {
    _supportedOrientations = [supportedOrientations copy];
    ((AboveStatusBarWindowController *)self.rootViewController).supportedOrientations = _supportedOrientations;
}

- (BOOL)shouldAffectStatusBarAppearance {
    return false;
}

- (BOOL)canBecomeKeyWindow {
    return false;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self || result == self.rootViewController.view) {
        return nil;
    }
    return result;
}

+ (void)initialize {
    NSString *canAffectSelectorString = [@[@"_can", @"Affect", @"Status", @"Bar", @"Appearance"] componentsJoinedByString:@""];
    SEL canAffectSelector = NSSelectorFromString(canAffectSelectorString);
    Method shouldAffectMethod = class_getInstanceMethod(self, @selector(shouldAffectStatusBarAppearance));
    IMP canAffectImplementation = method_getImplementation(shouldAffectMethod);
    class_addMethod(self, canAffectSelector, canAffectImplementation, method_getTypeEncoding(shouldAffectMethod));
    
    NSString *canBecomeKeySelectorString = [NSString stringWithFormat:@"_%@", NSStringFromSelector(@selector(canBecomeKeyWindow))];
    SEL canBecomeKeySelector = NSSelectorFromString(canBecomeKeySelectorString);
    Method canBecomeKeyMethod = class_getInstanceMethod(self, @selector(canBecomeKeyWindow));
    IMP canBecomeKeyImplementation = method_getImplementation(canBecomeKeyMethod);
    class_addMethod(self, canBecomeKeySelector, canBecomeKeyImplementation, method_getTypeEncoding(canBecomeKeyMethod));
}

@end
