//
//  MainViewViewModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit



class AttendanceViewModel {
    

    func fetchCheckInData(body: [String: Any], completionHandler: @escaping  (_ data: CheckInModel?,_ error: Error?) -> Void ) {
        
      //  let body = ["token": "5d0b78332086b633248eb3c846f9e3eb","attendence_date": "2023-08-29","checkin_note": "","checkin_let": "28.6254503","checkin_long": "77.377166"]
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.checkInUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
                completionHandler(nil, error)

            } else if let data = data {
                
                if let checkInData = try? JSONDecoder().decode(CheckInModel.self, from: data) {
                    
                    print(checkInData)
                    completionHandler(checkInData , nil)
                    
                    
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
    
   
    func fetchCheckOutData(body: [String: Any], completionHandler: @escaping  (_ data: CheckOutModel?,_ error: Error?) -> Void ) {
        

        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.checkOutUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil, error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let checkOutData = try? JSONDecoder().decode(CheckOutModel.self, from: data) {
                    
                    print(checkOutData)
                    
                    completionHandler(checkOutData , nil)
                    
                    
                } else {
                    print("Invalid Response")
                }
                // Handle HTTP request response
            } else {
                // Handle unexpected error
            }
        }
        task.resume()
    }
    
    
    
    func fetchTodayWorkingHours(body: [String: Any], completionHandler: @escaping  (_ data: TodayWorkingHoursModel?,_ error: Error?) -> Void ) {
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.todayWorkingHoursUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil, error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let todayWorkingHours = try? JSONDecoder().decode(TodayWorkingHoursModel.self, from: data) {
                    
                    print(todayWorkingHours)
                                                            
                    completionHandler(todayWorkingHours , nil)
                    
                    
                } else {
                    print("Invalid Response")
                }
                // Handle HTTP request response
            } else {
                // Handle unexpected error
            }
        }
        task.resume()
    }
    
    
    
    func fetchUserWorkingHoursDetails(body: [String: Any], completionHandler: @escaping (_ data: AttendenceUserWorkingHoursModel?,_ error: Error?) -> Void ) {
        
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.getUserDetailUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil,error)
                // Handle HTTP request error
            } else if let data = data {
                
                if let userDetail = try? JSONDecoder().decode(AttendenceUserWorkingHoursModel.self, from: data) {
                  
                    print(userDetail)
                    
                    completionHandler(userDetail, nil)
                    
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
    
    
    func saveTodayWorkingHours(todayHours: String){
                
        let defaults = UserDefaults.standard
        defaults.set(todayHours, forKey: "TODAY_WORKING_HOURS")
        defaults.synchronize()
    }
    
    func saveWeekWorkingHours(todayHours: String){
                
        let defaults = UserDefaults.standard
        defaults.set(todayHours, forKey: "WEEK_WORKING_HOURS")
        defaults.synchronize()
    }
    
    func saveMonthWorkingHours(todayHours: String){
                
        let defaults = UserDefaults.standard
        defaults.set(todayHours, forKey: "MONTH_WORKING_HOURS")
        defaults.synchronize()
    }
    
    func saveTotalWorkingHours(todayHours: String){
                
        let defaults = UserDefaults.standard
        defaults.set(todayHours, forKey: "TOTAL_WORKING_HOURS")
        defaults.synchronize()
    }
    
    
    
    
}

