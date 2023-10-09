//
//  SupportModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 22/09/23.
//

import UIKit


//{
//    "message": "Successfully Inserted",
//    "status": "Success",
//    "data": {
//        "status": "success",
//        "error": false,
//        "message": "File uploaded successfully",
//        "url": "http://fmcg.xaapps.com/images/749515-Screenshot-2023-09-04-at-4.54.32-PM.png"
//    }
//}


struct SupportModel : Decodable {
    
    let message : String?
    let status :String?
    let data: [SupportDataModel]?
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
        case status = "status"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.data = try container.decodeIfPresent(Array.self, forKey: .data)
        
    }
    
}

struct SupportDataModel : Decodable {
    
    let status : String?
    let error :Bool?
    let message: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey{
        case status = "status"
        case error = "error"
        case message = "message"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.error = try container.decodeIfPresent(Bool.self, forKey: .error)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        
    }
    
}




