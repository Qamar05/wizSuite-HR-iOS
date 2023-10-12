//
//  AttendanceDetailTableViewCell.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 02/10/23.
//

import UIKit

class AttendanceDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var attendanceDate: UILabel!
    @IBOutlet var workingHours: UILabel!
    @IBOutlet var checkInTime: UILabel!
    @IBOutlet var checkOutTime: UILabel!
    @IBOutlet var checkInComment: UILabel!
    @IBOutlet var checkOutComment: UILabel!
    @IBOutlet var checkInStatus: UILabel!
    @IBOutlet var checkInStatusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 5
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.borderWidth = 1
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func bindData(withModel model: AttendanceMonthDetailModel) {
        
        
        let attendanceDates = attendanceDateConversion(attendanceDate: model.attendenceDate ?? "")
        attendanceDate.text = attendanceDates
        workingHours.text = model.totalHour
        checkInTime.text = model.timeIn
        checkOutTime.text = model.timeOut
        checkInStatus.text = model.checkinStatus
        checkInComment.text = model.commentIn
        checkOutComment.text = model.commentOut
              

        
        if let timeOut = model.timeOut , !timeOut.isEmpty  { //Attendance Regularisation
            
            if checkInStatus.text == "At office" {
               checkInStatusView.backgroundColor = GenericColours.myCustomGreen
               checkInTime.textColor = .black
               checkOutTime.textColor =  .black
           }
           else if checkInStatus.text == "Worked Remotely"  {
               checkInStatusView.backgroundColor = GenericColours.purpleColour
               checkInTime.textColor = .black
               checkOutTime.textColor =  .black
           }
           else{
               checkInStatusView.backgroundColor = GenericColours.myCustomGreen
           }
            

        } else{
            
            checkInStatusView.backgroundColor = GenericColours.yellowColor
            checkInTime.textColor = GenericColours.yellowColor
            checkOutTime.textColor =  GenericColours.yellowColor
            workingHours.text = "NA"
            
        }
       
        
        
        
    }
    
    
    func attendanceDateConversion(attendanceDate: String) -> String {
        
        //"2023-09-04"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let dateFromStr = dateFormatter.date(from: attendanceDate) else{
            return ""
        }
       
        dateFormatter.dateFormat = "EE, MMM d, yyyy"
        let timeFromDate = dateFormatter.string(from: dateFromStr)
        print(timeFromDate)
        
        return timeFromDate
        
    }
    
    
    
}
