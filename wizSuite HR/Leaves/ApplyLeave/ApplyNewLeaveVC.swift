//
//  ApplyLeaveVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 14/09/23.
//

import UIKit

class ApplyNewLeaveVC: UIViewController {
    
    @IBOutlet var fromTxtField: UITextField!
    @IBOutlet var toTextField: UITextField!
    @IBOutlet var causeTextView: UITextView!
    @IBOutlet var applyLeavesBtn: UIButton!
    @IBOutlet var leavesTextField: UITextField!
    
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    let screenWidth = UIScreen.main.bounds.width
    var pickerToolbar: UIToolbar?
    var datePicker :UIDatePicker!
    var viewModel: ApplyNewLeaveVM?
    var selectedLeave: String = ""
    var leavesList :[String] = []
    var remaningLeavesLocalCounter: Int = 0
    private var localDays = ""
    private var noofDaysCounter: Int = 0
    var leaveType: String = ""
    
    
    var fromDate = Date()
    var toDate = Date()
    var leavetext : String = ""
    
   

    
    //["Casual    (0) Days", "Earned    (0) Days", "Maternity Leave    (180) Days", "Bereavement    (1) Days"]
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d, yyyy"
        return formatter
    }()
    
    var leavesModel: ManageLeavesVM?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ApplyNewLeaveVM()
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        self.view.addSubview(indicatorView)
        
        configureUI()
        createUIToolBar()
        
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        //   datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        datePicker.datePickerMode = .date
        
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        fromTxtField.inputView = datePicker
        toTextField.inputView = datePicker
        
        fromTxtField?.inputAccessoryView = pickerToolbar
        toTextField?.inputAccessoryView = pickerToolbar
        
        
        let leavesViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLeavesViewTap(_:)))
        self.view.addGestureRecognizer(leavesViewTap)
        
        createPickerView()
        dismissPickerView()
        
        
        let count = leavesModel?.model?.remaining?.count ?? 0
        let remLeaves = leavesModel?.model?.remaining
        
        for item in 0..<count {
            
            if let leaveType = leavesModel?.model?.remaining?[item], let leavesRemaining = leaveType.remainingDays {
                let casualLeaves = (leaveType.leaveName ?? "")  + " (" + leavesRemaining + ")" + " Days"
                leavesList.append(casualLeaves)
            }
        }
        

        
        
    }
    
    
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        fromTxtField?.resignFirstResponder()
        toTextField?.resignFirstResponder()
        
    }
    
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        
        if fromTxtField.isFirstResponder {
            fromTxtField.text = dateFormatter.string(from: datePicker.date)
            fromDate = datePicker.date
        }
        
        if toTextField.isFirstResponder {
            toTextField.text = dateFormatter.string(from: datePicker.date)
            toDate = datePicker.date
        }
        
        
    }
        
    
    func getLeaveName() -> String {
        
        if selectedLeave.contains("Casual") {
            leaveType = "Casual"
        } else if selectedLeave.contains("Earned") {
            leaveType = "Earned"
        } else if selectedLeave.contains("Maternity"){
            leaveType = "Maternity"
        } else if selectedLeave.contains("Paternity"){
            leaveType = "Paternity"
        } else if selectedLeave.contains("Bereavement"){
            leaveType = "Bereavement"
        }
        
        return leaveType
    }
    
    @IBAction func applyLeaveClick(_ sender: Any) {
        
        
        if (!validateCharactersCauseField()){
            self.view.makeToast("Please mention reason of leave in at atleast 10 characters")
            return
        }
        
        if(!validateRemainingLeavesCounter()) {
            self.showAlertView()
            return
        }
        
        
        
        self.indicatorView.startAnimating()
        let token  = GenericMethods.getToken()
        let fromDate = GenericMethods.changeDateFormat(dateString: fromTxtField.text ?? "")
        let toDate = GenericMethods.changeDateFormat(dateString: toTextField.text ?? "")
        let cause = causeTextView.text
        let leaveType = getLeaveName()
        
        
        let defaults = UserDefaults.standard
        defaults.set(fromDate, forKey: "LEAVEAPPLYDATE")
        defaults.synchronize()
        
        
        let body = ["token": token, "leaveType" : leaveType ,"dateFrom" : fromDate,"dateTo" : toDate,"reason" : cause]
        
        viewModel?.applyNewLeave(body:body as [String : Any] ,completionHandler: { [weak self] (data , error) in
            
            if let dateModel = data, dateModel.status == true {
                
                self?.viewModel?.saveLeaveType(leaveType: self?.leaveType ?? "", noofDays: self?.noofDaysCounter ?? 0)
                
                DispatchQueue.main.async {
                    self?.indicatorView.stopAnimating()

                    self?.navigationController?.popViewController(animated: true)
                }
            }
            else{
                DispatchQueue.main.async {
                    self?.indicatorView.stopAnimating()
                    self?.view.makeToast(data?.message)
                }
            }
            
//            DispatchQueue.main.async {
//                self?.indicatorView.stopAnimating()
//            }
            
        })
        
    }
    
    
    func showAlertView(){
        
        // create the alert
        let alert = UIAlertController(title: "Insufficient Leave !", message: "You do not have sufficient leave balance,Please check your leave balance and apply again.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func validateCharactersCauseField() -> Bool{
        
        if(causeTextView.text.count <=  10) {
            self.view.makeToast("Please mention reason of leave in at atleast 10 characters")
            return false
        }
        return true
        
    }
    
    func validateRemainingLeavesCounter() -> Bool {
        
        
        let leaveCounter = self.viewModel?.getLeaveCounter(leaveType: leaveType)
        
        if leaveType == "Casual" {
            
            let remLeavesModel = leavesModel?.model?.remaining?[0] as? LeaveBalanceModel
            var leaveDays = remLeavesModel?.leaveDays ?? ""
            
            let leaveDaysInt = Int(leaveDays) ?? 0
            
            if leaveDaysInt > leaveCounter ?? 0 {
                return true
            }
            
            return false
            
            
        } else if leaveType == "Earned" {
            
            let remLeavesModel = leavesModel?.model?.remaining?[1] as? LeaveBalanceModel
            var leaveDays = remLeavesModel?.leaveDays ?? ""
            
            let leaveDaysInt = Int(leaveDays) ?? 0
            
            if leaveDaysInt > leaveCounter ?? 0 {
                return true
            }
            
            return false
            
            
        }
        else if leaveType == "Maternity Leave"{
            
            let remLeavesModel = leavesModel?.model?.remaining?[2] as? LeaveBalanceModel
            var leaveDays = remLeavesModel?.leaveDays ?? ""
            
            let leaveDaysInt = Int(leaveDays) ?? 0
            
            if leaveDaysInt > leaveCounter ?? 0 {
                return true
            }
            
            return false
            
        }
        else if leaveType == "Paternity Leave"{
            
            let remLeavesModel = leavesModel?.model?.remaining?[2] as? LeaveBalanceModel
            var leaveDays = remLeavesModel?.leaveDays ?? ""
            
            let leaveDaysInt = Int(leaveDays) ?? 0
            
            if leaveDaysInt > leaveCounter ?? 0 {
                return true
            }
            
            return false
            
        }
        else if leaveType == "Paternity Leave" {
            let remLeavesModel = leavesModel?.model?.remaining?[2] as? LeaveBalanceModel
            var leaveDays = remLeavesModel?.leaveDays ?? ""
            
            let leaveDaysInt = Int(leaveDays) ?? 0
            
            if leaveDaysInt > leaveCounter ?? 0 {
                return true
            }
            
            return false
            
        }
    
        
        return true
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "New Leave"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        let image = UIImage(systemName: "chevron.backward")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:  .plain, target: self, action:  #selector(self.backAction(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
        
    }
    
    

    
    
    @objc func backAction(_ sender: UIBarButtonItem? = nil) {
        print("Button click...")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func handleLeavesViewTap(_ sender: UITapGestureRecognizer? = nil) {
        
        
        if let fromText = fromTxtField.text , !fromText.isEmpty , let toText = toTextField.text, !toText.isEmpty {
            
                
                let calendar = Calendar.current
                
                let FromDate = calendar.startOfDay(for: fromDate)
                
                let ToDate = calendar.startOfDay(for: toDate)
                
                let numberOfDays = calendar.dateComponents([.day], from: FromDate, to: ToDate)
                
                
                if let noofDays =  numberOfDays.day {
                    
                    let numberofDaysStr = noofDays + 1
                    
                    print("Number of days***",numberOfDays)
                    
                    
                    if numberofDaysStr > 1 {
                        
                        leavetext = "APPLY FOR " + String(numberofDaysStr) + ""  + " DAYS" + " LEAVE"
                    }
                    else if numberofDaysStr == 1{
                        
                        leavetext = "APPLY FOR " + String(numberofDaysStr) + ""  + " DAY" + " LEAVE"
                    }
                    else{
                        
                        leavetext = "APPLY LEAVE"
                        
                    }
                    
                    noofDaysCounter = numberofDaysStr
                    print("LOCAL COUNTER****",noofDaysCounter)
                }
                
                
                else{
                    
                    leavetext = "APPLY LEAVE"
                    noofDaysCounter = 0
                    
                }
                
                
        } else{
            leavetext = "APPLY LEAVE"

        }
        
        
        applyLeavesBtn.setTitle(leavetext, for: .normal)
        self.view.endEditing(true)
        
        
    }
    
    func configureUI(){
        
        causeTextView.delegate = self
        causeTextView.text = "Cause"
        causeTextView.textColor = .lightGray
        causeTextView.layer.cornerRadius = 5
        causeTextView.layer.borderWidth = 0.5
        causeTextView.layer.borderColor  = UIColor.lightGray.cgColor
        
        applyLeavesBtn.layer.cornerRadius = 6
        applyLeavesBtn.backgroundColor = GenericColours.myCustomGreen
        applyLeavesBtn.setTitleColor(.white, for: .normal)
        applyLeavesBtn.setTitle("APPLY LEAVE", for: .normal)
        applyLeavesBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        toTextField.delegate = self
        fromTxtField.delegate = self
        
    }
    
    //      @objc func dateChanged() {
    //          fromTxtField.text = dateFormatter.string(from: datePicker.date)
    //          toTextField.text = dateFormatter.string(from: datePicker.date)
    //      }
    
    func createUIToolBar() {
        
        pickerToolbar = UIToolbar()
        pickerToolbar?.autoresizingMask = .flexibleHeight
        
        //customize the toolbar
        pickerToolbar?.barStyle = .default
        pickerToolbar?.barTintColor = UIColor.black
        pickerToolbar?.backgroundColor = UIColor.white
        pickerToolbar?.isTranslucent = false
        
        //add buttons
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:
                                            #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor.white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                                            #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor.white
        
        //add the items to the toolbar
        pickerToolbar?.items = [cancelButton, flexSpace, doneButton]
        
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
    
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        leavesTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        leavesTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
    

    
    
}





extension ApplyNewLeaveVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leavesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return leavesList[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedLeave = leavesList[row]
        
        print("selectedLeave***",selectedLeave)
        
        leavesTextField.text = selectedLeave
    }
    
    
}


extension ApplyNewLeaveVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Cause" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = "Cause ..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText = textView.text!
        newText.removeAll { (character) -> Bool in
            return character == " " || character == "\n"
        }
        
        return (newText.count + text.count) <= 40
    }
    
}


