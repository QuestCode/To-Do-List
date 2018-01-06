//
//  Event.swift
//  To-Do List
//
//  Created by Devontae Reid on 1/1/18.
//  Copyright © 2018 Devontae Reid. All rights reserved.
//

import UIKit

class Event: Codable  {
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var isComplete: Bool = false
    
    public init(title: String,description: String, startDate: Date, endDate: Date) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = DocumentsDirectory.appendingPathComponent("events.plist")
    
    static func saveEvents(_ events: [Event]) {
        let propertyListEncoder = PropertyListEncoder()
        do {
            let codedEvents = try? propertyListEncoder.encode(events)
            try codedEvents?.write(to: archiveURL, options: .noFileProtection)
        } catch {
            print("Writing file failed with error : \(error)")
        }
    }
    
    static func loadEvents() -> [Event]? {
        guard let codedEvents = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Event>.self, from: codedEvents)
    }
    
    public static func createEventsForTodo(todo: Todo) -> [Event] {
        var events = [Event]()
        let daysUntilDue = todo.dueDate.interval(ofComponent: .day, fromDate: Date())
        let numOfHoursADay = daysUntilDue/todo.numOfHoursRequired
       
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: Date())
        dateComponents.month = calendar.component(.month, from: Date())
        dateComponents.day = calendar.component(.day, from: Date())
        dateComponents.timeZone = TimeZone(abbreviation: "PST")
        dateComponents.hour = 7
        
        
//        // This is to check the calucation of the muber of hours
//        print(daysUntilDue)
//        print(todo.numOfHoursRequired)
        
        // Create date from components
        if numOfHoursADay >= 2 {
            var i = 1
            while i < daysUntilDue {
                let startTime = findOpeningInCalendar(testDate: calendar.date(from: dateComponents)!)
                dateComponents.hour = dateComponents.hour! + 2
                let endTime = findOpeningInCalendar(testDate: calendar.date(from: dateComponents)!)
                events.append(Event(title: todo.title, description: todo.description!, startDate: startTime, endDate: endTime))
                dateComponents.day = dateComponents.day! + 1
                dateComponents.hour = 7
                i *= numOfHoursADay
            }
        } else {
            let startTime = findOpeningInCalendar(testDate: calendar.date(from: dateComponents)!)
            dateComponents.day = dateComponents.day! + 1
            dateComponents.hour = dateComponents.hour! + 2
            let endTime = findOpeningInCalendar(testDate: calendar.date(from: dateComponents)!)
            events.append(Event(title: todo.title, description: todo.description!, startDate: startTime, endDate: endTime))
        }
        return events
    }
}



private func findOpeningInCalendar(testDate: Date) -> Date {
    // Create date in calendar
    let calendar = Calendar.current
    
    // Components for neccessary date
    var dateComponents = DateComponents()
    dateComponents.year = calendar.component(.year, from: Date())
    dateComponents.month = calendar.component(.month, from: Date())
    dateComponents.day = calendar.component(.day, from: Date())
    dateComponents.timeZone = TimeZone(abbreviation: "PST")
    
    // Formatter to compare dates
    let formatter = DateFormatter()
    
    let testStringDate = formatter.string(from: testDate)
    
    var hour = 7
//    var minute = 0
    dateComponents.hour = hour
//    dateComponents.minute = minute
    var date = calendar.date(from: dateComponents)
    var dateString = formatter.string(from: date!)
    
    // Compare dates to see if the initial date is taken
    if testStringDate == dateString {
        // Find date by hour
        while hour != 23 {
            hour += 1
            dateComponents.hour = hour
            date = calendar.date(from: dateComponents)
            dateString = formatter.string(from: date!)
            break
//            if testStringDate == dateString {
//                // Increment minutes
//                if minute != 30 {
//                    minute += 30
//                }
//            }
            
        }
    }
    return Date()
}
