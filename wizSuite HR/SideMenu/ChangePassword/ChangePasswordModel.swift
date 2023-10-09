//
//  ChangePasswordModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 25/09/23.
//

import UIKit


struct ChangePasswordModel : Decodable {
    
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
