//
//  TodoListTableViewCell.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/29/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit
protocol TodoCollectionViewCellProtocol {
    func deleteTodo(cell)
}

class TodoCollectionViewCell: UICollectionViewCell {
    
    var clockView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.lightGray
        imageView.image = UIImage(named: "clock")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        return imageView
    }()
    
    var trashView: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor.lightGray
        btn.setImage(UIImage(named: "trash")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        return btn
    }()
    
    var checkView: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor.lightGray
        btn.setImage(UIImage(named: "check")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        return btn
    }()
    
    let startTimeLabel: UILabel = {
        let label = UILabel(fontSize: 10)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    let endTimeLabel: UILabel = {
        let label = UILabel(fontSize: 10)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(fontSize: 16)
        return label
    }()
    
    let notesLabel: UILabel = {
        let label = UILabel(fontSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupViews() {
        let timeContainer = UIView()
        timeContainer.translatesAutoresizingMaskIntoConstraints = false
        timeContainer.addSubview(startTimeLabel)
        timeContainer.addSubview(endTimeLabel)
        
        timeContainer.addContraintsWithFormat(format: "H:|[v0]|", views: startTimeLabel)
        timeContainer.addContraintsWithFormat(format: "H:|[v0]|", views: endTimeLabel)
        timeContainer.addContraintsWithFormat(format: "V:|[v0][v1]|", views: startTimeLabel,endTimeLabel)
        
        let infoContainer = UIView()
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.addSubview(titleLabel)
        infoContainer.addSubview(notesLabel)
        infoContainer.addContraintsWithFormat(format: "H:|[v0]|", views: titleLabel)
        infoContainer.addContraintsWithFormat(format: "H:|[v0(160)]|", views: notesLabel)
        infoContainer.addContraintsWithFormat(format: "V:|[v0][v1]|", views: titleLabel,notesLabel)
        
        
        addSubview(timeContainer)
        addSubview(infoContainer)
        addSubview(clockView)
        addSubview(trashView)
        addSubview(checkView)
        
        addContraintsWithFormat(format: "H:|-10-[v0(30)]-10-[v1]-20-[v2]", views: clockView,timeContainer,infoContainer)
        addContraintsWithFormat(format: "V:|-30-[v0(30)]", views: clockView)
        addContraintsWithFormat(format: "V:|-30-[v0]", views: timeContainer)
        addContraintsWithFormat(format: "V:|-30-[v0]", views: infoContainer)
        
        addContraintsWithFormat(format: "H:[v0(25)]-20-[v1(25)]-20-|", views: checkView,trashView)
        addContraintsWithFormat(format: "V:|-30-[v0(25)]", views: checkView)
        addContraintsWithFormat(format: "V:|-30-[v0(25)]", views: trashView)
    }
}


