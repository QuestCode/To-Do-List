//
//  TodoListTableViewCell.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

@objc protocol TodoTableViewCellProtocol {
    func checkmarkTapped(sender: TodoCollectionViewCell)
}


class TodoCollectionViewCell: UICollectionViewCell {
    
    var delegate: TodoTableViewCellProtocol?
    
    @objc let completedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(completedButton)
        addSubview(dueDateLabel)
        addSubview(selectionView)
        
        completedButton.addTarget(self, action: #selector(completedButtonTapped(button:)), for: .touchUpInside)
        
        addContraintsWithFormat(format: "H:|[v0(5)]", views: selectionView)
        addContraintsWithFormat(format: "V:|[v0]|", views: selectionView)
        addContraintsWithFormat(format: "H:|-10-[v0]", views: titleLabel)
        addContraintsWithFormat(format: "V:|-10-[v0]-5-[v1]", views: dueDateLabel,titleLabel)
        addContraintsWithFormat(format: "V:|-35-[v0(30)]", views: completedButton)
        addContraintsWithFormat(format: "H:[v0(30)]-10-|", views:completedButton)
        
        addContraintsWithFormat(format: "H:|-10-[v0]", views: dueDateLabel)
    }
    
    
    @objc func completedButtonTapped(button: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    

}
