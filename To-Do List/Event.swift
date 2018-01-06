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
        var events = createNormalDailyEvents()
        let daysUntilDue = todo.dueDate.interval(ofComponent: .day, fromDate: Date())
        
        var numOfHoursADay = 0
        
        if daysUntilDue > 7 {
           numOfHoursADay = daysUntilDue/7
        } else {
            numOfHoursADay = daysUntilDue/todo.numOfHoursRequired
        }
        
        // Gather intervals
        var intervals = [Int]()
        for i in 0..<events.count {
            let eventInterval = events[i].endDate.interval(ofComponent: .minute, fromDate: events[i].startDate)
            intervals.append(eventInterval)
        }
        
        // Create events until reach total work time
        var i = 1
        while i < daysUntilDue {
            // Find a start time that is available
            for j in 0..<events.count {
                // Calculate the time the event needs
                let neededInterval = numOfHoursADay * 60
                if neededInterval <= intervals[j] {
                    // Debugging
                    print(neededInterval)
                    let startTime = events[j].endDate
                    events.append(Event(title: todo.title, description: todo.description!, startDate: startTime, endDate: startTime.addingTimeInterval(TimeInterval(neededInterval))))
                }
            }
            i *= numOfHoursADay
        }
        return events
    }
    
    static func createNormalDailyEvents() -> [Event] {
        var events = [Event]()
        
        let calendar = Calendar.current
        
        for i in 0...30 {
            var dateComponents = DateComponents()
            dateComponents.year = calendar.component(.year, from: Date())
            dateComponents.month = calendar.component(.month, from: Date())
            dateComponents.day = calendar.component(.day, from: Date()) + i
            dateComponents.timeZone = TimeZone(abbreviation: "PST")
            dateComponents.hour = 7
            
            let breakfastStartTime = calendar.date(from: dateComponents)!
            
            dateComponents.minute = 45
            let breakfastEndTime = calendar.date(from: dateComponents)!
            
            // Breakfast event
            events.append(Event(title: "Breakfast", description: "Eat a good breakfast", startDate:breakfastStartTime, endDate: breakfastEndTime))
            
            dateComponents.hour = 11
            dateComponents.minute = 30
            let lunchStartTime = calendar.date(from: dateComponents)!
            
            dateComponents.hour = 12
            dateComponents.minute = 30
            let lunchEndTime = calendar.date(from: dateComponents)!
            
            // Lunch event
            events.append(Event(title: "Lunch", description: "Eat your lunch", startDate:lunchStartTime, endDate: lunchEndTime))
            
            dateComponents.hour = 11
            dateComponents.minute = 30
            let dinnerStartTime = calendar.date(from: dateComponents)!
            
            dateComponents.hour = 12
            dateComponents.minute = 30
            let dinnerEndTime = calendar.date(from: dateComponents)!
            
            // Dinner event
            events.append(Event(title: "Dinner", description: "Eat your dinner", startDate:dinnerStartTime, endDate: dinnerEndTime))
        }
        
        return events
    }
    
    
    private static func findOpeningInCalendar(testDate: Date) -> Date {
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
}
