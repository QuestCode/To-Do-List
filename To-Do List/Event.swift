//
//  Event.swift
//  To-Do List
//
//  Created by Devontae Reid on 1/1/18.
//  Copyright © 2018 Devontae Reid. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Event {
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var isComplete: Bool = false
    var regularEvent:Bool = false
    
    init(title: String,description: String, startDate: Date, endDate: Date) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(document: DocumentSnapshot) {
        let title = document.data()["title"] as? String
        let description = document.data()["description"] as? String
        let startDate = document.data()["startDate"] as? Date
        let endDate = document.data()["endDate"] as? Date
        
        self.title = title!
        self.description = description!
        self.startDate = startDate!
        self.endDate = endDate!
        
    }
    
    
    static func saveEvents(_ events: [Event]) {
        let db = Firestore.firestore()
        for event in events {
            
            let dict: [String: Any] = ["title":event.title,
                                       "startDate":event.startDate,
                                       "endDate":event.endDate,
                                       "description":event.description]
            db.collection("events").addDocument(data: dict)
        }
    }
    
    static func loadEvents() -> [Event]? {
        let events = [Event]()
        let db = Firestore.firestore()
        db.collection("events").order(by: "due_date", descending: false).getDocuments { (response, error) in
            if let error = error {
                print(error)
            } else {
                for document in (response?.documents)! {
                    let event = Event(document: document)
                }
            }
        }
        return events
    }
    
    public static func createEventsForTodo(todo: Todo,events: [Event]) -> [Event] {
        var sampleEvents = [Event]()
        if events.count == 0 {
            sampleEvents = createNormalDailyEvents()
        } else {
            sampleEvents = events
        }
        
        sampleEvents.sort{ $0.startDate < $1.startDate }
        
        let daysUntilDue = todo.dueDate.interval(ofComponent: .day, fromDate: Date())
        
        var numOfHoursADay = daysUntilDue/todo.numOfHoursRequired
        
        if numOfHoursADay >= 2 {
           numOfHoursADay = 2
        }
        
        // Gather intervals
        var intervals = [Int]()
        for i in 1..<sampleEvents.count {
            let eventInterval = sampleEvents[i].startDate.interval(ofComponent: .minute, fromDate: sampleEvents[i-1].endDate)
//            print("\(i) : \(eventInterval)")
            intervals.append(eventInterval)
        }
        
        
        // Create events until reach total work time
        var i = 1
        var day = 0
        while i < todo.numOfHoursRequired {
            let calendar = Calendar.current
            // Find a start time that is available
            for j in 0..<intervals.count {
                // Calculate the time the event needs
                let neededInterval = numOfHoursADay * 60
                let interval = intervals[j]
                if neededInterval <= interval {
                    var startTime = sampleEvents[j].endDate
                    var dateComponents = DateComponents()
                    dateComponents.year = calendar.component(.year, from: startTime)
                    dateComponents.month = calendar.component(.month, from: startTime)
                    dateComponents.day = calendar.component(.day, from: startTime) + day
                    dateComponents.hour = calendar.component(.hour, from: startTime)
                    dateComponents.minute = calendar.component(.minute, from: startTime)
                    dateComponents.timeZone = TimeZone(abbreviation: "PST")
                    startTime = calendar.date(from: dateComponents)!
//                    print(startTime)
                    let event = Event(title: todo.title, description: todo.description!, startDate: startTime, endDate: startTime.addingTimeInterval(TimeInterval(neededInterval*60)))
                    sampleEvents.append(event)
                    break
                }
            }
            i *= numOfHoursADay
            day += 1
        }
        return sampleEvents
    }
    
    static func createNormalDailyEvents() -> [Event] {
        var events = [Event]()
        
        let calendar = Calendar.current
        
        for i in 0..<15 {
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
            let breakfast = Event(title: "Breakfast", description: "Eat a good breakfast", startDate:breakfastStartTime, endDate: breakfastEndTime)
            breakfast.regularEvent = true
            events.append(breakfast)
            
            dateComponents.hour = 11
            dateComponents.minute = 30
            let lunchStartTime = calendar.date(from: dateComponents)!
            
            dateComponents.hour = 12
            dateComponents.minute = 30
            let lunchEndTime = calendar.date(from: dateComponents)!
            
            // Lunch event
            let lunch = Event(title: "Lunch", description: "Eat your lunch", startDate:lunchStartTime, endDate: lunchEndTime)
            lunch.regularEvent = true
            events.append(lunch)
            
            dateComponents.hour = 18
            dateComponents.minute = 30
            let dinnerStartTime = calendar.date(from: dateComponents)!
            
            dateComponents.hour = 19
            dateComponents.minute = 30
            let dinnerEndTime = calendar.date(from: dateComponents)!
            
            // Dinner event
            let dinner = Event(title: "Dinner", description: "Eat your dinner", startDate:dinnerStartTime, endDate: dinnerEndTime)
            dinner.regularEvent = true
            events.append(dinner)
        }
        
        events.sort{ $0.startDate < $1.startDate }
        
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
