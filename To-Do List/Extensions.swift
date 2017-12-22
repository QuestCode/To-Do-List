//
//  Extensions.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(fontSize: CGFloat) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize)
    }
}


extension UIView {
    func addContraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


extension UITextField {
    convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
