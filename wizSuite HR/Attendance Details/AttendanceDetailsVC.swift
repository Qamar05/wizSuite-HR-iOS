//
//  AttendanceViewController.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/09/23.
//

import UIKit

class AttendanceDetailsVC: UIViewController {
    
    @IBOutlet var todayView: UIView!
    @IBOutlet var weekView: UIView!
    @IBOutlet var monthView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalWorkingHoursLbl: UILabel!
    @IBOutlet var todayWorkingHoursProgressBar: UIProgressView!
    @IBOutlet var weekWorkingHoursProgressBar: UIProgressView!
    @IBOutlet var monthWorkingHoursProgressBar: UIProgressView!
    @IBOutlet var selectMonthTxtField: UITextField!
    @IBOutlet var todayHrsLabel: UILabel!
    @IBOutlet var weekHoursLabel: UILabel!
    @IBOutlet var monthHoursLabel: UILabel!
    
    var viewModel: AttendanceDetailsVM?
    var timeViewModel: AttendanceViewModel?

    
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var pickerData = [String]()
    let picker = UIPickerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeViewModel = AttendanceViewModel()
        viewModel = AttendanceDetailsVM()
        
        configureUI()
      //  configureProgressBar()
        registerTableViewCells()
        configurePickerView()
        configureIndicatorView()
        showCurrentMonthOnTxtField()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyPicker))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Attendance Details"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        let image = UIImage(systemName: "chevron.backward")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:  .plain, target: self, action:  #selector(self.backAction(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
        
        //FETCHING API***
        fetchTodaysWorkingHours()
        fetchUserDetailHours()
        
    }
    
    @objc func backAction(_ sender: UIBarButtonItem? = nil) {
        print("Button click...")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func dismissMyPicker(){
        view.endEditing(true)
    }
    
    
    func configureUI(){
        
        todayView.layer.cornerRadius = 10
        todayView.layer.borderColor = UIColor.black.cgColor
        todayView.layer.borderWidth = 0.5
        
        weekView.layer.cornerRadius = 10
        weekView.layer.borderColor = UIColor.black.cgColor
        weekView.layer.borderWidth = 0.5
        
        monthView.layer.cornerRadius = 10
        monthView.layer.borderColor = UIColor.black.cgColor
        monthView.layer.borderWidth = 0.5
        
        totalWorkingHoursLbl.textColor = GenericColours.myCustomGreen
        totalWorkingHoursLbl.text = "00:00 Hrs"
        
        todayWorkingHoursProgressBar.tintColor = GenericColours.myCustomGreen
        todayWorkingHoursProgressBar.progress = 0.0
        
        weekWorkingHoursProgressBar.tintColor = GenericColours.myCustomGreen
        weekWorkingHoursProgressBar.progress = 0.0

        monthWorkingHoursProgressBar.tintColor = GenericColours.myCustomGreen
        monthWorkingHoursProgressBar.progress = 0.0

        
        todayHrsLabel.text = "00" + ":" + "00" + " Hrs"
        weekHoursLabel.text = "00" + ":" + "00" + " Hrs"
        monthHoursLabel.text = "00" + ":" + "00" + " Hrs"


        
    }
    
    func showCurrentMonthOnTxtField(){
        
        let monthInt = Calendar.current.component(.month, from: Date()) // 4
        let monthName = Calendar.current.monthSymbols[monthInt-1] // April
        selectMonthTxtField.text = monthName
       
        viewModel = AttendanceDetailsVM()
        fetchAttendanceDetails(monthIndex: monthInt)

//        timeViewModel = AttendanceViewModel()
        
               
    }
    
    
    func configureIndicatorView(){
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
    }
    
    func configurePickerView(){
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)
        
        picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor(red: 199/255, green: 202/255, blue: 209/255, alpha: 1)
        
        //  let monthNames = Calendar(identifier: .gregorian).monthSymbols
        
        
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "en_US_POSIX")
        let monthNames =  cal.monthSymbols
        print("monthNames*****",monthNames)
        pickerData =  monthNames
        
        picker.isHidden = true
        selectMonthTxtField.delegate = self
        selectMonthTxtField.inputView = picker
                
        
    }
    
    // String maxOfToday = "9:00", maxOfWeek = "45:00", maxOfMonth = "198:00";

    
    func configureTodayHrs(todayHours: String) {
        
        guard !todayHours.isEmpty else {
            return
        }
        
        let todaysWorkingHoursArr : [String] = todayHours.components(separatedBy: ":")
        if !todaysWorkingHoursArr.isEmpty {
            
            print("hoursArr****",todaysWorkingHoursArr[0])
            print("MinutesArr****",todaysWorkingHoursArr[1])
            
            var hrsInFloat :Float = 0.0
            var minsInFloat :Float = 0.0
            var secsInFloat :Float = 0.0
            
            if let hrs = Float(todaysWorkingHoursArr[0]) {
                hrsInFloat = hrs
                
            }
            if let mins = Float(todaysWorkingHoursArr[1]) {
                minsInFloat = mins
            }
            
//            if let secs = Float(todaysWorkingHoursArr[2]) {
//                secsInFloat = secs
//            }
            
            
            let totalHoursinaDay = getTotalHoursFrom(hours: hrsInFloat, minutes: minsInFloat, seconds:secsInFloat)
            let maxOfToday:Float = 9.0
            
            let totalHoursInaDay = (Float(totalHoursinaDay)  ) / (Float(maxOfToday) )
            
            todayWorkingHoursProgressBar.progress = totalHoursInaDay
            //todayHrsLabel.text = todaysWorkingHoursArr[0] + ":" + todaysWorkingHoursArr[1] + " Hrs"
        }
        
    }
    
    
    
    func configureWeekHours(weekHours: String){
        
        guard !weekHours.isEmpty else {
            return
        }
        
        let weekWorkingHoursArr : [String] = weekHours.components(separatedBy: ":")
        if !weekWorkingHoursArr.isEmpty {
            
            var hrsInFloat :Float = 0.0
            var minsInFloat :Float = 0.0
            var secsInFloat :Float = 0.0
            
            if let hrs = Float(weekWorkingHoursArr[0]){
                hrsInFloat = hrs
            }
            if let mins = Float(weekWorkingHoursArr[1]) {
                minsInFloat = mins
            }
            if let secs = Float(weekWorkingHoursArr[2]) {
                secsInFloat = secs
            }
            
            
            let totalHoursinaWeek = getTotalHoursFrom(hours: hrsInFloat, minutes: minsInFloat, seconds:secsInFloat)
            let maxOfWeek:Float = 45.0
            
            let totalHoursInaWeek = (Float(totalHoursinaWeek)  ) / (Float(maxOfWeek) )
            print("totalHoursInaWeek***",totalHoursInaWeek)
            
            weekWorkingHoursProgressBar.progress = totalHoursInaWeek
            weekHoursLabel.text = weekWorkingHoursArr[0] + ":" + weekWorkingHoursArr[1] + " Hrs"
            
        }
    }
    
    
    func configureMonthHours(monthHours: String) {
        
        guard !monthHours.isEmpty else {
            return
        }
        
        let monthWorkingHoursArr : [String] = monthHours.components(separatedBy: ":")
        if !monthWorkingHoursArr.isEmpty {
            
            var hrsInFloat :Float = 0.0
            var minsInFloat :Float = 0.0
            var secsInFloat :Float = 0.0
            
            if let hrs = Float(monthWorkingHoursArr[0]){
                hrsInFloat = hrs
            }
            if let mins = Float(monthWorkingHoursArr[1]) {
                minsInFloat = mins
            }
            if let secs = Float(monthWorkingHoursArr[2]) {
                secsInFloat = secs
            }
            
            
            let totalHoursinaMonth = getTotalHoursFrom(hours: hrsInFloat, minutes: minsInFloat, seconds:secsInFloat)
            let maxOfMonth:Float = 45.0
            
            let totalHoursInaMonth = (Float(totalHoursinaMonth)  ) / (Float(maxOfMonth) )
            print("totalHoursInaWeek***",totalHoursInaMonth)
            
            
            monthWorkingHoursProgressBar.progress = totalHoursInaMonth
            monthHoursLabel.text = monthWorkingHoursArr[0] + ":" + monthWorkingHoursArr[1] + " Hrs"
            
        }
        
    }
    
//    func configureProgressBar(todayHours: String , weekHours: String, monthHours: String){
//        
//        guard !todayHours.isEmpty else {
//            return
//        }
//        
//        let todaysWorkingHoursArr : [String] = todayHours.components(separatedBy: ":")
//        if !todaysWorkingHoursArr.isEmpty {
//            
//            print("hoursArr****",todaysWorkingHoursArr[0])
//            print("MinutesArr****",todaysWorkingHoursArr[1])
//            
//            var hrsInFloat :Float = 0.0
//            var minsInFloat :Float = 0.0
//            var secsInFloat :Float = 0.0
//            
//            if let hrs = Float(todaysWorkingHoursArr[0]) {
//                hrsInFloat = hrs
//                
//            }
//            if let mins = Float(todaysWorkingHoursArr[1]) {
//                minsInFloat = mins
//            }
//            
//            //            if let secs = Float(todaysWorkingHoursArr[2]) {
//            //                secsInFloat = secs
//            //            }
//            
//            
//            let totalHoursinaDay = getTotalHoursFrom(hours: hrsInFloat, minutes: minsInFloat, seconds:secsInFloat)
//            let maxOfToday:Float = 9.0
//            
//            let totalHoursInaDay = (Float(totalHoursinaDay)  ) / (Float(maxOfToday) )
//            
//            todayWorkingHoursProgressBar.progress = totalHoursInaDay
//            todayHrsLabel.text = todaysWorkingHoursArr[0] + ":" + todaysWorkingHoursArr[1] + " Hrs"
//        }
//        
//        
//      
//        
//        
//      
//        
//        
//        
//    }
    
    
    func getCompletedPercent(currentSeconds: Int, totalSeconds: Int) -> Float {
        return Float(currentSeconds) / Float(totalSeconds)
    }
    
    
    func getTotalHoursFrom(hours: Float, minutes: Float, seconds: Float) -> Float {
        
        let timeInHours: Float = minutes/60
        let timeInSecs: Float = seconds/3600
        
        print("Hours***", hours + timeInHours + timeInSecs)
        return hours + timeInHours + timeInSecs
        
        
//        let hoursToSec = (hours * 60) * 60
//        let minutesToSec = minutes * 60
//        return hoursToSec + minutesToSec + seconds
    }
    

    
    private func registerTableViewCells() {
        let tableViewCell = UINib(nibName: "AttendanceDetailTableViewCell",
                                  bundle: nil)
        tableView.register(tableViewCell,
                                forCellReuseIdentifier: "AttendanceDetailTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.separatorStyle = .none
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
    
    
    func fetchAttendanceDetails(monthIndex: Int) {
        
        indicatorView.startAnimating()
        
        let token =  GenericMethods.getToken()
        let monthRow = String(monthIndex)
        
        let body = ["token": token,"month": monthRow]
        
        viewModel?.fetchAttendanceDetails(body: body, completionHandler: { [weak self] (data , error) in
            
            if (error != nil) {
                DispatchQueue.main.async {
                    self?.tableView.isHidden = true
                    self?.view.makeToast(error?.localizedDescription)
                }
            }
            
            else if let data = data, data.status == true {
                
                DispatchQueue.main.async {
                    self?.tableView.isHidden = false
                    self?.tableView.reloadData()
                }
                
            } 
            else if let data = data, data.status == false {
                
                if data.message == "Token Expire Please Login Again" {
                    DispatchQueue.main.async {
                        self?.view.makeToast("Session Expire")
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.tableView.isHidden = true
                    self?.view.makeToast("No Data Found")
                }
            }
            
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
            }
            
        })
        
    }
    
    
    
    func fetchTodaysWorkingHours(){
        
        let token =  GenericMethods.getToken()
        let attendanceDate = GenericMethods.getCurrentAttendanceDate()
        
        let body = ["token": token,"attendence_date": attendanceDate]
        
        timeViewModel?.fetchTodayWorkingHours(body: body, completionHandler: { [weak self] (data , error) in
            
            if let data = data, data.status == true {
                
                DispatchQueue.main.async {
                  
                    self?.timeViewModel?.saveTodayWorkingHours(todayHours: data.todayHours ?? "")
                                        
                    if let todayHrs = data.todayHours ,  !todayHrs.isEmpty {
                        self?.configureTodayHrs(todayHours: todayHrs )
                        self?.todayHrsLabel.text = todayHrs
                        
                    }
                    
                }
                
            } else{
                DispatchQueue.main.async {
                    
                }
            }
            
        })
        
    }
    
    
    func fetchUserDetailHours() {
          
        let token =  GenericMethods.getToken()
        let attendanceDate = GenericMethods.getCurrentAttendanceDate()
        
        let body = ["token": token,"attendence_date": attendanceDate]
        
        timeViewModel?.fetchUserWorkingHoursDetails(body: body, completionHandler: { [weak self] (data , error) in
            
            if let data = data, data.status == true {
                
                DispatchQueue.main.async {
                    
//                    self?.configureTodayHrs(todayHours: data.todayHour ?? "")
                    self?.configureWeekHours(weekHours:  data.weekHour ?? "")
                    self?.configureMonthHours(monthHours: data.monthHour ?? "")
                    
                    self?.totalWorkingHoursLbl.text = data.totalHour
                }
                
            } else{
                DispatchQueue.main.async {
                    
                }
            }
            
        })
                
        
    }
    

    
    
}

extension AttendanceDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.model?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceDetailTableViewCell") as? AttendanceDetailTableViewCell {
                        
            if let vm = viewModel, let count = vm.model?.data.count, count > 0 {

                if let attendanceDetails = vm.model?.data[indexPath.row] as? AttendanceMonthDetailModel {

                    cell.bindData(withModel: attendanceDetails)

                }
            }
            
            return cell
        }
        
        return UITableViewCell()
        
        
    }
    
    
}


extension AttendanceDetailsVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        picker.isHidden = false
        return true
    }
}

extension AttendanceDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
      
        selectMonthTxtField.resignFirstResponder()
        fetchAttendanceDetails(monthIndex: row+1)
        selectMonthTxtField.text = pickerData[row]

    }
    
    
    
}
