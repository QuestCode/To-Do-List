//
//  DevTextView.swift
//  To-Do List
//
//  Created by Devontae Reid on 1/7/18.
//  Copyright © 2018 Devontae Reid. All rights reserved.
//

import UIKit

class DevTextView: UITextView, UITextViewDelegate {

    /*
    // Only override draw() if you UITextViewDelegateperform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let placeholderLabel: UILabel = {
        let lbl = UILabel(fontSize: 14)
        lbl.textColor = UIColor.lightGray
        return lbl
    }()
    
    var placeHolder: String?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }

}
