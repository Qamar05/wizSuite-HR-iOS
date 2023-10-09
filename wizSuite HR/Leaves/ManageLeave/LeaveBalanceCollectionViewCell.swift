//
//  LeaveBalanceCollectionViewCell.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 14/09/23.
//

import UIKit

class LeaveBalanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var backView: UIView!
    @IBOutlet var leaveTypeLbl: UILabel!
    @IBOutlet var leaveAvailedLbl: UILabel!
    @IBOutlet var leaveRemainingLbl: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundColor = .purple
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 10
        
        leaveTypeLbl.textColor = GenericColours.purpleColour
        leaveAvailedLbl.textColor = GenericColours.myCustomGreen
        leaveRemainingLbl.textColor = GenericColours.blueColour

    }
    
    
    func bindData(withModel model: LeaveBalanceModel){
        
        leaveTypeLbl.text = model.leaveName
        
                
        if let totalLeaveDays = model.leaveDays, let remainingDays = model.remainingDays {
            
            let totalLeaveDaysInt = Int(totalLeaveDays) ?? 0
            let remainingDaysInt = Int(remainingDays) ?? 0
            
            let availedDays = totalLeaveDaysInt -  remainingDaysInt
            leaveAvailedLbl.text = ("Availed : " +  String(availedDays))
            
        }
     
//        let availedLeaves = totalLeaveDays - remainingDays
        
        
        leaveRemainingLbl.text = ("Remaining : " +  (model.remainingDays ?? "0") )
               
    }
}
