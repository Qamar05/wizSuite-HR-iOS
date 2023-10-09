//
//  SupportVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 22/09/23.
//

import UIKit

class SupportVM {
    
    var model: SupportModel?
    
    func fetchSupportDetails(body: [String: Any],completionHandler: @escaping(_ data: SupportModel?,_ error: Error?) -> Void ) {
        
        let token = GenericMethods.getToken()
        
//        let body = ["token": token,"heading": "kkkj","description": "fffff","photo": "hhhh"]
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.getSupportUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
            } else if let data = data {
                
                if let supportData = try? JSONDecoder().decode(SupportModel.self, from: data) {
                    print(supportData)
                    self.model = supportData
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


