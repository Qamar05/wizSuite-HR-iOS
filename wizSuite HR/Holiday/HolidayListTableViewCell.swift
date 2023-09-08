//
//  HolidayListTableViewCell.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/09/23.
//

import UIKit

class HolidayListTableViewCell: UITableViewCell {

    
    @IBOutlet var backView: UIView!
    @IBOutlet weak var holidaySideView: UIView!
    @IBOutlet weak var holidayNameLbl: UILabel!
    @IBOutlet weak var holidayDayLbl: UILabel!
    
    
    
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
        
        holidaySideView.backgroundColor = .green
        
        backView.layer.borderColor = UIColor.green.cgColor
        backView.layer.borderWidth = 2
        
        
        holidayNameLbl.text = "Republic Day"
        holidayDayLbl.text = "Thursday"
        
        
    }
    
    
    
}


extension HolidayListTableViewCell {
    
    
}
