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
    var notes: String?
    
    init(title: String,dueDate: Date,notes: String?) {
        self.title = title
        self.dueDate = dueDate
        self.notes = notes
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathComponent("plist")
    
    static func saveTodos(_ todos: [Todo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedTodos = try? propertyListEncoder.encode(todos)
        try? codedTodos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadTodos() -> [Todo]? {
        guard let codedTodos = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Todo>.self, from: codedTodos)
    }
    
    static func loadSampleTodos() -> [Todo] {
        return [
            Todo(title: "Contact Bern",dueDate: Date(), notes: "Talk about programming in Swift"),
            Todo(title: "Research Swift Designs",dueDate: Date(), notes: "Find some inspiration!"),
            Todo(title: "Daily Quote",dueDate: Date(), notes: "I am extraordinarily patient, provided I get my own way in the end.\n -Margaret Thatcher"),
            Todo(title: "Find more projects to do",dueDate: Date(), notes: "I need more iOS projects."),
            Todo(title: "UIStepper Designs",dueDate: Date(), notes: "Look up UIStepper designs to start")
        ]
    }
    
}
