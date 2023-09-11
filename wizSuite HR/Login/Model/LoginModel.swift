//
//  LoginModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit

struct LoginModel : Decodable {
    
    let message : String
    let status : Bool
    let id : String
    let token : String
    let firstName : String
    let lastName : String
    let email : String
    let phone : String
    let dob : String
    let location : String
    let userType : String
    let designation : String
    let photo : String
    let gender : String
    let loginStatus : String
    let activeStatus : String
    
    enum CodingKeys: String, CodingKey{
        
        case message = "message"
        case status = "status"
        case id = "id"
        case token = "token"
        case firstName = "Firstname"
        case lastName = "Lastname"
        case email = "Email"
        case phone = "Phone"
        case dob = "DOB"
        case location = "Location"
        case userType = "User_type"
        case designation = "Designation"
        case photo = "Photo"
        case gender = "gender"
        case loginStatus = "login_status"
        case activeStatus = "activestatus"
        
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.status = try container.decode(Bool.self, forKey: .status)
        self.id = try container.decode(String.self, forKey: .id)
        self.token = try container.decode(String.self, forKey: .token)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.dob = try container.decode(String.self, forKey: .dob)
        self.location = try container.decode(String.self, forKey: .location)
        self.userType = try container.decode(String.self, forKey: .userType)
        self.designation = try container.decode(String.self, forKey: .designation)
        self.photo = try container.decode(String.self, forKey: .photo)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.loginStatus = try container.decode(String.self, forKey: .loginStatus)
        self.activeStatus = try container.decode(String.self, forKey: .activeStatus)
        
    }
}



//    "message": "Login Successful.",
//        "status": true,
//        "id": "61",
//        "token": "9100d045a2823f88c32d20211d3ad048",
//        "Firstname": "Qamar",
//        "Lastname": "abbas",
//        "Email": "qamar@vmstechs.com",
//        "Phone": "9910985450",
//        "DOB": "1993-06-20",
//        "Location": "DELHI",
//        "User_type": "Regular",
//        "Designation": "Android Developer",
//        "Photo": "https://fmcg.xaapps.com/images/844967-profile.jpg",
//        "gender": "Male",
//        "login_status": "True",
//        "activestatus": "Active"
//    }
