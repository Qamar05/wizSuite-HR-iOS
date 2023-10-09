//
//  LeavesVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 13/09/23.
//

import UIKit

typealias manageLeavesHandler = (_ data: LeavesHistoryModel?,_ error: Error?) -> Void

class ManageLeavesVM {
    
    var model: LeavesHistoryModel?
    var cancelModel: LeavesCancelModel?
    
    func fetchLeavesData(completionHandler: @escaping manageLeavesHandler ) {
        
        let token = GenericMethods.getToken()
        print("BODY TOKEN***",token)
        
        let body = ["token": token]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.leavesHistoryUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue(GenericMethods.getToken(), forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let leavesData = try? JSONDecoder().decode(LeavesHistoryModel.self, from: data) {
                    print(leavesData)
                    self.model = leavesData
                    completionHandler(self.model , nil)
                }
                else {
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
    

    func pickFromJSON(){
        
        let jsonData = readLocalJSONFile(forName: "Leaves")
        if let data = jsonData {
            
            do {
                let decodedData = try JSONDecoder().decode(LeavesHistoryModel.self, from: data)
                print("decodedData***",decodedData)
            } catch {
                print("error: \(error)")
            }
            
        }
        
        func readLocalJSONFile(forName name: String) -> Data? {
            do {
                if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                    let fileUrl = URL(fileURLWithPath: filePath)
                    let data = try Data(contentsOf: fileUrl)
                    return data
                }
            } catch {
                print("error: \(error)")
            }
            return nil
        }
        
    }
    
    
    func cancelLeaveAPI(body: [String:Any], completionHandler: @escaping (_ data: LeavesCancelModel?,_ error: Error?) -> Void ){
        

        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.leavesCancelUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue(GenericMethods.getToken(), forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let leavesCancelData = try? JSONDecoder().decode(LeavesCancelModel.self, from: data) {
                   
                    print(leavesCancelData)
                    
                    self.cancelModel = leavesCancelData
                    
                    completionHandler(self.cancelModel , nil)
                }
                else {
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

