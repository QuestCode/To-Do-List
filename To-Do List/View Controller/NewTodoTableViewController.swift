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


class NewTodoTableViewController: UITableViewController {

    var delegate: NewTodoTableViewControllerProtocol?
    let cellId = "newTodoCell"
    
    let titleTextField = UITextField(placeholder: "Title")
    
    let dueDateTitleLabel = UILabel(fontSize: 24)
    let dueDateLabel: UILabel = {
        let label = UILabel(fontSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    let dueDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    let notesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        return textView
    }()
    
    var isDueDatePickerShown = false {
        didSet {
            dueDatePicker.isHidden = !isDueDatePickerShown
        }
    }
    
    var todo: Todo? {
        return Todo(title: titleTextField.text!, dueDate: dueDatePicker.date, notes: notesTextView.text)
    }
    
    
    let titleIndexPath = IndexPath(row: 0, section: 0)
    let dueDateIndexPath = IndexPath(row: 0, section: 1)
    let dueDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTodo(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTodo(_:)))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.dueDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        updateDueDateView()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Basic Info"
            case 1: return "Date"
            case 2: return "Notes"
            default: return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return 2
            case 2: return 1
            default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        switch (indexPath.section,indexPath.row) {
        case (titleIndexPath.section,titleIndexPath.row):
            cell.addSubview(titleTextField)
            cell.addContraintsWithFormat(format: "H:|-10-[v0]|", views: titleTextField)
            cell.addContraintsWithFormat(format: "V:|[v0]|", views: titleTextField)
            break
        case (dueDateIndexPath.section,dueDateIndexPath.row):
            dueDateTitleLabel.text = "Due Date: "
            cell.addSubview(dueDateTitleLabel)
            cell.addSubview(dueDateLabel)
            cell.addContraintsWithFormat(format: "H:|-10-[v0][v1]-10-|", views: dueDateTitleLabel,dueDateLabel)
            cell.addContraintsWithFormat(format: "V:|[v0]|", views: dueDateTitleLabel)
            cell.addContraintsWithFormat(format: "V:|[v0]|", views: dueDateLabel)
            break
        case (dueDatePickerIndexPath.section,dueDatePickerIndexPath.row):
            cell.addSubview(dueDatePicker)
            cell.addContraintsWithFormat(format: "H:|[v0]|", views: dueDatePicker)
            cell.addContraintsWithFormat(format: "V:|[v0]|", views: dueDatePicker)
            break
        case (notesIndexPath.section,notesIndexPath.row):
            cell.addSubview(notesTextView)
            cell.addContraintsWithFormat(format: "H:|-10-[v0]|", views: notesTextView)
            cell.addContraintsWithFormat(format: "V:|[v0]|", views: notesTextView)
            break
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section,indexPath.row) {
            case (dueDatePickerIndexPath.section,dueDatePickerIndexPath.row):
                if isDueDatePickerShown {
                    return 216.0
                } else {
                    return 0.0
                }
            case (notesIndexPath.section,notesIndexPath.row):
            return 120
            default:
                return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section,indexPath.row) {
            case (dueDateIndexPath.section,dueDateIndexPath.row):
            if isDueDatePickerShown {
                isDueDatePickerShown = false
            } else {
                isDueDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            break
            default: break
        }
        
    }


}
