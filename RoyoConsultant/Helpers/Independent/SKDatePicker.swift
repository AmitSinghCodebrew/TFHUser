//
//  SKDatePicker.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SKDatePicker: UIDatePicker {
    
    typealias DidSelectDate = (_ item: Date) -> ()
    
    var didSelectDate: DidSelectDate?
    
    init(frame: CGRect, mode: UIDatePicker.Mode = .date, maxDate: Date?, minDate: Date?,interval: Int? = nil, configureDate: @escaping DidSelectDate) {
        super.init(frame: frame)
        self.datePickerMode = mode
        self.maximumDate = maxDate
        self.minimumDate = minDate
        self.addTarget(self, action: #selector(dateSlected(sender:)), for: .valueChanged)
        if let intervalInMinutes = interval {
            self.minuteInterval = intervalInMinutes
        }
        self.didSelectDate = configureDate
        if #available(iOS 13.4, *) {
            self.preferredDatePickerStyle = .wheels
        } 
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func dateSlected(sender: UIDatePicker) {
        if let block = didSelectDate {
            block(sender.date)
        }
    }
}
