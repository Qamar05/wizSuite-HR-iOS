//
//  HolidayListVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 13/09/23.
//

import UIKit

//HolidayListVM

typealias completionHandler1 = (_ data: HolidayModel?,_ error: Error?) -> Void

class HolidayListVM {
    
    var model: HolidayModel?
        
    func fetchHolidayData(completionHandler: @escaping completionHandler1 ) {
        
        let token = GenericMethods.getToken()
        print("TOKEN*****",token)
        let attendanceDate = GenericMethods.getCurrentAttendanceDate()
        print("attendanceDate*****",attendanceDate)
        
        
        let body = ["token": token,"attendence_date": attendanceDate]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.holidayListUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //  request.setValue(GenericMethods.getToken(), forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let holidayData = try? JSONDecoder().decode(HolidayModel.self, from: data) {
                    
                    print(holidayData)
                    
                    self.model = holidayData
                    
                    completionHandler(holidayData, nil)
                    
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



