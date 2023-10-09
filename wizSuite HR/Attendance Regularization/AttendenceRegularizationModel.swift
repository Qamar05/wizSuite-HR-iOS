//
//  AttendenceRegularizationModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 15/09/23.
//

import UIKit

struct AttendenceRegularizationModel : Decodable {
    
    let message : String
    let status : Bool
    
    enum CodingKeys: String, CodingKey{
        
        case message = "message"
        case status = "status"
        
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.status = try container.decode(Bool.self, forKey: .status)
    }
}


//{
//    "regulation count": "2",
//    "status": true
//}

struct AttendenceRegulariseDayCount : Decodable {
    
    let regulationCount : String
    let status : Bool
    
    enum CodingKeys: String, CodingKey{
        
        case regulationCount = "regulation count"
        case status = "status"
        
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.regulationCount = try container.decode(String.self, forKey: .regulationCount)
        self.status = try container.decode(Bool.self, forKey: .status)
    }
}


