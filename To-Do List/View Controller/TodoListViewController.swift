//
//  ViewController.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class TodoTableViewController: UIViewController, NewTodoTableViewControllerProtocol, TodoTableViewCellProtocol {
    

    let cellId = "todoCell"
    var todos = [Todo]()
    var numOfTaskDone = 0
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To-Do List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo(_:)))
        
        if let savedTodos = Todo.loadTodos() {
            todos = savedTodos
            print("found")
        } else {
            todos = Todo.loadSampleTodos()
        }
        updateTaskCount()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup
    private func setupView() {
        
        // This is to remove view underneath navigation bar
        self.navigationController?.navigationBar.isTranslucent = false
        
        let bgView = UIImageView(image: UIImage(named: "bolder_bg"))
        bgView.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 0.7
        
        self.view.addSubview(bgView)
        self.view.addSubview(blurEffectView)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        self.collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.collectionViewLayout = layout
        self.collectionView.layer.cornerRadius = 10
        self.collectionView.layer.masksToBounds = true
        self.collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.view.addSubview(collectionView)
        
        self.view.addContraintsWithFormat(format: "H:|[v0]|", views: bgView)
        self.view.addContraintsWithFormat(format: "V:|[v0]|", views: bgView)
        self.view.addContraintsWithFormat(format: "H:|[v0]|", views: blurEffectView)
        self.view.addContraintsWithFormat(format: "V:|[v0]|", views: blurEffectView)
        self.view.addContraintsWithFormat(format: "H:|-25-[v0]-25-|", views: collectionView)
        self.view.addContraintsWithFormat(format: "V:|-35-[v0]-35-|", views: collectionView)
        
        
    }
    
    @objc func addNewTodo(_: UIBarButtonItem){
        let dvc = NewTodoTableViewController()
        dvc.delegate = self
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    
    func checkmarkTapped(sender: TodoCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: sender) {
            let todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            collectionView.reloadItems(at: [indexPath])
        }
        updateTaskCount()
        Todo.saveTodos(todos)
        collectionView.reloadData()
    }
    
    func addTodo(todo: Todo) {
        self.todos.append(todo)
        Todo.saveTodos(todos)
        collectionView.reloadData()
    }
    
    func updateTaskCount() {
        numOfTaskDone = 0
        for i in 0..<todos.count {
            if todos[i].isComplete {
                numOfTaskDone = numOfTaskDone + 1
            }
        }
    }
    
}


extension TodoTableViewController:  UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: Tableview delegate and datasource
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodoCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.backgroundColor = .gray
        
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

//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            todos.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            updateTaskCount()
//            tableView.reloadData()
//            Todo.saveTodos(todos)
//        }
//    }
}




