//
//  ForgotPasswordModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 12/09/23.
//

import UIKit

struct ForgotPwModel : Decodable {
    
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

//Response
//{
//    "message": "Password Updated.",
//    "status": true
//}
