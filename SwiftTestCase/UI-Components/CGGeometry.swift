//
//  CGGeometry.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/11/13.
//  Copyright © 2021 Appest. All rights reserved.
//

import CoreGraphics

// MARK: - Geometry

extension CGFloat {

    var removeFloatMin: Self {
        guard self != .leastNormalMagnitude,
              self != .leastNonzeroMagnitude else { return 0 }
        return self
    }

    func flatSpecificScale(_ scale: CGFloat = 0) -> Self {
        let value = removeFloatMin
        return ceil(value * scale) / scale
    }

    var flat: Self {
        return flatSpecificScale(UIScreen.main.scale)
    }

    func centre(_ other: CGFloat) -> Self {
        return ((self - other) / 2.0).flat
    }
}

extension UIEdgeInsets {

    var removeFloatMin: Self {
        return UIEdgeInsets(
            top: top.removeFloatMin,
            left: left.removeFloatMin,
            bottom: bottom.removeFloatMin,
            right: right.removeFloatMin
        )
    }

    var horizontal: CGFloat {
        return left + right
    }

    var vertical: CGFloat {
        return top + bottom
    }
}

extension CGRect {

    func setX(_ x: CGFloat) -> Self {
        var rect = self
        rect.origin.x = x.flat
        return rect
    }

    func setY(_ y: CGFloat) -> Self {
        var rect = self
        rect.origin.y = y.flat
        return rect
    }

    func setXY(_ x: CGFloat, _ y: CGFloat) -> Self {
        var rect = self
        rect.origin.x = x.flat
        rect.origin.y = y.flat
        return rect
    }

    func setWidth(_ width: CGFloat) -> Self {
        var rect = self
        rect.size.width = width.flat
        return rect
    }

    func setHeight(_ height: CGFloat) -> Self {
        var rect = self
        rect.size.height = height.flat
        return rect
    }

    var flatted: Self {
        return CGRect(
            x: origin.x.flat,
            y: origin.y.flat,
            width: size.width.flat,
            height: size.height.flat
        )
    }
}
