//
//  HomeViewController.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/09/23.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var currentDayNameLbl: UILabel!
    @IBOutlet weak var currentDateNameLbl: UILabel!
    @IBOutlet weak var currentLocationLbl: UILabel!
    
    @IBOutlet weak var upperView: UIView!
    
    
    
    @IBOutlet weak var checkInOutBtn: UIButton!
    
    
    
    
    @IBOutlet weak var leavesView: UIView!
    
    @IBOutlet weak var attendanceDetailsView: UIView!
    
    @IBOutlet weak var holidayListView: UIView!
    
    @IBOutlet weak var attendanceRegularizationView: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    
        
        let leavesViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLeavesViewTap(_:)))
        leavesView.addGestureRecognizer(leavesViewTap)

        let attendanceDetailsViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAttendanceDetailsViewTap(_:)))
        attendanceDetailsView.addGestureRecognizer(attendanceDetailsViewTap)

//
        let holidayListViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleHolidayListViewTap(_:)))
        holidayListView.addGestureRecognizer(holidayListViewTap)


        let attendanceRegularizationViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAttendanceRegularizationViewTap(_:)))
        attendanceRegularizationView.addGestureRecognizer(attendanceRegularizationViewTap)

        
        configureUpperView()
        configureLowerView()
        
        

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //self.navigationItem.title = "Attendance"
    }
    
    
    
    @objc func handleLeavesViewTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManageLeavesViewController") as? ManageLeavesViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    @objc func handleAttendanceDetailsViewTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AttendanceDetailsViewController") as? AttendanceDetailsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        // handling code
    }
    
    @objc func handleHolidayListViewTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HolidayListViewController") as? HolidayListViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        // handling code
    }
    
    @objc func handleAttendanceRegularizationViewTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AttendenceRegularizationViewController") as? AttendenceRegularizationViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        //AttendenceRegularizationViewController
    }
    
    
    func configureUpperView(){
        
        upperView.layer.cornerRadius = 5
        upperView.layer.borderWidth = 0.5
        upperView.layer.borderColor = UIColor.gray.cgColor
    
                
        currentDayNameLbl.font = UIFont.boldSystemFont(ofSize: 17)
        currentDayNameLbl.textColor = UIColor(red: 74/255, green: 181/255, blue: 53/255, alpha: 1)
        
        currentDateNameLbl.font = UIFont.boldSystemFont(ofSize: 17)
        currentDateNameLbl.textColor = UIColor(red: 74/255, green: 181/255, blue: 53/255, alpha: 1)
        
        currentLocationLbl.font = UIFont.boldSystemFont(ofSize: 17)
        currentLocationLbl.textColor = UIColor(red: 74/255, green: 181/255, blue: 53/255, alpha: 1)
        
        
        checkInOutBtn.layer.cornerRadius = 6
        checkInOutBtn.backgroundColor = UIColor(red: 74/255, green: 181/255, blue: 53/255, alpha: 1)
        checkInOutBtn.titleLabel?.text = "CHECK OUT"
        checkInOutBtn.setTitleColor(.white, for: .normal)
        checkInOutBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        
    }
    

    func configureLowerView(){
        
        leavesView.backgroundColor = UIColor(red: 74/255, green: 181/255, blue: 53/255, alpha: 1)
        leavesView.layer.cornerRadius = 5

        attendanceDetailsView.backgroundColor = UIColor(red: 74/255, green: 181/255, blue: 53/255, alpha: 1)
        attendanceDetailsView.layer.cornerRadius = 5

        holidayListView.backgroundColor = UIColor(red: 74/255, green: 181/255, blue: 53/255, alpha: 1)
        holidayListView.layer.cornerRadius = 5

        attendanceRegularizationView.backgroundColor = UIColor(red: 74/255, green: 181/255, blue: 53/255, alpha: 1)
        attendanceRegularizationView.layer.cornerRadius = 5

    }

}
