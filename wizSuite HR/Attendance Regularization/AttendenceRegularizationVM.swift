//
//  AttendenceRegularizationVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 15/09/23.
//

import UIKit

typealias attendanceCompletionHandler = (_ data: AttendenceRegularizationModel?,_ error: Error?) -> Void

class AttendenceRegularizationVM: NSObject {
    
    var model: AttendenceRegularizationModel?
    var daysModel: AttendenceRegulariseDayCount?

    
//    {
//    "token":"1583cce1f7928a3ebedd1e0c98e515cb",
//    "forgot_type":"Both",
//    "forgot_comments":"Kapil Marriage",
//    "forgot_out_date":"2023-06-11",
//    "forgot_in_date":"2023-06-11",
//    "forgot_check_in_time":"9:44",
//    "forgot_check_out_time":"19:30"
//    }
    
    
    func fetchAttendenceRegularizationData(body: [String: Any], completionHandler: @escaping attendanceCompletionHandler ) {
        
        let body = body
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.attendanceRegularisationUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let attendanceData = try? JSONDecoder().decode(AttendenceRegularizationModel.self, from: data) {
                    
                    print("Attendance Regularization Data***",attendanceData)
                    
                    self.model = attendanceData
                    
                    completionHandler(self.model, nil)
                    
                } else {
                    completionHandler(nil, nil)
                    
                    print("Invalid Response")
                }
                // Handle HTTP request response
            } else {
                completionHandler(nil, nil)
                
                // Handle unexpected error
            }
        }
        task.resume()
    }
    
    
    
    
    func fetchDayCount(completionHandler: @escaping (_ data: AttendenceRegulariseDayCount?,_ error: Error?) -> Void){
        
        let token = GenericMethods.getToken()
        let body = ["token": token]
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.regulariseDayCountUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil,error)
                // Handle HTTP request error
            } else if let data = data {
                
                if let attendanceData = try? JSONDecoder().decode(AttendenceRegulariseDayCount.self, from: data) {
                    
                    print("Attendance Days Count***",attendanceData)
                    self.daysModel = attendanceData
                    completionHandler(self.daysModel, nil)
                    
                } else {
                    completionHandler(nil, nil)
                    print("Invalid Response")
                }
                // Handle HTTP request response
            } else {
                completionHandler(nil, nil)
                
                // Handle unexpected error
            }
        }
        task.resume()
    }
            
    }
    
