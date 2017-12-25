//
//  ViewController.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController, NewTodoTableViewControllerProtocol, TodoTableViewCellProtocol {
    

    let cellId = "todoCell"
    var todos = [Todo]()
    var numOfTaskDone = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To-Do List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo(_:)))
        
        if let savedTodos = Todo.loadTodos() {
            todos = savedTodos
            print("found")
        } else {
            todos = Todo.loadSampleTodos()
            todos[0].isComplete = true
            Todo.saveTodos(todos)
        }
        updateTaskCount()
        self.tableView.backgroundColor = .white
        self.tableView.separatorColor = .clear
        self.tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: cellId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addNewTodo(_: UIBarButtonItem){
        let dvc = NewTodoTableViewController()
        dvc.delegate = self
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    
    func checkmarkTapped(sender: TodoTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            let todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        updateTaskCount()
        Todo.saveTodos(todos)
        tableView.reloadData()
    }
    
    func addTodo(todo: Todo) {
        self.todos.append(todo)
        Todo.saveTodos(todos)
        tableView.reloadData()
    }
    
    func updateTaskCount() {
        numOfTaskDone = 0
        for i in 0..<todos.count {
            if todos[i].isComplete {
                numOfTaskDone = numOfTaskDone + 1
            }
        }
    }
    
    //MARK: Tableview delegate and datasource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 60))
        headerView.backgroundColor = UIColor(rgb: 0xfd8208)
        
        let taskNumOfFinishedLabel = UILabel(fontSize: 20)
        taskNumOfFinishedLabel.textAlignment = .left
        taskNumOfFinishedLabel.textColor = .black
        
        let taskTodoLabel = UILabel(fontSize: 20)
        taskTodoLabel.textAlignment = .left
        taskTodoLabel.textColor = .black
        
        headerView.addSubview(taskTodoLabel)
        headerView.addSubview(taskNumOfFinishedLabel)
        
        headerView.addContraintsWithFormat(format: "H:|-5-[v0]-15-[v1]", views: taskNumOfFinishedLabel,taskTodoLabel)
        headerView.addContraintsWithFormat(format: "V:|[v0]|", views: taskNumOfFinishedLabel)
        headerView.addContraintsWithFormat(format: "V:|[v0]|", views: taskTodoLabel)
        
        
        switch section {
        case 0:
//            Uncomment below to add images
            taskNumOfFinishedLabel.text = "Completed: \(numOfTaskDone)"
            taskTodoLabel.text = "Tasks: \(todos.count)"
            return headerView
        default: return headerView
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TodoTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        
        // Create a todo object for each object in array
        let todo = todos[indexPath.row]
        
        // Set labels 
        cell.titleLabel.text = todo.title
        cell.notesLabel.text = todo.notes!
        cell.completedButton.isSelected = todo.isComplete
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.dateFormat = "MM/dd/yy h:mm a"
        
        cell.dueDateLabel.text = "Due: \(dateFormatter.string(from: todo.dueDate))"
        
        cell.completedButton.tintColor = UIColor(rgb: 0xfd8208)
        cell.delegate = self
        if cell.completedButton.isSelected{
            // Have to render image to change color of image
            let image = UIImage(named: "check_on")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.completedButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "check_off")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.completedButton.setImage(image, for: .normal)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTaskCount()
            tableView.reloadData()
            Todo.saveTodos(todos)
        }
    }
}




