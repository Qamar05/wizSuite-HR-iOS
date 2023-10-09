//
//  AttendenceRegularizationModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 18/09/23.
//

import UIKit




struct AttendanceModel : Decodable {
    
    let message : String
    let status : Bool
    let data: [AttendanceMonthDetailModel]
    
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


struct AttendanceMonthDetailModel : Decodable {
    
    let attendenceDate : String?
    let timeIn : String?
    let timeOut : String?
    let commentIn : String?
    let commentOut : String?
    let totalHour : String?
    let checkinStatus : String?
    let createuserId : String?
    let approvedBy : String?
    
    
    enum CodingKeys: String, CodingKey{
        case attendenceDate = "attendence_date"
        case timeIn = "time_in"
        case timeOut = "time_out"
        case commentIn = "comment_in"
        case commentOut = "comment_out"
        case totalHour = "total_hour"
        case checkinStatus = "checkin_status"
        case createuserId = "createuser_id"
        case approvedBy = "approved_by"
        
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attendenceDate = try container.decodeIfPresent(String.self, forKey: .attendenceDate)
        self.timeIn = try container.decodeIfPresent(String.self, forKey: .timeIn)
        self.timeOut = try container.decodeIfPresent(String.self, forKey: .timeOut)
        self.commentIn = try container.decodeIfPresent(String.self, forKey: .commentIn)
        self.commentOut = try container.decodeIfPresent(String.self, forKey: .commentOut)
        self.totalHour = try container.decodeIfPresent(String.self, forKey: .totalHour)
        self.checkinStatus = try container.decodeIfPresent(String.self, forKey: .checkinStatus)
        self.createuserId = try container.decodeIfPresent(String.self, forKey: .createuserId)
        self.approvedBy = try container.decodeIfPresent(String.self, forKey: .approvedBy)
        
        
    }
    
}
