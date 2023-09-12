//
//  HomeViewController.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/09/23.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var currentDayNameLbl: UILabel!
    @IBOutlet weak var currentDateNameLbl: UILabel!
    @IBOutlet weak var currentLocationLbl: UILabel!
    
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var currentHoursLbl: UILabel!
    @IBOutlet weak var currentMinsLbl: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    @IBOutlet weak var checkInOutBtn: UIButton!
    
    
    @IBOutlet weak var leavesView: UIView!
    
    @IBOutlet weak var attendanceDetailsView: UIView!
    
    @IBOutlet weak var holidayListView: UIView!
    
    @IBOutlet weak var attendanceRegularizationView: UIView!
    
    
//    @IBOutlet weak var refreshButton: UIButton!
    
    
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
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

        
//        let rightItem1 = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: nil)
//
//        navigationItem.leftBarButtonItems = [rightItem1]

        self.navigationItem.title = "Attendance"
    }
    
    
    
    
    @objc func handleLeavesViewTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManageLeavesViewController") as? ManageLeavesVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    @objc func handleAttendanceDetailsViewTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AttendanceDetailsViewController") as? AttendanceDetailsVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        // handling code
    }
    
    @objc func handleHolidayListViewTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HolidayListViewController") as? HolidayListVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        // handling code
    }
    
    @objc func handleAttendanceRegularizationViewTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AttendenceRegularizationViewController") as? AttendenceRegularizationVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        //AttendenceRegularizationViewController
    }
    
    
    func configureUpperView(){
        
        
        refreshButton.backgroundColor = GenericColours.myCustomGreen
        
        
        upperView.layer.cornerRadius = 5
        upperView.layer.borderWidth = 0.5
        upperView.layer.borderColor = UIColor.gray.cgColor
    
                
        currentDayNameLbl.font = UIFont.boldSystemFont(ofSize: 17)
        currentDayNameLbl.textColor = GenericColours.myCustomGreen
        currentDayNameLbl.text = Date().dayOfWeek()!
        
        currentDateNameLbl.font = UIFont.boldSystemFont(ofSize: 17)
        currentDateNameLbl.textColor = GenericColours.myCustomGreen
        currentDateNameLbl.text = "Date - " + Date.getCurrentDate()
        
        
        currentLocationLbl.font = UIFont.boldSystemFont(ofSize: 17)
        currentLocationLbl.textColor = GenericColours.myCustomGreen
        
        
        checkInOutBtn.layer.cornerRadius = 6
        checkInOutBtn.backgroundColor = GenericColours.myCustomGreen
        checkInOutBtn.titleLabel?.text = "CHECK OUT"
        checkInOutBtn.setTitleColor(.white, for: .normal)
      //  checkInOutBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        
        refreshButton.backgroundColor = GenericColours.myCustomGreen
        
        
//
//        let date = Date()
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//
//
        
        
        currentHoursLbl.text = Date().hour()
        currentMinsLbl.text = Date().minute()

        
    }
    

    func configureLowerView(){
        
        leavesView.backgroundColor =  GenericColours.myCustomGreen
        leavesView.layer.cornerRadius = 5

        attendanceDetailsView.backgroundColor = GenericColours.myCustomGreen
        attendanceDetailsView.layer.cornerRadius = 5

        holidayListView.backgroundColor = GenericColours.myCustomGreen
        holidayListView.layer.cornerRadius = 5

        attendanceRegularizationView.backgroundColor = GenericColours.myCustomGreen
        attendanceRegularizationView.layer.cornerRadius = 5

    }
    
    

}
