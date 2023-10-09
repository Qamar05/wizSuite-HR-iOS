//
//  MainViewModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit


struct CheckInModel: Decodable {
    
    let message : String?
    let status : Bool?
//    let distance: String?
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
        case status = "status"
      //  case distance = "distance"
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
       // self.distance = try container.decodeIfPresent(String.self, forKey: .distance)
    }
    
    
}

struct CheckOutModel: Decodable {
    
    let message : String?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
    }
    
}


//{
//    "hours": "1:9",
//    "status": true
//}
struct TodayWorkingHoursModel: Decodable{
    
    let todayHours : String?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey{
        case todayHours = "hours"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.todayHours = try container.decodeIfPresent(String.self, forKey: .todayHours)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
    }
    
}

struct AttendenceUserWorkingHoursModel : Decodable {
    
    let todayHour : String?
    let weekHour : String?
    let monthHour : String?
    let totalHour : String?
    let status : Bool?
    
    
    enum CodingKeys: String, CodingKey{
        case todayHour = "today Hour"
        case weekHour = "Week Hour"
        case monthHour = "Month Hour"
        case totalHour = "Total_Hour"
        case status =    "status"
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.todayHour = try container.decodeIfPresent(String.self, forKey: .todayHour)
        self.weekHour = try container.decodeIfPresent(String.self, forKey: .weekHour)
        self.monthHour = try container.decodeIfPresent(String.self, forKey: .monthHour)
        self.totalHour = try container.decodeIfPresent(String.self, forKey: .totalHour)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
        
    }
    
}
    


