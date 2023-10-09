//
//  AttendanceRegularisationVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 18/09/23.
//

import UIKit


class AttendanceDetailsVM {
    
    var model: AttendanceModel?
    
    
    func fetchAttendanceDetails(body: [String: Any], completionHandler: @escaping (_ data: AttendanceModel?,_ error: Error?) -> Void ) {
        
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.getUserMonthDetailUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //          request.setValue(GenericMethods.getToken(), forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil,error)
                // Handle HTTP request error
            } else if let data = data {
                
                if let attendanceDate = try? JSONDecoder().decode(AttendanceModel.self, from: data) {
                    print(attendanceDate)
                    self.model = attendanceDate
                    completionHandler(attendanceDate, nil)
                    
                } else {
                    completionHandler(nil, nil)
                    print("Invalid Response")
                }
                // Handle HTTP request response
            } else {
                completionHandler(nil, nil)
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}





