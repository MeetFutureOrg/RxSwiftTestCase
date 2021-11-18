//
//  HeaderFooterView.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/11/18.
//  Copyright © 2021 Appest. All rights reserved.
//

import UIKit

class HeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet private var sectionTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func provide(_ title: String) {
        sectionTitleLabel.text = title
    }

}
