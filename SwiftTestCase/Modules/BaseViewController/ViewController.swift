//
//  ViewController.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import UIKit

protocol StandalonePresentableController: ViewController {}

private func findCurrentResponder(_ view: UIView) -> UIResponder? {
    if view.isFirstResponder {
        return view
    } else {
        for subview in view.subviews {
            if let result = findCurrentResponder(subview) {
                return result
            }
        }
        return nil
    }
}

private func findWindow(_ view: UIView) -> WindowHost? {
    if let view = view as? WindowHost {
        return view
    } else if let superview = view.superview {
        return findWindow(superview)
    } else {
        return nil
    }
}

enum ViewControllerPresentationAnimation {
    case none
    case modalSheet
}

struct ViewControllerSupportedOrientations: Equatable {
    var regularSize: UIInterfaceOrientationMask
    var compactSize: UIInterfaceOrientationMask

    init(regularSize: UIInterfaceOrientationMask, compactSize: UIInterfaceOrientationMask) {
        self.regularSize = regularSize
        self.compactSize = compactSize
    }

    func intersection(_ other: ViewControllerSupportedOrientations)
        -> ViewControllerSupportedOrientations
    {
        return ViewControllerSupportedOrientations(
            regularSize: regularSize.intersection(other.regularSize),
            compactSize: compactSize.intersection(other.compactSize)
        )
    }
}

class ViewControllerPresentationArguments {
    let presentationAnimation: ViewControllerPresentationAnimation
    let completion: (() -> Void)?

    init(
        presentationAnimation: ViewControllerPresentationAnimation,
        completion: (() -> Void)? = nil
    ) {
        self.presentationAnimation = presentationAnimation
        self.completion = completion
    }
}

enum ViewControllerNavigationPresentation {
    case `default`
    // swiftlint:disable inclusive_language
    case master
    // swiftlint:enable inclusive_language
    case modal
    case flatModal
    case standaloneModal
    case modalInLargeLayout
}

enum TabBarItemContextActionType {
    case none
    case always
    case whenActive
}

class ViewController: ASDKViewController<ASDisplayNode> {

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

}
