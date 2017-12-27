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
        addSubview(checkView)
        
        addContraintsWithFormat(format: "H:[v0(20)]-30-|", views: checkView)
        addContraintsWithFormat(format: "V:|-45-[v0(20)]", views: checkView)
        addContraintsWithFormat(format: "H:|-10-[v0]", views: titleLabel)
        addContraintsWithFormat(format: "V:|-10-[v0]-5-[v1]", views: createdDateLabel,titleLabel)
        addContraintsWithFormat(format: "H:|-10-[v0]", views: createdDateLabel)
    }
}
