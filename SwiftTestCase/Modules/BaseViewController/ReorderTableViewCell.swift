//
//  ReorderTableViewCell.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/11/18.
//  Copyright © 2021 Appest. All rights reserved.
//

import UIKit

class ReorderTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet private var sortMark: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        let red = CGFloat.random(in: 0.8...1)
        let green = CGFloat.random(in: 0.8...1)
        let blue = CGFloat.random(in: 0.8...1)
        contentView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        titleLabel.font = .systemFont(ofSize: 15)
    }

    class func loadFromNib() -> ReorderTableViewCell {
        let nib = UINib(nibName: "ReorderTableViewCell", bundle: nil)
            .instantiate(withOwner: nil, options: nil)

        guard let cell = nib.first as? ReorderTableViewCell else {
            fatalError("The nib name do not match class.")
        }
        return cell
    }

    func provide(_ title: String) {
        titleLabel.text = title
    }

}
