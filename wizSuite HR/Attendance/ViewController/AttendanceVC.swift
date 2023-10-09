//
//  ViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/§/21.
//

import UIKit
import CoreLocation


class AttendanceVC: UIViewController {
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var upperView: UIView!
    @IBOutlet weak var currentDayNameLbl: UILabel!
    @IBOutlet weak var currentDateNameLbl: UILabel!
    @IBOutlet weak var currentLocationLbl: UILabel!
    @IBOutlet var cuurentHrsLbl: UILabel!
    @IBOutlet var cuurentMinsLbl: UILabel!
    @IBOutlet var currentAMPMLbl: UILabel!
    @IBOutlet var leavesView: UIStackView!
    @IBOutlet var attendanceDetailsView: UIStackView!
    @IBOutlet var holidayListView: UIStackView!
    @IBOutlet var attendanceRegularizationView: UIStackView!
    @IBOutlet var checkInOutBtn: UIButton!
    @IBOutlet var leavesImgView: UIImageView!
    @IBOutlet var attendanceImgView: UIImageView!
    @IBOutlet var holidayImgView: UIImageView!
    @IBOutlet var regularisationImgView: UIImageView!
    
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var viewModel: AttendanceViewModel?
    var buttonStatus: String = "CHECK IN"
    var isAppInstalledFirstTime: Bool = true
    var locationManager : CLLocationManager! = nil

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureUpperView()
        configureLowerView()
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        self.view.addSubview(indicatorView)
        
        
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        let leavesViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLeavesViewTap(_:)))
        leavesView.addGestureRecognizer(leavesViewTap)
        
        let attendanceDetailsViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAttendanceDetailsViewTap(_:)))
        attendanceDetailsView.addGestureRecognizer(attendanceDetailsViewTap)
        
        let holidayListViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleHolidayListViewTap(_:)))
        holidayListView.addGestureRecognizer(holidayListViewTap)
        
        let attendanceRegularizationViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAttendanceRegularizationViewTap(_:)))
        attendanceRegularizationView.addGestureRecognizer(attendanceRegularizationViewTap)
        
        
        viewModel = AttendanceViewModel()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AttendanceVC.userCheckIN(notification:)), name: Notification.Name("NotificationCheckIn"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AttendanceVC.userCheckOut(notification:)), name: Notification.Name("NotificationCheckOut"), object: nil)
                        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        
      //  LocationManager.shared.getLocation()
        fetchLocation()
    }
    
    
    func fetchLocation() {
        
//        FLocationManager.shared.stop()
//        
//        self.indicatorView.startAnimating()
//        self.view.isUserInteractionEnabled = false
        
        FLocationManager.shared.start { [self] (info) in
            
            print(info.longitude ?? 0.0)
            print(info.latitude ?? 0.0)
            print(info.address ?? "")
            print(info.city ?? "")
            print(info.zip ?? "")
            print(info.country ?? "")
            
            DispatchQueue.main.async { [self] in
                
                GenericMethods.saveCheckOutLatitude(lat: info.latitude ?? 0.0)
                GenericMethods.saveCheckOutLongitude(long: info.longitude ?? 0.0)
             
                let address = (info.address ?? "") + " " + (info.city ?? "") + " " + (info.zip ?? "") + " " + (info.country ?? "")
                GenericMethods.saveLocationAddress(location: address)
                
                currentLocationLbl.text = address
                self.indicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                FLocationManager.shared.stop()
                
            }
            
        }
        
    }
      
    override func viewWillDisappear(_ animated: Bool) {
        
        print("viewWillDisappear*** of Attendance Called")
        super.viewWillDisappear(animated)
        FLocationManager.shared.stop()
//        DispatchQueue.main.async { [self] in
//            self.indicatorView.stopAnimating()
//            self.view.isUserInteractionEnabled = true
//        }
    }
    
    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                   frame: CGRect? = nil,
                                   center: CGPoint? = nil) -> UIActivityIndicatorView {
        
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        if let center = center {
            activityIndicatorView.center = center
        }
        return activityIndicatorView
    }
    
    
    
    @objc func userCheckIN(notification: Notification) {
        
        // Take Action on Notification
        print("Check IN Called")
        
        DispatchQueue.main.async { [self] in
            buttonStatus = "CHECK OUT"
            self.checkInOutBtn.setTitle(self.buttonStatus, for: .normal)
            GenericMethods.saveCheckInCheckOutStatus(status: buttonStatus)
            self.dismiss(animated: true)
        }
        
    }
    
    @objc func userCheckOut(notification: Notification) {
        
        // Take Action on Notification
        print("Check Out Called")
        DispatchQueue.main.async { [self] in
            buttonStatus = "CHECK IN"
            checkInOutBtn.setTitle(buttonStatus, for: .normal)
            GenericMethods.saveCheckInCheckOutStatus(status: buttonStatus)
            self.dismiss(animated: true)
        }
        
    }
        

    //CHECK STATUS
    
    @IBAction func checkOutBtnClick(_ sender: Any) {
        
        let loginStatus = GenericMethods.getLoginStatus()
        if loginStatus == "True"{ //Show user Check In
            
            let coordinate₀ = CLLocation(latitude: GenericMethods.getCheckInLat(), longitude: GenericMethods.getCheckInLong())
            let coordinate₁ = CLLocation(latitude: GenericMethods.getCheckOutLat(), longitude: GenericMethods.getCheckOutLong())
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
            if distanceInMeters > 50 {
                //Work From Home PopUp
                self.showWFHCheckInPopUp()
                
            } else{
                //checkout PopUp
                self.checkforCheckOutPopup()
            }
            
        } else{
            
            //CHECK IN
            
            FLocationManager.shared.start { [self] (info) in
                print(info.longitude ?? 0.0)
                print(info.latitude ?? 0.0)
                print(info.address ?? "")
                print(info.city ?? "")
                print(info.zip ?? "")
                print(info.country ?? "")
                
                DispatchQueue.main.async { [self] in
                    GenericMethods.saveCheckInLatitude(lat: info.latitude ?? 0.0)
                    GenericMethods.saveCheckinLongitude(long: info.longitude ?? 0.0)
                    self.showCheckInPopUp()
                }
                
                FLocationManager.shared.stop()

                
            }
            
            
        }
            
    }
    
    
    func checkforCheckOutPopup()  {
        
        let token =  GenericMethods.getToken()
        let attendanceDate = GenericMethods.getCurrentAttendanceDate()
        let body = ["token": token,"attendence_date": attendanceDate]
        viewModel?.fetchTodayWorkingHours(body: body, completionHandler: { [weak self] (data , error) in
            if let data = data, data.status == true {
                DispatchQueue.main.async {
                    self?.viewModel?.saveTodayWorkingHours(todayHours: data.todayHours ?? "")
                    let isEarlyCheckOut = self?.isEarlyCheckOut() ?? false
                    if  isEarlyCheckOut {
                        self?.showEarlyCheckOutPopUp()
                    } else{
                        self?.showNormalCheckOutPopUp()
                    }
                    
                }
                
            } else{
                DispatchQueue.main.async {
                    
                }
            }
            
        })
        
        
    }
    
    
    func isEarlyCheckOut() -> Bool {
        
        let todaysWorkingHours = GenericMethods.getTodaysWorkingHours() ?? ""
        let todaysWorkingHoursArr : [String] = todaysWorkingHours.components(separatedBy: ":")
        if !todaysWorkingHoursArr.isEmpty {
            
            var hrsInFloat :Float = 0.0
            var minsInFloat :Float = 0.0
            
            if let hrs = Float(todaysWorkingHoursArr[0]){
                hrsInFloat = hrs
            }
            if let mins = Float(todaysWorkingHoursArr[1]) {
                minsInFloat = mins
            }
            
            let totalTodaysHours = self.getTotalHoursFrom(hours: hrsInFloat, minutes: minsInFloat, seconds:0.0)
            
            let todayWorkingHoursInaDay:Float = 9.0
            
            if totalTodaysHours < todayWorkingHoursInaDay {
                
                return true
                
            } else{
                
                return false
            }
            
            
        }
        
        return false
        
    }
    
    func getTotalHoursFrom(hours: Float, minutes: Float, seconds: Float) -> Float {
        
        let timeInHours: Float = minutes/60
        let timeInSecs: Float = seconds/3600
        return hours + timeInHours + timeInSecs
        
    }
    
    
    @IBAction func notificationTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func showCheckInPopUp(){
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckInPopUpVC") as? CheckInPopUpVC
        popOverVC?.modalPresentationStyle = .overCurrentContext
        popOverVC?.modalTransitionStyle = .crossDissolve
        self.present(popOverVC!, animated: true)
        
    }
    
    func showEarlyCheckOutPopUp(){
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EarlyCheckOutPopUpVC") as? EarlyCheckOutPopUpVC
        popOverVC?.modalPresentationStyle = .overCurrentContext
        popOverVC?.modalTransitionStyle = .crossDissolve
        self.present(popOverVC!, animated: true)
        
    }
    
    func showNormalCheckOutPopUp(){
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckOutPopUpVC") as? CheckOutPopUpVC
        popOverVC?.modalPresentationStyle = .overCurrentContext
        popOverVC?.modalTransitionStyle = .crossDissolve
        self.present(popOverVC!, animated: true)
        
    }
    
    func showWFHCheckInPopUp(){
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WFHCheckInPopUpVC") as? WFHCheckInPopUpVC
        popOverVC?.modalPresentationStyle = .overCurrentContext
        popOverVC?.modalTransitionStyle = .crossDissolve
        self.present(popOverVC!, animated: true)
        
    }
        
    @objc func handleLeavesViewTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManageLeavesViewController") as? ManageLeavesVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func handleAttendanceDetailsViewTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AttendanceDetailsVC") as? AttendanceDetailsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func handleHolidayListViewTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HolidayListVC") as? HolidayListVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @objc func handleAttendanceRegularizationViewTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AttendenceRegularizationViewController") as? AttendenceRegularizationVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    func configureUpperView(){
        
        upperView.layer.cornerRadius = 5
        upperView.layer.borderWidth = 0.5
        upperView.layer.borderColor = UIColor.gray.cgColor
        
        let currentTime : [String] = GenericMethods.getCurrentHours().components(separatedBy: ":")
        if !currentTime.isEmpty {
            
            cuurentHrsLbl.text = currentTime[0]
            
            let currentMins:[String] = currentTime[1].components(separatedBy: " ")
            cuurentMinsLbl.text = currentMins[0]
            currentAMPMLbl.text = currentMins[1]
            
        }
                
        currentDayNameLbl.textColor = GenericColours.myCustomGreen
        currentDayNameLbl.text = Date().dayOfWeek()!
        
        currentDateNameLbl.textColor = GenericColours.myCustomGreen
        currentDateNameLbl.text = "Date - " + Date.getCurrentDate()
        
        currentLocationLbl.textColor = GenericColours.myCustomGreen
        currentLocationLbl.text = GenericMethods.getLocationAddress()
        
        // checkInOutBtn.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 17)
        checkInOutBtn.layer.cornerRadius = 6
        checkInOutBtn.backgroundColor = GenericColours.myCustomGreen
      //  checkInOutBtn.setTitleColor(.white, for: .normal)
        
        
        let loginStatus = GenericMethods.getLoginStatus()
        if loginStatus == "True"{ //Show user Check In
            buttonStatus = "CHECK OUT"
            GenericMethods.saveCheckInCheckOutStatus(status: buttonStatus)
            checkInOutBtn.setTitle(buttonStatus, for: .normal)
            
        } else{
            buttonStatus = "CHECK IN"
            GenericMethods.saveCheckInCheckOutStatus(status: buttonStatus)
            checkInOutBtn.setTitle(buttonStatus, for: .normal)
        }
        
        
        
        //        let defaults = UserDefaults.standard
        //        if defaults.bool(forKey: "First Launch") == true {
        //
        //            print ("Second+")
        //            //Run code after first Launch
        //            defaults.set (true, forKey: "First Launch")
        //
        //
        //            let status = GenericMethods.getCheckInCheckOutStatus()
        //            buttonStatus = status
        //            checkInOutBtn.setTitle(buttonStatus, for: .normal)
        //            checkInOutBtn.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 17)
        //
        //
        //
        //        }
        //        else{ //FIRST TIME
        //
        //            defaults.set (true, forKey: "First Launch")
        //
        //            buttonStatus = "CHECK IN"
        //            GenericMethods.saveCheckInCheckOutStatus(status: buttonStatus)
        //
        //        }
        
        
        
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
        
        
        leavesImgView.image = UIImage(named: "Image")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: 0, bottom: 4, right: 0))
        attendanceImgView.image = UIImage(named: "attendence_details")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: 0, bottom: 4, right: 0))
        holidayImgView.image = UIImage(named: "holidays")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: 0, bottom: 4, right: 0))
        regularisationImgView.image = UIImage(named: "attendance_regularisation")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: 0, bottom: 4, right: 0))
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationCheckIn"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationCheckOut"), object: nil)
        
    }
    
    
    
}


