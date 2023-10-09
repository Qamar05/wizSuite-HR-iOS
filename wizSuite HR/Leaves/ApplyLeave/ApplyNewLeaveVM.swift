//
//  ApplyLeaveVM.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 15/09/23.
//

import UIKit

class ApplyNewLeaveVM: NSObject {
    
    var model: ApplyNewLeaveModel?
    
    //        {
    //                "token": "1583cce1f7928a3ebedd1e0c98e515cb",
    //                "leaveType" : "Earned",
    //                "dateFrom" : "2023-09-06",
    //                "dateTo" : "2023-09-06",
    //                "reason" : "Family Reasons"
    //            }
    
    func applyNewLeave(body: [String: Any], completionHandler: @escaping(_ data: ApplyNewLeaveModel?,_ error: Error?) -> Void ) {
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Send request
        guard let url = URL(string: NetworkConstant.applyLeaveUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                completionHandler(nil,error)
                
                // Handle HTTP request error
            } else if let data = data {
                
                if let leavesData = try? JSONDecoder().decode(ApplyNewLeaveModel.self, from: data) {
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
    
    
    
    func saveLeaveType(leaveType: String, noofDays: Int) {
        
//        var leaveCounter = UserDefaults.standard.integer(forKey: leaveType)
//        leaveCounter = noofDays + leaveCounter
//        
//        
        var leaveCounter = self.getLeaveCounter(leaveType: leaveType)
        leaveCounter = leaveCounter + noofDays
        
        print("Leave Counter  Leave Type*****", leaveCounter ,leaveType)
        
        UserDefaults.standard.setValue(leaveCounter, forKey: leaveType)
        UserDefaults.standard.synchronize()
        
    }
    
    
    func getLeaveCounter(leaveType: String) -> Int {
        
        let leaveCounter = UserDefaults.standard.integer(forKey: leaveType)
        return leaveCounter
        
    }
    
    
    
}
