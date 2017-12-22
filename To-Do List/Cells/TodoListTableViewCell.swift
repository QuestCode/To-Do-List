//
//  TodoListTableViewCell.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

@objc protocol TodoTableViewCellProtocol {
    func checkmarkTapped(sender: TodoTableViewCell)
}


class TodoTableViewCell: UITableViewCell {
    
    var delegate: TodoTableViewCellProtocol?
    
    @objc let completedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(fontSize: 24)
        return label
    }()
    
    let dueDateLabel: UILabel = {
        let label = UILabel(fontSize: 14)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(completedButton)
        addSubview(notesLabel)
        addSubview(dueDateLabel)
        
        completedButton.addTarget(self, action: #selector(completedButtonTapped(button:)), for: .touchUpInside)
        
        
        addContraintsWithFormat(format: "H:|-10-[v0]", views: titleLabel)
        addContraintsWithFormat(format: "V:|-5-[v0(24)][v1]|", views: titleLabel,notesLabel)
        addContraintsWithFormat(format: "H:|-10-[v0]-50-|", views: notesLabel)
        addContraintsWithFormat(format: "V:|-25-[v0(30)]", views: completedButton)
        addContraintsWithFormat(format: "H:[v0(30)]-10-|", views:completedButton)
        
        addContraintsWithFormat(format: "H:[v0]-50-|", views: dueDateLabel)
        addContraintsWithFormat(format: "V:|-10-[v0]", views: dueDateLabel)
    }
    
    
    @objc func completedButtonTapped(button: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    

}
