//
//  PresentationContext.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/4/21.
//  Copyright © 2021 Appest. All rights reserved.
//

import UIKit

public struct PresentationSurfaceLevel: RawRepresentable {
    public var rawValue: Int32

    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }

    public static let root = PresentationSurfaceLevel(rawValue: 0)
}
