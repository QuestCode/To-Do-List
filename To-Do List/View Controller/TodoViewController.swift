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
    var events = [Event]()
    var selectedTodos = [Todo]()
    var eventsDict = [String:String]()
    var numOfTaskDone = 0
    
    var collectionView: UICollectionView!
    
    let backgroundColor = UIColor(rgb: 0x317FE0)
    let insideTextColor = UIColor.white
    let outsideTextColor = UIColor(rgb: 0x739FD6)
    let selectedTextColor = UIColor(rgb: 0x65A0E9)
    
    
    var calendarView: JTAppleCalendarView!
    let cellIdForCalendar = "id"
    let formatter = DateFormatter()
    
    var monthYearView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let monthYearLabel:  UILabel = {
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
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 140, height: view.frame.height))
        titleLabel.text = "Calendar Events"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 25)
        navigationItem.titleView = titleLabel
        
        
        // This is to customize the navigation bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addNewTodo(_:)))
        self.view.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        
//        if let savedEvents = Event.loadEvents() {
//            events = savedEvents
//            print(events)
//        } else {
            if let savedTodos = Todo.loadTodos() {
                todos = savedTodos
                todos.sort{ $0.dueDate < $1.dueDate }
                createEventsFrom(todos: todos)
//                print(events)
            } else {
                todos = Todo.loadSampleTodos()
                todos.sort{ $0.dueDate < $1.dueDate }
                createEventsFrom(todos: todos)
            }
//        }
        
        for i in 0..<events.count {
            if events[i].title == "Baby Shower" {
                print(i)
            }
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
        layout.itemSize = CGSize(width: view.frame.width - 30, height: 80)
        
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
        
        // This is used to labels to present the months and year
        self.calendarView.visibleDates() { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            self.formatter.dateFormat = "MMMM yyyy"
            self.monthYearLabel.text = self.formatter.string(from: date)
            
        }
        
        setupDaysView()
        formatTodosDict()
        
        self.view.addContraintsWithFormat(format: "H:|-30-[v0]-30-|", views: calendarView)
        self.view.addContraintsWithFormat(format: "V:|-40-[v0]-15-[v1]-10-[v2(240)][v3]|", views: monthYearView,dayView,calendarView,collectionView)
        self.view.addContraintsWithFormat(format: "H:|-30-[v0]-30-|", views: dayView)
        self.view.addContraintsWithFormat(format: "H:|-30-[v0]-30-|", views: monthYearView)
        
        self.view.addContraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        
        
    }
    
    
    
    private func setupDaysView() {
        self.view.addSubview(dayView)
        self.view.addSubview(monthYearView)
        
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
        
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.tintColor = .white
        backButton.setImage(UIImage(named: "back_arrow")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        backButton.addTarget(self, action: #selector(previousMonth(_:)), for: .touchUpInside)
        monthYearView.addSubview(backButton)
        
        let nextButton = UIButton()
        nextButton.tintColor = .white
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(UIImage(named: "forward_arrow")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        nextButton.addTarget(self, action: #selector(nextMonth(_:)), for: .touchUpInside)
        monthYearView.addSubview(nextButton)
        monthYearView.addSubview(monthYearLabel)
        
        monthYearView.addContraintsWithFormat(format: "H:|-30-[v0(30)]-5-[v1]-5-[v2]-30-|", views: backButton,monthYearLabel,nextButton)
        monthYearView.addContraintsWithFormat(format: "V:|[v0]|", views: backButton)
        monthYearView.addContraintsWithFormat(format: "V:|[v0]|", views: monthYearLabel)
        monthYearView.addContraintsWithFormat(format: "V:|[v0]|", views: nextButton)
        
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
        cell.eventDotView.isHidden = !eventsDict.contains { $0.key == formatter.string(from: cellState.date) }
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
    
    @objc func previousMonth(_: UIButton) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    @objc func nextMonth(_: UIButton) {
        self.calendarView.scrollToSegment(.next)
    }
    
    func formatTodosDict() {
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            let eventObjects = self.createEventsDict()
            for (date, event) in eventObjects {
                let stringDate = self.formatter.string(from: date)
                self.eventsDict[stringDate] = event
            }
        }
        
        DispatchQueue.main.async {
            self.calendarView.reloadData()
        }
    }
    
    func createEventsDict() -> [Date:String] {
        self.formatter.dateFormat = "MM dd yyyy"
        var dict = [Date:String]()
        
        for event in events {
            dict[event.startDate] =  event.title
        }
        return dict
    }
    
}

// MARK: Edit and Add Protocols

extension TodoViewController: NewTodoTableViewControllerProtocol, EditTodoTableViewControllerProtocol, TodoCollectionViewCellProtocol {
    func deleteTodo(sender: TodoCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: sender) {
            events.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            updateTaskCount()
            Todo.saveTodos(todos)
            Event.saveEvents(events)
            collectionView.reloadData()
        }
    }
    
    @objc func completeTodo(sender: TodoCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: sender) {
            let event = events[indexPath.row]
            event.isComplete = !event.isComplete
            events[indexPath.row] = event
            collectionView.reloadItems(at: [indexPath])
            collectionView.reloadData()
        }
        updateTaskCount()
        Todo.saveTodos(todos)
        Event.saveEvents(events)
        collectionView.reloadData()
    }
    
    func editTodo(todo: Todo) {
        
    }
    
    func addTodo(todo: Todo) {
        self.todos.append(todo)
        createEventsFrom(todos: self.todos)
        Todo.saveTodos(todos)
        Event.saveEvents(events)
        collectionView.reloadData()
    }
    
    func createEventsFrom(todos: [Todo]) {
        if todos.count == 0 {
            self.events = Event.createNormalDailyEvents()
        } else {
            for todo in todos {
                self.events = Event.createEventsForTodo(todo: todo)
            }
        }
        Event.saveEvents(self.events)
    }
}

extension TodoViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
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
        
        let event = events[indexPath.row]
        
        cell.titleLabel.text = event.title
        cell.notesLabel.text = event.description
        cell.startTimeLabel.text = formatter.string(from: event.startDate)
        cell.endTimeLabel.text = formatter.string(from: event.endDate)
        cell.checkBtn.tintColor = event.isComplete ? backgroundColor : UIColor.gray
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
        
        self.formatter.dateFormat = "MMMM yyyy"
        self.monthYearLabel.text = formatter.string(from: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        formatter.dateFormat = "MM dd yyyy"
        let cellDateString = formatter.string(from: cellState.date)
        selectedTodos = [Todo]()
        var i = 0;
        for event in events {
            let todoDateString = formatter.string(from: event.startDate)
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


