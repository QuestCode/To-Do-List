//
//  TodoListTableViewCell.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit


class TodoTableViewCell: UITableViewCell {
    
    let selectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x3ECEFF)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(fontSize: 24)
        return label
    }()
    
    let createdDateLabel: UILabel = {
        let label = UILabel(fontSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    let notesLabel: UILabel = {
        let label = UILabel(fontSize: 18)
        return label
    }()
    
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
        addSubview(createdDateLabel)
        addSubview(selectionView)
        
        addContraintsWithFormat(format: "H:|[v0(5)]", views: selectionView)
        addContraintsWithFormat(format: "V:|[v0]|", views: selectionView)
        addContraintsWithFormat(format: "H:|-10-[v0]", views: titleLabel)
        addContraintsWithFormat(format: "V:|-10-[v0]-5-[v1]", views: createdDateLabel,titleLabel)
        addContraintsWithFormat(format: "H:|-10-[v0]", views: createdDateLabel)
    }
}
