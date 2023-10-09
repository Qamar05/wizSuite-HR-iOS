//
//  HolidayListTableViewCell.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/09/23.
//

import UIKit

class HolidayListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var holidaySideView: UIView!
    @IBOutlet weak var holidayNameLbl: UILabel!
    @IBOutlet weak var holidayDayLbl: UILabel!
    @IBOutlet weak var holidayDate: UILabel!
    
    var viewModel: HolidayListVM? =  HolidayListVM()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureUI(){
        
        holidaySideView.backgroundColor = GenericColours.myCustomGreen
        backView.layer.borderColor = GenericColours.myCustomGreen.cgColor
        backView.layer.borderWidth = 2
                    
    }
    
    func bindData(withModel model: HolidayData){
             
        holidayDayLbl.text = model.holidayDay
        holidayDayLbl.textColor =  GenericColours.lightGrayColor
        holidayNameLbl.text = model.holidayName
        holidayNameLbl.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        holidayDate.numberOfLines = 0
        holidayDate.preferredMaxLayoutWidth = 50
        holidayDate.lineBreakMode = .byWordWrapping
        holidayDate.sizeToFit()
        holidayDate.textColor = .white
        holidayDate.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: model.holidayDate)
       
        
        let monthName: String = date?.formatted(Date.FormatStyle().month(.abbreviated)) as? String ?? ""
        let dateName: String = date?.formatted(Date.FormatStyle().day(.twoDigits)) as? String ?? ""
        
        let dateShown = dateName + " " + monthName
        holidayDate.text = dateShown
        
    }
    
    
}
