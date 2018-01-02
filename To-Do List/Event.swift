//
//  Event.swift
//  To-Do List
//
//  Created by Devontae Reid on 1/1/18.
//  Copyright © 2018 Devontae Reid. All rights reserved.
//

import UIKit

class Event {
    private var summary: String
    private var startDate: Date
    private var endDate: Date
    
    public init(summary: String, startDate: Date, endDate: Date) {
        self.summary = summary
        self.startDate = startDate
        self.endDate = endDate
    }
    
    public init(title: String,description: String, startDate: Date, endDate: Date) {
        self.summary = title + "\n" + description
        self.startDate = startDate
        self.endDate = endDate
    }
}
