//
//  ViewController.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController {

    let cellIdForTableView = "todoCell"
    var todos = [Todo]()
    var selectedTodos = [Todo]()
    var todosDict = [String:String]()
    var numOfTaskDone = 0
    
    var collectionView: UICollectionView!
    
    let backgroundColor = UIColor(rgb: 0x317FE0)
    let insideTextColor = UIColor.white
    let outsideTextColor = UIColor(rgb: 0x739FD6)
    let selectedTextColor = UIColor(rgb: 0x65A0E9)
    
    
    var calendarView: JTAppleCalendarView!
    let cellIdForCalendar = "id"
    let formatter = DateFormatter()
    
    let monthLabel:  UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: lbl.font.fontName, size: 34)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let yearLabel:  UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: lbl.font.fontName, size: 20)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    var dayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "To-Do List"
        // This is to remove view underneath navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addNewTodo(_:)))
        self.view.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        if let savedTodos = Todo.loadTodos() {
            todos = savedTodos
            todos.sort{ $0.dueDate < $1.dueDate }
        } else {
            todos = Todo.loadSampleTodos()
            todos.sort{ $0.dueDate < $1.dueDate }
        }
        updateTaskCount()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup
    private func setupTableView() {
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 30, height: 90)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: cellIdForTableView)
        collectionView.backgroundColor = UIColor(rgb: 0xE6E6E6)
        self.view.addSubview(collectionView)
        
        // Setup up calendarView
        
        self.calendarView = JTAppleCalendarView()
        self.view.addSubview(calendarView)
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.scrollDirection = .horizontal
        self.calendarView.showsHorizontalScrollIndicator = false
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        self.calendarView.backgroundColor = .clear
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        self.calendarView.register(CustomCalendarCell.self, forCellWithReuseIdentifier: cellIdForCalendar)
        self.calendarView.scrollToDate(Date(),animateScroll: false)
        self.calendarView.selectDates([ Date() ])
        self.view.addSubview(monthLabel)
        self.view.addSubview(yearLabel)
        
        // This is used to labels to present the months and year
        self.calendarView.visibleDates() { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "yyyy"
            self.yearLabel.text = self.formatter.string(from: date)
        }
        
        setupDaysView()
        formatTodosDict()
        
        self.view.addContraintsWithFormat(format: "H:|-30-[v0]-30-|", views: calendarView)
        self.view.addContraintsWithFormat(format: "V:|-40-[v0]-15-[v1]-10-[v2][v3(240)][v4]|", views: yearLabel,monthLabel,dayView,calendarView,collectionView)
        self.view.addContraintsWithFormat(format: "H:|-30-[v0]-30-|", views: dayView)
        self.view.addContraintsWithFormat(format: "H:|-20-[v0]", views: monthLabel)
        self.view.addContraintsWithFormat(format: "H:|-20-[v0]", views: yearLabel)
        
        self.view.addContraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        
        
    }
    
    
    
    private func setupDaysView() {
        self.view.addSubview(dayView)
        
        let days = ["S","M","T","W","T","F","S"]
        var daysLabels = [UILabel]()
        
        for day in days {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = day
            lbl.textAlignment = .center
            lbl.textColor = insideTextColor
            daysLabels.append(lbl)
        }
        
        for lbl in daysLabels {
            self.dayView.addSubview(lbl)
            self.dayView.addContraintsWithFormat(format: "V:|[v0]|", views: lbl)
        }
        
        self.dayView.backgroundColor = .clear
        self.dayView.addContraintsWithFormat(format: "H:|[v0(50)][v1(50)][v2(50)][v3(50)][v4(50)][v5(50)][v6]|", views: daysLabels[0],daysLabels[1],daysLabels[2],daysLabels[3],daysLabels[4],daysLabels[5],daysLabels[6])
        
    }
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let customCell = cell as? CustomCalendarCell else { return }
        
        handleCellSelectedColor(cell: customCell, cellState: cellState)
        handleTextColor(cell: customCell, cellState: cellState)
        handleCellEvents(cell: customCell, cellState: cellState)
    }
    
    func handleTextColor(cell:CustomCalendarCell,cellState: CellState) {
        
        let todayDate = Date()
        formatter.dateFormat = "MM dd yyyy"
        let todatDateString = formatter.string(from: todayDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        if todatDateString == monthDateString {
            cell.dateLabel.textColor = .red
        } else if cell.isSelected {
            cell.dateLabel.textColor = selectedTextColor
        } else {
            handleCalendarCellColor(cell: cell, cellState: cellState)
        }

    }
    
    func handleCalendarCellColor(cell: CustomCalendarCell, cellState: CellState) {
        cell.dateLabel.textColor = cellState.dateBelongsTo == .thisMonth ? insideTextColor : outsideTextColor
    }
    
    func handleCellSelectedColor(cell: CustomCalendarCell, cellState: CellState) {
        cell.selectedView.isHidden = cellState.isSelected ? false : true
    }
    
    func handleCellEvents(cell: CustomCalendarCell, cellState: CellState) {
        cell.eventDotView.isHidden = !todosDict.contains { $0.key == formatter.string(from: cellState.date) }
    }
    
    
    // MARK: Table View Button Actions
    
    @objc func addNewTodo(_: UIBarButtonItem){
        let dvc = NewTodoTableViewController()
        dvc.delegate = self
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    // MARK: Protocol Functions
    func editButtonTapped(sender: TodoTableViewCell) {
        let dvc = EditTodoTableViewController()
        dvc.delegate = self
        print(dvc.todo!.dueDate)
        self.present(dvc, animated: true, completion: nil)
    }
    
    
    func updateTaskCount() {
        numOfTaskDone = 0
        for i in 0..<todos.count {
            if todos[i].isComplete {
                numOfTaskDone = numOfTaskDone + 1
            }
        }
    }
    
    func formatTodosDict() {
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            let todoObjects = self.createTodosDict()
            for (date, event) in todoObjects {
                let stringDate = self.formatter.string(from: date)
                self.todosDict[stringDate] = event
            }
        }
        
        DispatchQueue.main.async {
            self.calendarView.reloadData()
        }
    }
    
    func createTodosDict() -> [Date:String] {
        formatter.dateFormat = "MM dd yyyy"
        
        var dict = [Date:String]()
        
        for todo in todos {
            dict[todo.dueDate] =  todo.title
        }
        return dict
    }
    
}

// MARK: Edit and Add Protocols

extension TodoViewController: NewTodoTableViewControllerProtocol, EditTodoTableViewControllerProtocol, TodoCollectionViewCellProtocol {
    func deleteTodo(sender: TodoCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: sender) {
            todos.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            updateTaskCount()
            Todo.saveTodos(todos)
            collectionView.reloadData()
        }
    }
    
    @objc func completeTodo(sender: TodoCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: sender) {
            let todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            collectionView.reloadItems(at: [indexPath])
            collectionView.reloadData()
        }
        updateTaskCount()
        Todo.saveTodos(todos)
        collectionView.reloadData()
    }
    
    func editTodo(todo: Todo) {
        
    }
    
    func addTodo(todo: Todo) {
        self.todos.append(todo)
        Todo.saveTodos(todos)
        collectionView.reloadData()
    }
}

extension TodoViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedTodos.count != 0 ? selectedTodos.count : todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdForTableView, for: indexPath) as! TodoCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 10
        
        cell.delegate = self
        
        formatter.dateFormat = "hh:mm a"
        
        let todo = selectedTodos.count != 0 ? selectedTodos[indexPath.row] : todos[indexPath.row]
        
        cell.titleLabel.text = todo.title
        cell.notesLabel.text = todo.notes
        cell.endTimeLabel.text = formatter.string(from: todo.dueDate)
        cell.checkBtn.tintColor = todo.isComplete ? backgroundColor : UIColor.gray
        return cell
    }
    
    
}


// MARK: Calendar Delegate and Datasource

extension TodoViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellIdForCalendar, for: indexPath) as! CustomCalendarCell
        cell.dateLabel.text = cellState.text
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "MM dd yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "04 17 1993")
        let endDate = formatter.date(from: "01 01 2019")
        
        return ConfigurationParameters(startDate: startDate!, endDate: endDate!)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = formatter.string(from: date)
        
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        formatter.dateFormat = "MM dd yyyy"
        let cellDateString = formatter.string(from: cellState.date)
        selectedTodos = [Todo]()
        var i = 0;
        for todo in todos {
            let todoDateString = formatter.string(from: todo.dueDate)
            if todoDateString == cellDateString {
                let index = IndexPath(row: i, section: 0)
                self.collectionView.scrollToItem(at: index, at: .top, animated: true)
                break
            }
            i += 1
        }
        configureCell(cell: cell, cellState: cellState)
        cell?.bounce()
        collectionView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    
}


