//
//  LoginViewModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit


class LoginViewModel {
    
    @objc static func fetchLoginData(){
        
        let body = ["username": "vibhuti.gupta@vmstechs.com","password": "Atharv@07"]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.loginBaseUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenericMethods.getToken(), forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
            } else if let data = data {
                
                if let loginData = try? JSONDecoder().decode(LoginModel.self, from: data) {
                  
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



//save data - profile pic, designation, image, username
//token expire , access revoke - we send user outside on login screen
