//
//  TabBarController.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/4/19.
//  Copyright © 2021 Appest. All rights reserved.
//

import AsyncDisplayKit

class TabBarController: ASTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        delegate = self
        setupChildControllers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupChildControllers() {

        let viewController = ViewController()

        let title = "Demos"

        let item = UITabBarItem(title: title, image: nil, selectedImage: nil)

        viewController.tabBarItem = item
        setViewControllers(
            [NavigationController(rootViewController: viewController)],
            animated: false
        )
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {}
}
