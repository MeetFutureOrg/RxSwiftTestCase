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

        let first = ViewController()
        let second = ViewController()

        let firstTitle = "First"
        let secondTitle = "Second"
        
        let iconSize = CGSize(width: 24, height: 24)
        let firstIcon: UIImage = .init(color: .blue, size: iconSize)
        let secondIcon: UIImage = .init(color: .blue, size: iconSize)
        
        let firstItem = UITabBarItem(title: firstTitle, image: firstIcon, selectedImage: nil)
        let secondItem = UITabBarItem(title: secondTitle, image: secondIcon, selectedImage: nil)
        
        first.tabBarItem = firstItem
        second.tabBarItem = secondItem
        setViewControllers(
            [
                NavigationController(rootViewController: first),
                NavigationController(rootViewController: second)
            ],
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
