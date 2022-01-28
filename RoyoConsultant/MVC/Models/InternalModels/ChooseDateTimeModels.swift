//
//  ChooseDateTimeModels.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 10/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class DateModel {
    var date: Date?
    var isSelected: Bool = false
    
    
    init(_ _date: Date?) {
        date = _date
    }
    
    class func getDates() -> [DateModel] {
        var dates = [DateModel]()
        let datesArray = Date.dates(from: Date(), to: Date().dateByAddingDays(100))
        datesArray.forEach({dates.append(DateModel.init($0))})
        dates.first?.isSelected = true
        return dates
    }
}

class SelectedDateTime {
    var selectedDate: Date?
    var selectedTime: String?
    var datesArray: [DateModel]?
    var intervalsArray: [Interval]?
    
    init(_ _date: Date?, _ _time: String?, _ _dates: [DateModel]?, _ _intervals: [Interval]?) {
        selectedDate = _date
        selectedTime = _time
        datesArray = _dates
        intervalsArray = _intervals
    }
}
