//
//  HeaderView.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/26/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    let taskNumOfFinishedLabel: UILabel = {
        let lbl = UILabel(fontSize: 20)
        lbl.textAlignment = .left
        lbl.textColor = .black
        return lbl
    }()
    
    let taskTodoLabel: UILabel = {
        let lbl = UILabel(fontSize: 20)
        lbl.textAlignment = .left
        lbl.textColor = .black
        return lbl
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        self.addSubview(taskTodoLabel)
        self.addSubview(taskNumOfFinishedLabel)
        
        self.addContraintsWithFormat(format: "H:|-5-[v0]-15-[v1]", views: taskNumOfFinishedLabel,taskTodoLabel)
        self.addContraintsWithFormat(format: "V:|[v0]|", views: taskNumOfFinishedLabel)
        self.addContraintsWithFormat(format: "V:|[v0]|", views: taskTodoLabel)
    }

}
