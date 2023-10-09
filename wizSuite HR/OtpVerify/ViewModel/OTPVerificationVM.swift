//
//  OTPVerificationVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 12/09/23.
//

import UIKit

class OTPVerificationVM: NSObject {
    
    var model: OTPModel?
    
    func sendOTPToEmail(body: [String: Any], completionHandler: @escaping (_ data: OTPModel?,_ error: Error?) -> Void ) {
        
//        let body = ["username": "qamar@vmstechs.com","password": "test@123"]
        
//        {
//            "email":"qamar@vmstechs.com"
//        }
        
        
        print("BODY ITEMS:****",body)
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.sendOTPUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let otpData = try? JSONDecoder().decode(OTPModel.self, from: data) {
                    
                    print(otpData)
                    
                    self.model = otpData
                    
                    completionHandler(otpData, nil)
                    
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
    
    func verifyOTPData(body: [String: Any], completionHandler: @escaping  (_ data: OTPModel?,_ error: Error?) -> Void  ) {
        
        print("BODY ITEMS:****",body)
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.verifyOTPUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let otpData = try? JSONDecoder().decode(OTPModel.self, from: data) {
                    
                    print(otpData)
                    
                    if otpData.status == true {
                        self.model = otpData
                    }
                    
                    completionHandler(otpData, nil)
                    
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


