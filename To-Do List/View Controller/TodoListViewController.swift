//
//  ViewController.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController, NewTodoTableViewControllerProtocol {

    let cellId = "todoCell"
    var todos = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To-Do List"
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo(_:)))
        
        
        if let savedTodos = Todo.loadTodos() {
            todos = savedTodos
        } else {
            todos = Todo.loadSampleTodos()
        }
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
    
    func addTodo(todo: Todo) {
        self.todos.append(todo)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TodoTableViewCell
        cell.selectionStyle = .none
        
        let todo = todos[indexPath.row]
        
        cell.titleLabel.text = todo.title
        cell.notesLabel.text = todo.notes!
        
        if todo.isComplete {
            cell.completedImageView.renderImage(image: UIImage(named: "check_on")!, color: UIColor(rgb: 0xfd8208))
        } else {
            cell.completedImageView.renderImage(image: UIImage(named: "check_off")!, color: UIColor(rgb: 0xfd8208))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        todo.isComplete = !todo.isComplete
        
        if todo.isComplete {
            cell.completedImageView.renderImage(image: UIImage(named: "check_on")!, color: UIColor(rgb: 0xfd8208))
        } else {
            cell.completedImageView.renderImage(image: UIImage(named: "check_off")!, color: UIColor(rgb: 0xfd8208))
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}




