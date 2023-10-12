//
//  HolidayModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 13/09/23.
//

import UIKit

struct HolidayModel : Decodable {
    
    let message : String
    let status : Bool
    let data: [HolidayData]
    
    enum CodingKeys: String, CodingKey{
        
        case message = "message"
        case status = "status"
        case data = "data"
        
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.status = try container.decode(Bool.self, forKey: .status)
        self.data = try container.decode(Array.self, forKey: .data)
    }
        
}


struct HolidayData: Decodable{
    
    let id : String
    let holidayName : String
    let holidayDate:String
    let holidayDay:String
    let status: String
    
    enum CodingKeys: String, CodingKey{
        
        case id = "id"
        case holidayName = "holiday_name"
        case holidayDate = "holiday_date"
        case holidayDay = "holiday_day"
        case status = "status"
     
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.holidayName = try container.decode(String.self, forKey: .holidayName)
        self.holidayDate = try container.decode(String.self, forKey: .holidayDate)
        self.holidayDay = try container.decode(String.self, forKey: .holidayDay)
        self.status = try container.decode(String.self, forKey: .status)

    }
    
    
}

    
