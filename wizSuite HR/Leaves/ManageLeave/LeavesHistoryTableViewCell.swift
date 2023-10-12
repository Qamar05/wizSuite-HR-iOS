//
//  LeavesHistoryTableViewCell.swift
//  Test
//
//  Created by vibhuti gupta on 17/09/23.
//

import UIKit

protocol LeavesHistoryTableViewCellDelegate: AnyObject {
    func cancelButtonClick(indexPath: IndexPath)
}

class LeavesHistoryTableViewCell: UITableViewCell{
    
    @IBOutlet var backView: UIView!
    @IBOutlet var appliedOnLbl: UILabel!
    @IBOutlet var createddateLbl: UILabel!
    @IBOutlet var appliedDatelbl: UILabel!
    @IBOutlet var reasonLbl: UILabel!
    @IBOutlet var leaveStatusLbl: UILabel!
    @IBOutlet var leavesStatusBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var noofDaysLbl: UILabel!
    weak var delegate: LeavesHistoryTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        
        backView.layer.cornerRadius = 10
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.borderWidth = 0.5
        
        appliedOnLbl.textColor = GenericColours.lightGrayColor
        
        leavesStatusBtn.layer.cornerRadius = 6
        leavesStatusBtn.setTitleColor(.white, for: .normal)
        
        
        cancelBtn.layer.cornerRadius = 6
        cancelBtn.clipsToBounds = true
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.setTitle("Cancel", for: .normal)
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func bindTableViewData(indexPath: IndexPath, withModel model: LeavesAppliedModel, leaveModel:LeavesHistoryModel?){
        
        self.indexPath = indexPath
        
        configureAppliedDate(withModel: model)
        configureFromToDates(withModel: model)
        
      
        reasonLbl.text = model.reason
        leaveStatusLbl.text = model.leaveType
        leavesStatusBtn.setTitle(model.leaveStatus, for: .normal)
        
        
        if model.leaveStatus == "Approved"{
            leaveStatusLbl.textColor = GenericColours.myCustomGreen
            leavesStatusBtn.backgroundColor = GenericColours.myCustomGreen
        } else if model.leaveStatus == "Declined"{
            leaveStatusLbl.textColor = GenericColours.redColor
            leavesStatusBtn.backgroundColor = GenericColours.redColor
        } else if model.leaveStatus ==  "Pending"{
            leaveStatusLbl.textColor = GenericColours.yellowColor
            leavesStatusBtn.backgroundColor = GenericColours.yellowColor
        }else if model.leaveStatus == "Awaitng"{
            leaveStatusLbl.textColor = GenericColours.yellowColor
            leavesStatusBtn.backgroundColor = GenericColours.yellowColor
        }
        
        
        if let leavestatus = model.leaveStatus, leavestatus.contains("Pending") {
            
            //Comparing Logic of Today Date and Created Date
            
            let todayDate = GenericMethods.getCurrentAttendanceDate()
                        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFromStr = dateFormatter.date(from: model.createdAt ?? "") ?? Date()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let createdDate = dateFormatter.string(from: dateFromStr)
            print(createdDate)
            
            
            if todayDate.compare(createdDate) == .orderedSame {
                print("Both dates are same")
                cancelBtn.isHidden = true
            } else{
                cancelBtn.isHidden = false
            }
        } else{
            cancelBtn.isHidden = true
        }
        
                
    }
    
    func configureAppliedDate(withModel model: LeavesAppliedModel){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateFromStr = dateFormatter.date(from: model.createdAt ?? ""){
            dateFormatter.dateFormat = "EE MMM d, yyyy"
            let timeFromDate = dateFormatter.string(from: dateFromStr )
            appliedOnLbl.text = "Applied on:" + " " + timeFromDate
        }
        
    }
    
    func configureFromToDates(withModel model: LeavesAppliedModel){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateFromStr = dateFormatter.date(from: model.dateFrom ?? ""),  let dateToStr = dateFormatter.date(from: model.dateTo ?? ""){
            
            dateFormatter.dateFormat = "EE MMM d"
            let dateFrom =  dateFormatter.string(from: dateFromStr )
            let dateTo =  dateFormatter.string(from: dateToStr )
            createddateLbl.text = dateFrom + " - " + dateTo
            
            let calendar = Calendar.current
            let fromDate = calendar.startOfDay(for: dateFromStr)
            let toDate = calendar.startOfDay(for: dateToStr)
            
            let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate)
            
            if let days =  numberOfDays.day {
                
                let numberofDays1 = days + 1
                var days = "Day"
                
                if numberofDays1 > 1 {
                    days = " Days"
                } else{
                    days = " Day"
                }
                
                if numberofDays1 > 0 {
                    noofDaysLbl.text = "For " + String(numberofDays1) + days
                } else{
                    noofDaysLbl.isHidden = true
                }
                
            } else{
                noofDaysLbl.isHidden = true
            }
            
            
        } else{
            noofDaysLbl.isHidden = true
            
        }
        
        
    }
    
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        delegate?.cancelButtonClick(indexPath:  self.indexPath ?? [0,0])
    }
    
    
}
