//
//  CustomCalendarCell.swift
//  Dev's Calendar
//
//  Created by Devontae Reid on 12/26/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class CustomCalendarCell: JTAppleCell {

    var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    var eventDotView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var isCompleted = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addSubview(selectedView)
        addSubview(dateLabel)
        addSubview(eventDotView)
        
//        selectedView.dropShadow()
        
        addContraintsWithFormat(format: "H:|-15-[v0(30)]", views: selectedView)
        addContraintsWithFormat(format: "V:|-5-[v0(30)]", views: selectedView)
        addContraintsWithFormat(format: "H:|[v0]|", views: dateLabel)
        addContraintsWithFormat(format: "V:|[v0]|", views: dateLabel)
        addContraintsWithFormat(format: "H:|-30-[v0(2)]", views: eventDotView)
        addContraintsWithFormat(format: "V:[v0(2)]-5-|", views: eventDotView)
    }
    
}
