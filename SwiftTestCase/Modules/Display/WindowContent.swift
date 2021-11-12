//
//  WindowContent.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/4/21.
//  Copyright © 2021 Appest. All rights reserved.
//

import AsyncDisplayKit
import UIKit

protocol WindowHost {
    func forEachController(_ f: (ContainableController) -> Void)
    func present(
        _ controller: ContainableController,
        on level: PresentationSurfaceLevel,
        blockInteraction: Bool,
        completion: @escaping () -> Void
    )
    func presentInGlobalOverlay(_ controller: ContainableController)
    func invalidateDeferScreenEdgeGestures()
    func invalidatePrefersOnScreenNavigationHidden()
    func invalidateSupportedOrientations()
    func cancelInteractiveKeyboardGestures()
}
