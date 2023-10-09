//
//  ChangePasswordVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 25/09/23.
//

import UIKit

//{
//    "token":"d565da447cef6e7ddacd623c032dde7c",
//    "new_password":"987654321"
//}



class ChangePasswordVM {
    
    var model: ChangePasswordModel?
    
    func fetchChangePwData(body: [String: Any], completionHandler: @escaping  (_ data: ChangePasswordModel?,_ error: Error?) -> Void ) {
        
        print("BODY ITEMS CHANGE PW:****",body)
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.changePwUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let changePwData = try? JSONDecoder().decode(ChangePasswordModel.self, from: data) {
                    
                    print(changePwData)
                    
                    self.model = changePwData
                    
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
