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
            Todo(title: "Todo One",dueDate: Date(), notes: "Notes 1"),
            Todo(title: "Todo Two",dueDate: Date(), notes: "Notes 2"),
            Todo(title: "Todo Three",dueDate: Date(), notes: "Notes 3")
        ]
    }
    
}
