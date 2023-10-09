//
//  NotificationVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit


class NotificationVM {
    
    var model: NotificationModel?
    
    func fetchNotificationDetails(completionHandler: @escaping(_ data: NotificationModel?,_ error: Error?) -> Void ) {
        
        let body = ["user_id": "61"]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.getNotificationUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
            } else if let data = data {
                
                if let notiData = try? JSONDecoder().decode(NotificationModel.self, from: data) {
                    print(notiData)
                    self.model = notiData
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


