//
//  MyProfileVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit

class MyProfileVM {
    
    var model: MyProfileModel?
    
    func fetchProfileDetails(completionHandler: @escaping(_ data: MyProfileModel?,_ error: Error?) -> Void ) {
        
        let token = GenericMethods.getToken()
        let body = ["token": token]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.myProfileUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
            } else if let data = data {
                
                if let profileData = try? JSONDecoder().decode(MyProfileModel.self, from: data) {
                    print(profileData)
                    self.model = profileData
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
    

    
    
    
}

