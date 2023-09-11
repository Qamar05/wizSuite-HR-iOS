//
//  MainViewViewModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit

//{
//    "token" : "5d0b78332086b633248eb3c846f9e3eb",
//    "attendence_date" : "2023-08-24",
//    "checkin_note" : "check notes ",
//    "checkin_let" : "28.6254503",
//    "checkin_long" : "77.377166"
//}



class MainViewViewModel {
    
   
    @objc static func fetchCheckInData(){
        
        let body = ["token": "5d0b78332086b633248eb3c846f9e3eb","attendence_date": "2023-08-24","checkin_note": "","checkin_let": "28.6254503","checkin_long": "77.377166"]
        
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
        request.setValue(GenericMethods.getToken(), forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
            } else if let data = data {
                
                if let loginData = try? JSONDecoder().decode(CheckInModel.self, from: data) {
                  
                    print(loginData)
                    
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
    
    
//    {
//        "token" : "1b4bbc1f741ff237a97d256d22868f6c",
//        "attendence_date" : "2023-02-02",
//        "checkout_note" : "",
//        "checkout_let" : "28.878",
//        "checkout_long" : "79.86",
//        "approved_by":"hr manager"
//    }
    

    func fetchCheckOutData(){
        
        let body = ["token": "5d0b78332086b633248eb3c846f9e3eb","attendence_date": "2023-08-24","checkout_note": "","checkout_let": "28.6254503","checkout_long": "77.377166","approved_by":"hr manager"]
        
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
        request.setValue(GenericMethods.getToken(), forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
            } else if let data = data {
                
                if let loginData = try? JSONDecoder().decode(CheckOutModel.self, from: data) {
                  
                    print(loginData)
                    
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
        
        
    }

