//
//  LeavesModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 13/09/23.
//

import UIKit


struct LeavesHistoryModel : Decodable {
    
    let message : String?
    let status : Bool?
    let maritalStatus : String?
    let approvedLeave : String?
    let pendingLeave : String?
    let remaining : [LeaveBalanceModel]?
    var data: [LeavesAppliedModel]?
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
        case status = "status"
        case maritalStatus = "marital_status"
        case approvedLeave = "Approved_Leave"
        case pendingLeave = "Pending_Leave"
        case remaining = "remaining"
        case data = "data"

    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
        self.maritalStatus = try container.decodeIfPresent(String.self, forKey: .maritalStatus)
        self.approvedLeave = try container.decodeIfPresent(String.self, forKey: .approvedLeave)
        self.pendingLeave = try container.decodeIfPresent(String.self, forKey: .pendingLeave)
        self.remaining = try container.decodeIfPresent(Array.self, forKey: .remaining)
        self.data = try container.decodeIfPresent(Array.self, forKey: .data)
    }
}

struct LeaveBalanceModel: Decodable{
    
    let id : String?
    let leaveName : String?
    let leaveDays : String?
    let remainingDays : String?
    let paymentType : String?
    let leaveStatus : String?
    
    enum CodingKeys: String, CodingKey{
        
        case id = "id"
        case leaveName = "leave_name"
        case leaveDays = "leave_days"
        case remainingDays = "remaining_days"
        case paymentType = "payment_type"
        case leaveStatus = "leave_status"
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.leaveName = try container.decodeIfPresent(String.self, forKey: .leaveName)
        self.leaveDays = try container.decodeIfPresent(String.self, forKey: .leaveDays)
        self.remainingDays = try container.decodeIfPresent(String.self, forKey: .remainingDays)
        self.paymentType = try container.decodeIfPresent(String.self, forKey: .paymentType)
        self.leaveStatus = try container.decodeIfPresent(String.self, forKey: .leaveStatus)
    }
}

struct LeavesAppliedModel : Decodable {
    
    let leaveId : String?
    let leaveType : String?
    let dateFrom : String?
    let dateTo: String?
    let daysCount : String?
    let reason : String?
    let leaveStatus : String?
    let employeeType : String?
    let StatusChangeBy: String?
    let createdAt: String?
    let userId: String?


    enum CodingKeys: String, CodingKey{
        
        case leaveId = "id"
        case leaveType = "leave_type"
        case dateFrom = "date_from"
        case dateTo = "date_to"
        case daysCount = "days_count"
        case reason = "reason"
        case leaveStatus = "leavestatus"
        case employeeType = "employee_type"
        case StatusChangeBy = "StatusChange_by"
        case createdAt = "created_at"
        case userId = "userid"
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.leaveId = try container.decodeIfPresent(String.self, forKey: .leaveId)
        self.leaveType = try container.decodeIfPresent(String.self, forKey: .leaveType)
        self.dateFrom = try container.decodeIfPresent(String.self, forKey: .dateFrom)
        self.dateTo = try container.decodeIfPresent(String.self, forKey: .dateTo)
        self.daysCount = try container.decodeIfPresent(String.self, forKey: .daysCount)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.leaveStatus = try container.decodeIfPresent(String.self, forKey: .leaveStatus)
        self.employeeType = try container.decodeIfPresent(String.self, forKey: .employeeType)
        self.StatusChangeBy = try container.decodeIfPresent(String.self, forKey: .StatusChangeBy)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)


        
    }
}


struct LeavesCancelModel : Decodable {
    
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
