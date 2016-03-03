//
//  Dates.swift
//  uchat
//
//  Created by Wojtek Materka on 29/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

extension NSDate {
    
    func yearsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    
}

// MARK: - 🔤↔️📅

private var myDateFormatter : NSDateFormatter {
    let myDateFormatter = NSDateFormatter()
    myDateFormatter.calendar = NSCalendar(calendarIdentifier: "NSCalendarIdentifierISO8601")
    myDateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss xx"
    myDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return myDateFormatter
}

extension NSDate {
    func dateToString() -> String {
        guard let stringFromDate = myDateFormatter.stringFromDate(self) as String? else { fatalError("date must be in the right format") }
        return stringFromDate
    }
}

extension String {
    func stringToDate() -> NSDate {
        guard let dateFromString = myDateFormatter.dateFromString(self) as NSDate? else { fatalError("date string must be in the right format") }
        return dateFromString
        
    }
}