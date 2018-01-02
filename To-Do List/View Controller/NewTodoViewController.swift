//
//  NewTodoTableViewController.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

protocol NewTodoTableViewControllerProtocol {
    func addTodo(todo: Todo)
}


class NewTodoTableViewController: UIViewController {
    
    var delegate: NewTodoTableViewControllerProtocol?
    let cellId = "newTodoCell"
    
    let eventImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = UIColor(rgb: 0x5C5C5C)
        img.image = UIImage(named: "glasses")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        return img
    }()
    
    let eventLabel: UILabel = {
        let lbl = UILabel(fontSize: 24)
        lbl.textColor = UIColor(rgb: 0x5C5C5C)
        lbl.text = "Event title:"
        return lbl
    }()
    
    let titleTextField: UITextField = {
        let txtFld = UITextField(placeholder: "  E.g. Design Sprint...")
        txtFld.backgroundColor = .white
        txtFld.layer.borderWidth = 2.0
        txtFld.layer.borderColor = UIColor.lightGray.cgColor
        txtFld.layer.cornerRadius = 3
        txtFld.layer.masksToBounds = true
        return txtFld
    }()
    
    let totalHoursLabel: UILabel = {
        let lbl = UILabel(fontSize: 18)
        lbl.textColor = UIColor(rgb: 0x5C5C5C)
        lbl.text = "Number of hours needed:"
        return lbl
    }()
    
    let totalHoursTextField: UITextField = {
        let txtFld = UITextField(placeholder: "  8")
        txtFld.backgroundColor = .white
        txtFld.layer.borderWidth = 2.0
        txtFld.layer.borderColor = UIColor.lightGray.cgColor
        txtFld.layer.cornerRadius = 3
        txtFld.layer.masksToBounds = true
        return txtFld
    }()
    
    let dueDateLabel: UILabel = {
        let lbl = UILabel(fontSize: 18)
        lbl.textColor = UIColor(rgb: 0x5C5C5C)
        lbl.textAlignment = .right
        return lbl
    }()
    
    let dueDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let descriptionImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = UIColor(rgb: 0x5C5C5C)
        img.image = UIImage(named: "notes")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        return img
    }()
    
    let descriptionLabel: UILabel = {
        let lbl = UILabel(fontSize: 24)
        lbl.textColor = UIColor(rgb: 0x5C5C5C)
        lbl.text = "Event title:"
        return lbl
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 3
        textView.layer.masksToBounds = true
        textView.text = "E.g. this event is going to connect people..."
        textView.textColor = UIColor.lightGray
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        return textView
    }()
    
    var todo: Todo? {
        return Todo(title: titleTextField.text!, dueDate: dueDatePicker.date,numOfHoursRequired: Int(totalHoursTextField.text!)!, description: descriptionTextView.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.view.backgroundColor = UIColor(rgb: 0xDEDEDE)
        self.title = "Add Event"
        self.navigationController?.navigationBar.isTranslucent = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTodo(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTodo(_:)))
        self.dueDatePicker.minuteInterval = 15
        self.dueDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        updateDueDateView()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDueDateView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
        
        dueDateLabel.text = dateFormatter.string(from: dueDatePicker.date)
    }
    
    func setupViews() {
        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(eventImageView)
        titleContainer.addSubview(eventLabel)
        titleContainer.addSubview(titleTextField)
        titleContainer.addContraintsWithFormat(format: "H:|[v0(32)]-5-[v1]", views: eventImageView,eventLabel)
        titleContainer.addContraintsWithFormat(format: "H:|[v0]|", views: titleTextField)
        titleContainer.addContraintsWithFormat(format: "V:|[v0(32)]-10-[v1(40)]|", views: eventImageView,titleTextField)
        titleContainer.addContraintsWithFormat(format: "V:|[v0]", views: eventLabel)
        self.view.addSubview(titleContainer)
        
        
        let timeContainer = UIView()
        timeContainer.translatesAutoresizingMaskIntoConstraints = false
        timeContainer.addSubview(totalHoursLabel)
        timeContainer.addSubview(totalHoursTextField)
        timeContainer.addSubview(dueDateLabel)
        timeContainer.addSubview(dueDatePicker)
        timeContainer.addContraintsWithFormat(format: "H:|[v0]-5-[v1(30)]", views: totalHoursLabel,totalHoursTextField)
        timeContainer.addContraintsWithFormat(format: "V:|[v0]-20-[v1]-5-[v2]|", views: totalHoursLabel,dueDateLabel,dueDatePicker)
        timeContainer.addContraintsWithFormat(format: "V:|[v0]", views: totalHoursTextField)
        timeContainer.addContraintsWithFormat(format: "H:|[v0]", views: dueDateLabel)
        timeContainer.addContraintsWithFormat(format: "H:|-10-[v0]-10-|", views: dueDatePicker)
        self.view.addSubview(timeContainer)
        
        
        let descriptionContainer = UIView()
        descriptionContainer.translatesAutoresizingMaskIntoConstraints = false
        descriptionContainer.addSubview(descriptionImageView)
        descriptionContainer.addSubview(descriptionLabel)
        descriptionContainer.addSubview(descriptionTextView)
        
        descriptionContainer.addContraintsWithFormat(format: "H:|[v0(32)]-5-[v1]", views: descriptionImageView,descriptionLabel)
        descriptionContainer.addContraintsWithFormat(format: "H:|[v0]|", views: descriptionTextView)
        descriptionContainer.addContraintsWithFormat(format: "V:|[v0(32)]-10-[v1(100)]|", views: descriptionImageView,descriptionTextView)
        descriptionContainer.addContraintsWithFormat(format: "V:|[v0]", views: descriptionLabel)
        self.view.addSubview(descriptionContainer)
        
        
        self.view.addContraintsWithFormat(format: "H:|-25-[v0]-25-|", views: titleContainer)
        self.view.addContraintsWithFormat(format: "H:|-25-[v0]-25-|", views: timeContainer)
        self.view.addContraintsWithFormat(format: "H:|-25-[v0]-25-|", views: descriptionContainer)
        self.view.addContraintsWithFormat(format: "V:|-20-[v0]-20-[v1]-20-[v2]", views: titleContainer,timeContainer,descriptionContainer)
    }
    
    // MARK: Actions
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDueDateView()
    }
    
    @objc func cancelTodo(_: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveTodo(_: UIBarButtonItem){
        self.delegate?.addTodo(todo: todo!)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
