//
//  MyBirthdayVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import Foundation


class BirthdayListVM {
    
    var model: BirthdayListModel?
    
    func fetchBirthdayDetails(body: [String: Any], completionHandler: @escaping(_ data: BirthdayListModel?,_ error: Error?) -> Void ) {
        
        //        {
        //            "token" : "39bd6f9f7ecff7efee09aecee0d93fe6",
        //            "attendence_date" : "2023-03-14"
        //        }
        
       // let body = ["token": "39bd6f9f7ecff7efee09aecee0d93fe6","attendence_date": "2023-03-14"]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.getBirthdayListUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.setValue(GenericMethods.getToken(), forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
            } else if let data = data {
                
                if let birthdayData = try? JSONDecoder().decode(BirthdayListModel.self, from: data) {
                    print(birthdayData)
                    self.model = birthdayData
                    completionHandler(birthdayData, nil)
                    
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



//save data - profile pic, designation, image, username
//token expire , access revoke - we send user outside on login screen

