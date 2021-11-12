//
//  UIMenuItem+Icons.h
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIMenuItem (Icons)

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(SEL)action;

@end

@interface UILabel (DateLabel)

+ (void)setDateLabelColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
