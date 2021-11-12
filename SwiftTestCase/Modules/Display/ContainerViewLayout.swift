//
//  ContainerViewLayout.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/4/21.
//  Copyright © 2021 Appest. All rights reserved.
//

import UIKit

struct ContainerViewLayoutInsetOptions: OptionSet {
    let rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init() {
        rawValue = 0
    }

    static let statusBar = ContainerViewLayoutInsetOptions(rawValue: 1 << 0)
    static let input = ContainerViewLayoutInsetOptions(rawValue: 1 << 1)
}

enum ContainerViewLayoutSizeClass {
    case compact
    case regular
}

struct LayoutMetrics: Equatable {
    let widthClass: ContainerViewLayoutSizeClass
    let heightClass: ContainerViewLayoutSizeClass

    init(widthClass: ContainerViewLayoutSizeClass, heightClass: ContainerViewLayoutSizeClass) {
        self.widthClass = widthClass
        self.heightClass = heightClass
    }

    init() {
        widthClass = .compact
        heightClass = .compact
    }
}

enum LayoutOrientation {
    case portrait
    case landscape
}

struct ContainerViewLayout: Equatable {
    var size: CGSize
    var metrics: LayoutMetrics
    var deviceMetrics: DeviceMetrics
    var intrinsicInsets: UIEdgeInsets
    var safeInsets: UIEdgeInsets
    var additionalInsets: UIEdgeInsets
    var statusBarHeight: CGFloat?
    var inputHeight: CGFloat?
    var inputHeightIsInteractivellyChanging: Bool
    var inVoiceOver: Bool

    init(
        size: CGSize,
        metrics: LayoutMetrics,
        deviceMetrics: DeviceMetrics,
        intrinsicInsets: UIEdgeInsets,
        safeInsets: UIEdgeInsets,
        additionalInsets: UIEdgeInsets,
        statusBarHeight: CGFloat?,
        inputHeight: CGFloat?,
        inputHeightIsInteractivellyChanging: Bool,
        inVoiceOver: Bool
    ) {
        self.size = size
        self.metrics = metrics
        self.deviceMetrics = deviceMetrics
        self.intrinsicInsets = intrinsicInsets
        self.safeInsets = safeInsets
        self.additionalInsets = additionalInsets
        self.statusBarHeight = statusBarHeight
        self.inputHeight = inputHeight
        self.inputHeightIsInteractivellyChanging = inputHeightIsInteractivellyChanging
        self.inVoiceOver = inVoiceOver
    }

    func addedInsets(insets: UIEdgeInsets) -> ContainerViewLayout {
        return ContainerViewLayout(
            size: size,
            metrics: metrics,
            deviceMetrics: deviceMetrics,
            intrinsicInsets: UIEdgeInsets(
                top: intrinsicInsets.top + insets.top,
                left: intrinsicInsets.left + insets.left,
                bottom: intrinsicInsets.bottom + insets.bottom,
                right: intrinsicInsets.right + insets.right
            ),
            safeInsets: safeInsets,
            additionalInsets: additionalInsets,
            statusBarHeight: statusBarHeight,
            inputHeight: inputHeight,
            inputHeightIsInteractivellyChanging: inputHeightIsInteractivellyChanging,
            inVoiceOver: inVoiceOver
        )
    }

    func withUpdatedSize(_ size: CGSize) -> ContainerViewLayout {
        return ContainerViewLayout(
            size: size,
            metrics: metrics,
            deviceMetrics: deviceMetrics,
            intrinsicInsets: intrinsicInsets,
            safeInsets: safeInsets,
            additionalInsets: additionalInsets,
            statusBarHeight: statusBarHeight,
            inputHeight: inputHeight,
            inputHeightIsInteractivellyChanging: inputHeightIsInteractivellyChanging,
            inVoiceOver: inVoiceOver
        )
    }

    func withUpdatedIntrinsicInsets(_ intrinsicInsets: UIEdgeInsets) -> ContainerViewLayout {
        return ContainerViewLayout(
            size: size,
            metrics: metrics,
            deviceMetrics: deviceMetrics,
            intrinsicInsets: intrinsicInsets,
            safeInsets: safeInsets,
            additionalInsets: additionalInsets,
            statusBarHeight: statusBarHeight,
            inputHeight: inputHeight,
            inputHeightIsInteractivellyChanging: inputHeightIsInteractivellyChanging,
            inVoiceOver: inVoiceOver
        )
    }

    func withUpdatedInputHeight(_ inputHeight: CGFloat?) -> ContainerViewLayout {
        return ContainerViewLayout(
            size: size,
            metrics: metrics,
            deviceMetrics: deviceMetrics,
            intrinsicInsets: intrinsicInsets,
            safeInsets: safeInsets,
            additionalInsets: additionalInsets,
            statusBarHeight: statusBarHeight,
            inputHeight: inputHeight,
            inputHeightIsInteractivellyChanging: inputHeightIsInteractivellyChanging,
            inVoiceOver: inVoiceOver
        )
    }

    func withUpdatedMetrics(_ metrics: LayoutMetrics) -> ContainerViewLayout {
        return ContainerViewLayout(
            size: size,
            metrics: metrics,
            deviceMetrics: deviceMetrics,
            intrinsicInsets: intrinsicInsets,
            safeInsets: safeInsets,
            additionalInsets: additionalInsets,
            statusBarHeight: statusBarHeight,
            inputHeight: inputHeight,
            inputHeightIsInteractivellyChanging: inputHeightIsInteractivellyChanging,
            inVoiceOver: inVoiceOver
        )
    }
}

extension ContainerViewLayout {
    func insets(options: ContainerViewLayoutInsetOptions) -> UIEdgeInsets {
        var insets = intrinsicInsets
        if let statusBarHeight = statusBarHeight, options.contains(.statusBar) {
            insets.top = max(statusBarHeight, insets.top)
        }
        if let inputHeight = inputHeight, options.contains(.input) {
            insets.bottom = max(inputHeight, insets.bottom)
        }
        return insets
    }

    var isModalOverlay: Bool {
        if case .tablet = deviceMetrics.type {
            if case .regular = self.metrics.widthClass {
                return abs(
                    max(self.size.width, self.size.height) - self.deviceMetrics.screenSize
                        .height
                ) > 1.0
            }
        }
        return false
    }

    var isNonExclusive: Bool {
        if case .tablet = deviceMetrics.type {
            if case .compact = self.metrics.widthClass {
                return true
            }
            if case .compact = self.metrics.heightClass {
                return true
            }
        }
        return false
    }

    var inSplitView: Bool {
        var maybeSplitView = false
        if case .tablet = deviceMetrics.type {
            if case .compact = self.metrics.widthClass {
                maybeSplitView = true
            }
            if case .compact = self.metrics.heightClass {
                maybeSplitView = true
            }
        }
        if maybeSplitView,
           abs(max(size.width, size.height) - deviceMetrics.screenSize.height) < 1.0
        {
            return true
        }
        return false
    }

    var inSlideOver: Bool {
        var maybeSlideOver = false
        if case .tablet = deviceMetrics.type {
            if case .compact = self.metrics.widthClass {
                maybeSlideOver = true
            }
            if case .compact = self.metrics.heightClass {
                maybeSlideOver = true
            }
        }
        if maybeSlideOver,
           abs(max(size.width, size.height) - deviceMetrics.screenSize.height) > 10.0
        {
            return true
        }
        return false
    }

    var orientation: LayoutOrientation {
        return size.width > size.height ? .landscape : .portrait
    }

    var standardInputHeight: CGFloat {
        return deviceMetrics.keyboardHeight(inLandscape: orientation == .landscape) + deviceMetrics
            .predictiveInputHeight(inLandscape: orientation == .landscape)
    }
}
