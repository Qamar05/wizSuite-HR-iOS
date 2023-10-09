//
//  MyBirthdayModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import Foundation


//"message": "Record Found.",
//    "status": true,
//    "data": [
//        {
//            "firstname": "Bhudev Hariom",
//            "lastname": "Gupta",
//            "dob": "2023-09-07",
//            "designation": "Game Developer",
//            "photo": "https://fmcg.xaapps.com/images/hela.jpg"
//        },
        
struct BirthdayListModel : Decodable {
    
    let message : String?
    let status : Bool?
    let data: [BirthdayData]?
    
    enum CodingKeys: String, CodingKey{
        
        case message = "message"
        case status = "status"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
        self.data = try container.decodeIfPresent(Array.self, forKey: .data)
    }
        
}


struct BirthdayData: Decodable{
    
    let firstname : String?
    let lastname : String?
    let dob: String?
    let designation: String?
    let photo: String?
    
    enum CodingKeys: String, CodingKey{
        
        case firstname = "firstname"
        case lastname = "lastname"
        case dob = "dob"
        case designation = "designation"
        case photo = "photo"
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
        self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
        self.dob = try container.decodeIfPresent(String.self, forKey: .dob)
        self.designation = try container.decodeIfPresent(String.self, forKey: .designation)
        self.photo = try container.decodeIfPresent(String.self, forKey: .photo)
        
    }
    
    
}

    

