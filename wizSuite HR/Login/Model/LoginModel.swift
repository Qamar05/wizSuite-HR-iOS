//
//  LoginModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit

struct LoginModel : Decodable {
    
    let message : String?
    let status : Bool?
    let id : String?
    let token : String?
    let firstName : String?
    let lastName : String?
    let email : String?
    let phone : String?
    let dob : String?
    let location : String?
    let userType : String?
    let designation : String?
    let photo : String?
    let gender : String?
    let loginStatus : String?
    let activeStatus : String?
    
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
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.dob = try container.decodeIfPresent(String.self, forKey: .dob)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.userType = try container.decodeIfPresent(String.self, forKey: .userType)
        self.designation = try container.decodeIfPresent(String.self, forKey: .designation)
        self.photo = try container.decodeIfPresent(String.self, forKey: .photo)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.loginStatus = try container.decodeIfPresent(String.self, forKey: .loginStatus)
        self.activeStatus = try container.decodeIfPresent(String.self, forKey: .activeStatus)
        
    }
}
