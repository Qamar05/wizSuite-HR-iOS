//
//  ForgotPasswordVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 12/09/23.
//

import UIKit

//Body
//{
//    "username" : "qamar@vmstechs.com",
//    "new_password" : "98765432"
//}

typealias completionHandlers = (_ data: ForgotPwModel?,_ error: Error?) -> Void


class ForgotPasswordVM {
        
     func fetchForgotPwData(completionHandler: @escaping completionHandlers ) {
        
        let body = ["username": "qamar@vmstechs.com","new_password": "98765432"]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.forgotPasswordUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       // request.setValue(GenericMethods.getToken(), forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
               completionHandler(nil, error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let forgotPwData = try? JSONDecoder().decode(ForgotPwModel.self, from: data) {
                  
                    print(forgotPwData)
                                        
                    completionHandler(forgotPwData, nil)
                    
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


