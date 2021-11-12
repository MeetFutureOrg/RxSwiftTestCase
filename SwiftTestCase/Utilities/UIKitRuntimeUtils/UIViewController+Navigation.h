//
//  UIViewController+Navigation.h
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, UIResponderDisableAutomaticKeyboardHandling) {
    UIResponderDisableAutomaticKeyboardHandlingForward = 1 << 0,
    UIResponderDisableAutomaticKeyboardHandlingBackward = 1 << 1
};

@interface UIViewController (Navigation)

- (void)setHintWillBePresentedInPreviewingContext:(BOOL)value;
- (BOOL)isPresentedInPreviewingContext;
- (void)setIgnoreAppearanceMethodInvocations:(BOOL)ignoreAppearanceMethodInvocations;
- (BOOL)ignoreAppearanceMethodInvocations;
- (void)navigation_setNavigationController:(UINavigationController * _Nullable)navigationControlller;
- (void)navigation_setPresentingViewController:(UIViewController * _Nullable)presentingViewController;
- (void)navigation_setDismiss:(void (^_Nullable)(void))dismiss rootController:( UIViewController * _Nullable )rootController;
- (void)state_setNeedsStatusBarAppearanceUpdate:(void (^_Nullable)(void))block;

@end

@interface UIView (Navigation)

@property (nonatomic) BOOL disablesInteractiveTransitionGestureRecognizer;
@property (nonatomic) BOOL disablesInteractiveKeyboardGestureRecognizer;
@property (nonatomic) BOOL disablesInteractiveModalDismiss;
@property (nonatomic, copy) BOOL (^ disablesInteractiveTransitionGestureRecognizerNow)(void);

@property (nonatomic) UIResponderDisableAutomaticKeyboardHandling disableAutomaticKeyboardHandling;

@property (nonatomic, copy) BOOL (^_Nullable interactiveTransitionGestureRecognizerTest)(CGPoint);

- (void)input_setInputAccessoryHeightProvider:(CGFloat (^_Nullable)(void))block;
- (CGFloat)input_getInputAccessoryHeight;

@end

void applyKeyboardAutocorrection(void);

@interface AboveStatusBarWindow : UIWindow

@property (nonatomic, copy) UIInterfaceOrientationMask (^ _Nullable supportedOrientations)(void);

@end

NS_ASSUME_NONNULL_END
