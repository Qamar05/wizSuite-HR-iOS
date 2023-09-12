//
//  GenericMethods.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit

class GenericMethods {
    
    @objc static func getToken() -> String{
        let token = "416A471A1A729D6D6E254C7528163"
        return token
    }

}

extension Date {
    
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd - MM - yyyy"
        return dateFormatter.string(from: Date())
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func hour() -> String
    {
        
        let hour = Calendar.current.component(.hour, from: Date())
        return String(hour)
        
    }
    
    
    func minute() -> String
    {
        let mins = Calendar.current.component(.minute, from: Date())
        return String(mins)
    }
    
    
}

