//
//  Structs.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class Todo {
    var title: String
    var isComplete: Bool = false
    var dueDate: Date
    var notes: String?
    
    init(title: String,dueDate: Date,notes: String?) {
        self.title = title
        self.dueDate = dueDate
        self.notes = notes
    }
    
    static func loadTodos() -> [Todo]? {
        return nil
    }
    
    static func loadSampleTodos() -> [Todo] {
        return [
            Todo(title: "Contact Bern",dueDate: Date(), notes: "Talk about programming in Swift"),
            Todo(title: "Research Swift Designs",dueDate: Date(), notes: "Find some inspiration!"),
            Todo(title: "Daily Quote",dueDate: Date(), notes: "I am extraordinarily patient, provided I get my own way in the end.\n -Margaret Thatcher")
        ]
    }
    
}
