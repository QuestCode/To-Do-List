//
//  Structs.swift
//  To-Do List
//
//  Created by Devontae Reid on 12/21/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

struct Todo {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static func loadTodos() -> [Todo]? {
        return nil
    }
    
    static func loadSampleTodos() -> [Todo] {
        let todo1 = Todo(title: "Todo One", isComplete: false,
                         dueDate: Date(), notes: "Notes 1")
        let todo2 = Todo(title: "Todo Two", isComplete: false,
                         dueDate: Date(), notes: "Notes 2")
        let todo3 = Todo(title: "Todo Three", isComplete: false,
                         dueDate: Date(), notes: "Notes 3")
        return [todo1, todo2, todo3]
    }
    
}
