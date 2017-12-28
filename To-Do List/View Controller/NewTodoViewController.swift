//
//  NewTodoTableViewController.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

protocol NewTodoViewControllerProtocol {
    func addTodo(todo: Todo)
}


class NewTodoViewController: UIViewController {

    var delegate: NewTodoViewControllerProtocol?
    let cellId = "newTodoCell"
    
    let titleTextField = UITextField(placeholder: "Title")
    
    let dueDateLabel: UILabel = {
        let label = UILabel(fontSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    let dueDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.minuteInterval = 15
        return picker
    }()

    let notesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        return textView
    }()
    
    let cancelBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(rgb: 0xA47AF4)
        btn.setTitle("Cancel", for: .normal)
        btn.addTarget(self, action: #selector(cancelTodo(_:)), for: .touchUpInside)
        return btn
    }()
    
    let doneBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(rgb: 0xA47AF4)
        btn.setTitle("Done", for: .normal)
        btn.addTarget(self, action: #selector(saveTodo(_:)), for: .touchUpInside)
        return btn
    }()
    
    var isDueDatePickerShown = false {
        didSet {
            dueDatePicker.isHidden = !isDueDatePickerShown
        }
    }
    
    var todo: Todo? {
        return Todo(title: titleTextField.text!, dueDate: dueDatePicker.date, notes: notesTextView.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.view.backgroundColor = .clear

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        setupView()
        self.dueDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        updateDueDateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView() {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.alpha = 0.5
        self.view.addSubview(bgView)
        self.view.addContraintsWithFormat(format: "H:|[v0]|", views: bgView)
        self.view.addContraintsWithFormat(format: "V:|[v0]|", views: bgView)
        
        let viewsContainer = UIView()
        viewsContainer.backgroundColor = .blue
        viewsContainer.translatesAutoresizingMaskIntoConstraints = false
        viewsContainer.layer.cornerRadius = 10
        viewsContainer.layer.masksToBounds = true
        self.view.addSubview(viewsContainer)
        self.view.addContraintsWithFormat(format: "H:|-30-[v0]-30-|", views: viewsContainer)
        self.view.addContraintsWithFormat(format: "V:|-140-[v0]-140-|", views: viewsContainer)
        
        viewsContainer.addSubview(titleTextField)
        viewsContainer.addSubview(dueDateLabel)
        viewsContainer.addSubview(dueDatePicker)
        viewsContainer.addSubview(notesTextView)
        viewsContainer.addSubview(cancelBtn)
        viewsContainer.addSubview(doneBtn)
        
        print((titleTextField.text?.isEmpty)!)
        
//        doneBtn.isEnabled = (titleTextField.text?.isEmpty)! ? false : true
        
        viewsContainer.addContraintsWithFormat(format: "H:|-10-[v0]|", views: titleTextField)
        viewsContainer.addContraintsWithFormat(format: "V:|-50-[v0(30)][v1(30)][v2(216)][v3(80)]", views: titleTextField,dueDateLabel,dueDatePicker,notesTextView)
        viewsContainer.addContraintsWithFormat(format: "V:[v0(30)]-10-|", views: cancelBtn)
        viewsContainer.addContraintsWithFormat(format: "V:[v0(30)]-10-|", views: doneBtn)
        viewsContainer.addContraintsWithFormat(format: "H:[v0]-10-|", views: dueDateLabel)
        viewsContainer.addContraintsWithFormat(format: "H:|[v0]|", views: dueDatePicker)
        viewsContainer.addContraintsWithFormat(format: "H:|-10-[v0]-10-|", views: notesTextView)
        viewsContainer.addContraintsWithFormat(format: "H:|-10-[v0(160)]", views: cancelBtn)
        viewsContainer.addContraintsWithFormat(format: "H:[v0(160)]-10-|", views: doneBtn)
        
    }
    
    func updateDueDateView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
        
        dueDateLabel.text = dateFormatter.string(from: dueDatePicker.date)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDueDateView()
    }
    
    @objc func cancelTodo(_: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTodo(_: UIBarButtonItem){
        self.delegate?.addTodo(todo: todo!)
        self.dismiss(animated: true, completion: nil)
    }

}
