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

    


/*
 
 
 {
     "message": "Record Found.",
     "status": true,
     "data": [
         {
             "id": "1",
             "holiday_name": "Republic Day",
             "holiday_date": "2023-01-26",
             "holiday_day": "Thursday",
             "status": "All"
         },
         {
             "id": "2",
             "holiday_name": "Holi",
             "holiday_date": "2023-03-08",
             "holiday_day": "Wednesday",
             "status": "All"
         },
         {
             "id": "3",
             "holiday_name": "Good Friday",
             "holiday_date": "2023-04-07",
             "holiday_day": "Friday",
             "status": "vms"
         },
         {
             "id": "4",
             "holiday_name": "Independence Day",
             "holiday_date": "2023-08-15",
             "holiday_day": "Tuesday",
             "status": "All"
         },
         {
             "id": "5",
             "holiday_name": "Raksha Bandhan",
             "holiday_date": "2023-08-31",
             "holiday_day": "Thursday",
             "status": "All"
         },
         {
             "id": "13",
             "holiday_name": "Mahatma Gandhi Jayanti",
             "holiday_date": "2023-10-02",
             "holiday_day": "Monday",
             "status": "All"
         },
         {
             "id": "7",
             "holiday_name": "Deussehra",
             "holiday_date": "2023-10-24",
             "holiday_day": "Tuesday",
             "status": "All"
         },
         {
             "id": "8",
             "holiday_name": "Govardhan Puja",
             "holiday_date": "2023-11-13",
             "holiday_day": "Monday",
             "status": "All"
         },
         {
             "id": "9",
             "holiday_name": "Bhai Dooj ",
             "holiday_date": "2023-11-15",
             "holiday_day": "Wednesday",
             "status": "All"
         },
         {
             "id": "10",
             "holiday_name": "Christmas",
             "holiday_date": "2023-12-25",
             "holiday_day": "Monday",
             "status": "All"
         }
     ]
 }
 
 
 
 */
