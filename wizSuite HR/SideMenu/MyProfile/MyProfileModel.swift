//
//  MyProfileModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit

struct MyProfileModel : Decodable {
    
    let firstname : String?
    let lastname :String?
    let designation: String?
    let phone: String?
    let email: String?
    let location: String?
    let bloodGroup: String?
    let dob: String?
    let photo: String?
    let status: Bool?
    
    enum CodingKeys: String, CodingKey{
        
        case firstname = "firstname"
        case lastname = "lastname"
        case designation = "designation"
        case phone = "phone"
        case email = "email"
        case location = "location"
        case bloodGroup = "blood Group"
        case dob = "dob"
        case photo =  "photo"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
        self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
        self.designation = try container.decodeIfPresent(String.self, forKey: .designation)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.bloodGroup = try container.decodeIfPresent(String.self, forKey: .bloodGroup)
        self.dob = try container.decodeIfPresent(String.self, forKey: .dob)
        self.photo = try container.decodeIfPresent(String.self, forKey: .photo)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
        
    }
    
}




//{
//    "message": "Photo Successfully Updated.",
//    "data": {
//        "status": "success",
//        "error": false,
//        "message": "File uploaded successfully",
//        "url": "https://fmcg.xaapps.com/images/720949-Screenshot-2023-09-04-at-4.54.32-PM.png"
//    }
//}


//"status": "success",
//       "error": false,
//       "message": "File uploaded successfully",
//       "url": "https://fmcg.xaapps.com/images/720949-Screenshot-2023-09-04-at-4.54.32-PM.png"




//struct PhotoUploadModel : Decodable {
//
//    let message : String?
//    let metadata: [String: Any]?
//
////    let data :[String: PhotoModel]?
//
//    enum CodingKeys: String, CodingKey{
//        case message = "message"
//        case data = "data"
//    }
//
//    init(from decoder: Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.message = try container.decodeIfPresent(String.self, forKey: .message)
//        self.metadata = try container.decodeIfPresent(PhotoModel.self, forKey: .data)
//    }
//
//
//}
//
//
//struct PhotoModel: Codable {
//    
//    let status: String?
//    let error: String?
//    let message: String?
//    let url: String?
//    
//    enum CodingKeys: String, CodingKey{
//        case status = "status"
//        case error = "error"
//        case message = "message"
//        case url = "url"
//    }
//    
//    init(from decoder: Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.status = try container.decodeIfPresent(String.self, forKey: .message)
//        self.error = try container.decodeIfPresent(String.self, forKey: .error)
//        self.message = try container.decodeIfPresent(String.self, forKey: .message)
//        self.url = try container.decodeIfPresent(String.self, forKey: .url)
//        
//    }
//    
//}
//
