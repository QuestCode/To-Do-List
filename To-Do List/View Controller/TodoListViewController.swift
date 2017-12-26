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
    
    // MARK: Protocol Functions
    func completeButtonTapped(sender: TodoCollectionViewCell) {
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
    
    func moreButtonTapped(sender: TodoCollectionViewCell) {
        let completeCenter = sender.completedButton.center
        let editCenter = sender.editButton.center
        let deleteCenter = sender.deleteButton.center
        let moreCenter = sender.moreButton.center
        
        let moreImage = UIImage(named: "more")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        if sender.moreButton.currentImage == moreImage {
            let circleImage = UIImage(named: "circle")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            sender.moreButton.setImage(circleImage, for: .normal)
            sender.completedButton.alpha = 1
            sender.editButton.alpha = 1
            sender.deleteButton.alpha = 1
            sender.completedButton.center = completeCenter
            sender.editButton.center = editCenter
            sender.deleteButton.center = deleteCenter
        } else {
            sender.moreButton.setImage(moreImage, for: .normal)
            sender.completedButton.alpha = 0
            sender.editButton.alpha = 0
            sender.deleteButton.alpha = 0
            sender.completedButton.center = moreCenter
            sender.editButton.center = moreCenter
            sender.deleteButton.center = moreCenter
        }
    }
    
    func deleteButtonTapped(sender: TodoCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: sender) {
            todos.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            updateTaskCount()
            collectionView.reloadData()
            Todo.saveTodos(todos)
        }
    }
    
    func editButtonTapped(sender: TodoCollectionViewCell) {
        print("edot")
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

        cell.createdDateLabel.text = "Created: \(dateFormatter.string(from: todo.dueDate))"

        cell.delegate = self
        
        let image = UIImage(named: "check")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        if todo.isComplete{
            // Have to render image to change color of image
            cell.selectionView.backgroundColor = UIColor(rgb: 0x3ECEFF)
            cell.completedButton.tintColor = .red
            cell.completedButton.setImage(image, for: .normal)
        } else {
            cell.selectionView.backgroundColor = .white
            cell.completedButton.setImage(image, for: .normal)
        }
        return cell
    }
}




