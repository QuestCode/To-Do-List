//
//  Structs.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class Todo: Codable {
    var title: String
    var isComplete: Bool = false
    var dueDate: Date
    var numOfHoursRequired: Int
    var description: String?
    
    init(title: String,dueDate: Date,numOfHoursRequired: Int,description: String?) {
        self.title = title
        self.dueDate = dueDate
        self.numOfHoursRequired = numOfHoursRequired
        self.description = description
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = DocumentsDirectory.appendingPathComponent("todos.plist")
    
    static func saveTodos(_ todos: [Todo]) {
        let propertyListEncoder = PropertyListEncoder()
        do {
            let codedTodos = try? propertyListEncoder.encode(todos)
            try codedTodos?.write(to: archiveURL, options: .noFileProtection)
        } catch {
            print("Writing file failed with error : \(error)")
        }
    }
    
    static func loadTodos() -> [Todo]? {
        guard let codedTodos = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Todo>.self, from: codedTodos)
    }
    
    static func loadSampleTodos() -> [Todo] {
        return [
            Todo(title: "Contact Bern",dueDate: Date(),numOfHoursRequired: 8, description: "Talk about programming in Swift"),
            Todo(title: "Research Swift Designs",dueDate: Date(),numOfHoursRequired: 5, description: "Find some inspiration!"),
            Todo(title: "Daily Quote",dueDate: Date(),numOfHoursRequired: 10, description: "I am extraordinarily patient, provided I get my own way in the end.\n -Margaret Thatcher"),
            Todo(title: "Find more projects to do",dueDate: Date(),numOfHoursRequired: 2, description: "I need more iOS projects."),
            Todo(title: "UIStepper Designs",dueDate: Date(),numOfHoursRequired: 4, description: "Look up UIStepper designs to start")
        ]
    }
    
}
