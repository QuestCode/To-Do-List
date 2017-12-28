//
//  TodoListTableViewCell.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit


class TodoTableViewCell: UITableViewCell {
    
    var checkView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.tintColor = UIColor(rgb: 0xA47AF4)
        imgView.image = UIImage(named: "check")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(fontSize: 16)
        return label
    }()
    
    let dueDateLabel: UILabel = {
        let label = UILabel(fontSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    let notesLabel: UILabel = {
        let label = UILabel(fontSize: 18)
        return label
    }()
    
    var dotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(rgb: 0xA47AF4)
        return view
    }()
    
    var date: Date?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        addSubview(titleLabel)
        addSubview(dueDateLabel)
        addSubview(checkView)
        addSubview(dotView)
        
        addContraintsWithFormat(format: "H:[v0(10)]-30-|", views: checkView)
        addContraintsWithFormat(format: "V:|-30-[v0(10)]", views: checkView)
        addContraintsWithFormat(format: "H:|-10-[v0]-10-[v1(5)]-20-[v2]", views: dueDateLabel,dotView,titleLabel)
        addContraintsWithFormat(format: "V:|-20-[v0]", views: dueDateLabel)
        addContraintsWithFormat(format: "V:|-25-[v0(5)]", views: dotView)
        addContraintsWithFormat(format: "V:|-20-[v0]", views: titleLabel)
        addContraintsWithFormat(format: "H:|-10-[v0]", views: dueDateLabel)
    }
}
