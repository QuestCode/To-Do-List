//
//  TodoListTableViewCell.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

@objc protocol TodoTableViewCellProtocol {
    func moreButtonTapped(sender: TodoCollectionViewCell)
    func completeButtonTapped(sender: TodoCollectionViewCell)
    func deleteButtonTapped(sender: TodoCollectionViewCell)
    func editButtonTapped(sender: TodoCollectionViewCell)
}


class TodoCollectionViewCell: UICollectionViewCell {
    
    var delegate: TodoTableViewCellProtocol?
    
    @objc let moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(rgb: 0x3ECEFF)
        return button
    }()
    
    @objc let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(rgb: 0x3ECEFF)
        button.alpha = 0
        return button
    }()
    
    @objc let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(rgb: 0x3ECEFF)
        button.alpha = 0
        return button
    }()
    
    @objc let completedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(rgb: 0x3ECEFF)
        button.alpha = 0
        return button
    }()
    
    let selectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
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
        addSubview(titleLabel)
        addSubview(moreButton)
        addSubview(createdDateLabel)
        addSubview(selectionView)
        addSubview(completedButton)
        addSubview(deleteButton)
        addSubview(editButton)
        
        moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
        completedButton.addTarget(self, action: #selector(completeButtonTapped(_:)), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        let moreImage = UIImage(named: "more")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let checkImage = UIImage(named: "check")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let editImage = UIImage(named: "edit")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let deleteImage = UIImage(named: "delete")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        moreButton.setImage(moreImage, for: .normal)
        completedButton.setImage(checkImage, for: .normal)
        editButton.setImage(editImage, for: .normal)
        deleteButton.setImage(deleteImage, for: .normal)
        
        addContraintsWithFormat(format: "H:|[v0(5)]", views: selectionView)
        addContraintsWithFormat(format: "V:|[v0]|", views: selectionView)
        addContraintsWithFormat(format: "H:|-10-[v0]", views: titleLabel)
        addContraintsWithFormat(format: "V:|-10-[v0]-5-[v1]", views: createdDateLabel,titleLabel)
        addContraintsWithFormat(format: "V:|-45-[v0(20)]", views: moreButton)
        addContraintsWithFormat(format: "H:[v0(20)]-20-|", views: moreButton)
        
        addContraintsWithFormat(format: "V:|-5-[v0(20)]", views: completedButton)
        addContraintsWithFormat(format: "H:[v0(20)]-20-|", views: completedButton)
        
        addContraintsWithFormat(format: "V:|-45-[v0(20)]", views: editButton)
        addContraintsWithFormat(format: "H:[v0(20)]-70-|", views: editButton)
        
        addContraintsWithFormat(format: "V:[v0(20)]-5-|", views: deleteButton)
        addContraintsWithFormat(format: "H:[v0(20)]-20-|", views: deleteButton)
        
        
        
        addContraintsWithFormat(format: "H:|-10-[v0]", views: createdDateLabel)
    }
    
    
    @objc func moreButtonTapped(_: UIButton) {
        delegate?.moreButtonTapped(sender: self)
    }
    
    @objc func completeButtonTapped(_: UIButton) {
        delegate?.completeButtonTapped(sender: self)
    }
    
    @objc func deleteButtonTapped(_: UIButton) {
        delegate?.deleteButtonTapped(sender: self)
    }
    
    @objc func editButtonTapped(_: UIButton) {
        delegate?.editButtonTapped(sender: self)
    }

}
