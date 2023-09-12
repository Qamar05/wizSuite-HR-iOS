//
//  LoginViewModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit

typealias completionHandler = (_ data: LoginModel?,_ error: Error?) -> Void

class LoginViewVM {
        
     func fetchLoginData(completionHandler: @escaping completionHandler ) {
        
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
                
                completionHandler(nil,error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let loginData = try? JSONDecoder().decode(LoginModel.self, from: data) {
                  
                    print(loginData)
                    
                    self.saveData(loginData: loginData)
                    
                    completionHandler(loginData, nil)
                                        
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
    
    
    func saveData(loginData: LoginModel){
        
        self.saveToken(token:loginData.token)
        self.saveUsername(firstName: loginData.firstName, lastName:loginData.lastName)
        self.saveDesignation(designation: loginData.designation)
        self.saveProfilePic(profilePic: loginData.photo)
    }
   
    
    func saveToken(token : String){
        
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "TOKEN")
        defaults.synchronize()
    }
    
    func saveUsername(firstName : String, lastName: String){
        
        let userName = firstName + lastName
        let defaults = UserDefaults.standard
        defaults.set(userName, forKey: "USERNAME")
        defaults.synchronize()
    }
    
    func saveDesignation(designation : String){
        
        let defaults = UserDefaults.standard
        defaults.set(designation, forKey: "DESIGNATION")
        defaults.synchronize()
    }
    
    func saveProfilePic(profilePic: String){
        
        let defaults = UserDefaults.standard
        defaults.set(profilePic, forKey: "PROFILEPIC")
        defaults.synchronize()
    }
    
    
    
    
    
    
    
    
    
    
    
}



//save data - profile pic, designation, image, username
//token expire , access revoke - we send user outside on login screen
